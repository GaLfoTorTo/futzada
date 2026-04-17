// lib/features/event_room/services/game_websocket_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/models/snapshot_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:pusher_client_socket/pusher_client_socket.dart' as PUSHER;

class GameStreamService extends GetxService {
  //STREAM - MENSAGENS INTERNAS
  final streamController = StreamController<SnapshotModel>.broadcast();
  Stream<SnapshotModel> get messages => streamController.stream;

  //INSTANCIA DE STREAM/WEBSOCKET (.ENV)
  late Echo<PUSHER.PusherClient, PusherChannel> echo;

  //ESTADO - CONEXÃO
  final String token = GetStorage().read('token');
  final connectionState = Rx<ConnectionState>(ConnectionState.disconnected);
  String? channel;
  bool disposed = false;
  Timer? timer;
  int attempts = 0;
  int maxAttempts = 5;
  
  //FUNÇÃO DE INICIALIZAÇÃO DO SERVIÇO
  @override
  void onReady(){
    super.onReady();
    //INICIALIZAR CONECTOR DE STREAM/WEBSOCKET
    echo = Echo<PUSHER.PusherClient, PusherChannel>(PusherConnector(
      dotenv.env['PUSHER_APP_KEY']!,
      authHeaders: () async => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      authEndPoint: dotenv.env['PUSHER_APP_AUTH']!,
      host: dotenv.env['PUSHER_APP_HOST'],
      wsPort: 6001,
      wssPort: 443,
      nameSpace: 'nameSpace',
      cluster: 'mt1',
      encrypted: true,
      activityTimeout: 120000,
      pongTimeout: 30000,
      enableLogging: true,
      autoConnect: true,
      maxReconnectionAttempts: 3,
    ));
  }

  //FUNÇÃO DE CONEXÃO E INSCRIÇÃO NO CANAL DE STREAM 
  Future<void> connect({required String uuid}) async {
    //DEFINIR CANAL DE CONEXÃO
    final channelName = 'event.$uuid';
    //VERIFICAR CONEXÃO DO USUARIO NO CANAL
    if (channel == channelName && connectionState.value == ConnectionState.connected) return;
    //LIMPAR CONEXÃO ANTES DE INICIAR
    await disconnect(); 
    //ATUALIZAR STATUS DE CONEXÃO
    connectionState.value = ConnectionState.connecting;
    try {
      //CONEXTAR AO CANAL CONFIGURADO 
      echo.private(channelName)
        ..listen('GameSnapshotEvent', parsePayload)
        ..listen('GameActionEvent',   parsePayload)
        ..error(onChannelError);
      //ATUALIZAR ESTADOS DE CANAIS E CONEXÕES
      channel = channelName;
      connectionState.value = ConnectionState.connected;
      //LOG DE CONEXÃO
      debugPrint('[WS] Conectado ao canal: $channelName');
    } catch (e) {
      //ATUALZIAR ESTADO DE CONEXÃO
      connectionState.value = ConnectionState.error;
      //LOG DE CONEXÃO
      debugPrint('[WS] Erro ao conectar: $e');
      reconnect(uuid: uuid);
    }
  }

  //FUNÇÃO DE DESCONEXÃO
  Future<void> disconnect() async {
    timer?.cancel();
    echo.disconnect();
    channel = null;
    disposed = false;
    connectionState.value = ConnectionState.disconnected;
  }

  //FUNÇÃO DE RECONEXÃO
  void reconnect({required String uuid}) {
    if (attempts >= maxAttempts) {
      debugPrint('[WS] Máximo de tentativas atingido');
      return;
    }
    timer?.cancel();
    final delay = Duration(seconds: (5 * (1 << attempts)).clamp(5, 300)); 
    timer = Timer(delay, () {
      if (!disposed) {
        attempts++;
        connect(uuid: uuid);
      }
    });
  }

  //FUNÇÃO DE PARSEAMENTO DE PAYLOAD DO STREAM
  void parsePayload(dynamic payload) {
    try {
      final map = payload is String
        ? json.decode(payload) as Map<String, dynamic>
        : Map<String, dynamic>.from(payload as Map);

      final message = SnapshotModel.fromMap(map);
      if (!streamController.isClosed) {
        streamController.add(message);
      }
    } catch (e) {
      debugPrint('[WS] Erro ao parsear mensagem: $e');
    }
  }
  
  //FUNÇÃO DE ERRO DE CONEXÃO
  void onChannelError(dynamic error) {
    debugPrint('[WS] Erro no canal: $error');
    connectionState.value = ConnectionState.error;
  }

  //FUNÇÃO DE FECHAMENTO DO SERVIÇO
  @override
  void onClose() {
    disposed = true;
    timer?.cancel();
    streamController.close();
    echo.disconnect();
    super.onClose();
  }
}