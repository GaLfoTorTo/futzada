import 'dart:async';
import 'package:get/get.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/models/game_model.dart';
import 'package:futzada/data/models/snapshot_model.dart';
import 'package:futzada/data/models/game_event_model.dart';
import 'package:futzada/data/services/game_stream_service.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';

mixin GameStreamMixin on GetxController implements GameBase{
  //RESGATAR SERVIÇO DE STREAM 
  GameStreamService get streamService => Get.find<GameStreamService>();

  //ESTADO - CONEXÃO DE STREAM
  ConnectionState get streamState => streamService.connectionState.value;
  StreamSubscription<SnapshotModel>? streamSub;
  
  //ACESSORES DE PARTIDA ATUAL
  set currentGame(GameModel game);

  //FUNÇÃO DE CONEXÃO AO CANAL DE STREAM
  void connectChannel({required String uuid}) {
    streamService.connect(uuid: uuid);
    streamSub?.cancel();
    streamSub = streamService.messages.listen(handleStream);
  }

  //FUNÇÃO DE DESCONEXÃO DE CANAL DE STREAM
  void disconnectChannel() {
    streamSub?.cancel();
    streamSub = null;
    streamService.disconnect();
  }

  //FUNÇÃO DE ROTEAMENTO DE MENSAGENS
  void handleStream(SnapshotModel message) {
    //VERIFICAR TIPO DE MENSAGEM RECEBIDA
    if (message.type == SnapshotType.unknown) return;

    //VERIFICAR SE SE MENSAGENS RECEBIDAS SÃO DA PARTIDA DO EVENTO
    if (message.gameId != currentGame.id) return;

    //MAPEAMENTO DE MENSAGEMS
    if(message.type == SnapshotType.action) updateAction(message.payload);
  }

  //FUNÇÃO DE MAPEAMENTO DE EVENTOS DA PARTIDA
  void updateAction(Map<String, dynamic> payload) {
    //RESGATAR ACTION
    GameEvent actionType = GameEvent.values[payload['action']];
    //MAPEAMENTO DE EVENTOS DA PARTIDA
    switch (actionType) {
      //INICIAR PARTIDA/ INICIALIZAR PRORROGAÇÃO
      case GameEvent.StartGame:
      case GameEvent.ExtraTime:
      case GameEvent.ExtraTimeStart:
        isGameRunning.value = true;
        currentGame = currentGame.copyWith(status: GameStatus.InProgress);
        break;
      //FINALIZAR PARTIDA / FINALIZAR PRORROGAÇÃO
      case GameEvent.EndGame:
      case GameEvent.ExtraTimeEnd:
        isGameRunning.value = false;
        currentGame = currentGame.copyWith(status: GameStatus.Completed);
        break;
      //FIM PRIMEIRO TEMPO
      case GameEvent.HalfTimeEnd:
        isGameRunning.value = false;
        break;
      //PENALTIES
      case GameEvent.Penalties:
        currentGame = currentGame.copyWith(status: GameStatus.Completed);
        break;
      //GOL
      case GameEvent.Goal:
        final team = payload['team'] as String? ?? '';
        if (team == 'A') {
          teamAScore.value++;
        } else {
          teamBScore.value++;
        }
        break;
      //ESCANTEIOS
      case GameEvent.Corner:
        final team = payload['team'] as String? ?? '';
        if (team == 'A') {
          teamACorners.value++;
        } else {
          teamBCorners.value++;
        }
        break;
      //IMPEDIMENTOS
      case GameEvent.Offside:
      final team = payload['team'] as String? ?? '';
        if (team == 'A') {
          teamAOffside.value++;
        } else {
          teamBOffside.value++;
        }
        break;
      //FALTAS
      case GameEvent.Foul:
      case GameEvent.FoulTaken:
        final team = payload['team'] as String? ?? '';
        if (team == 'A') {
          teamAFouls.value++;
        } else {
          teamBFouls.value++;
        }
        break;
      //CARTÃO AMARELO
      case GameEvent.YellowCard:
        final team = payload['team'] as String? ?? '';
        if (team == 'A') {
          teamAYellowCard.value++;
        } else {
          teamBYellowCard.value++;
        }
        break;
      //CRTÃO VERMELHO
      case GameEvent.RedCard:
        final team = payload['team'] as String? ?? '';
        if (team == 'A') {
          teamARedCard.value++;
        } else {
          teamBRedCard.value++;
        }
        break;
      default:
        break;
    }
    //ADICIONAR EVENTO DA PARTIDA
    addGameEvent(payload, actionType);
  }

  //FUNÇÃO DE CRIAÇÃO DE EVENTO DA PARTIDA
  void addGameEvent(Map<String, dynamic> payload, GameEvent eventType) {
    try {
      final event = GameEventModel.fromMap({
        ...payload,
        'type': eventType,
        'timestamp': DateTime.now().toIso8601String(),
      });
      gameEvents.insert(0, event); // mais recente no topo
    } catch (_) {}
  }
}