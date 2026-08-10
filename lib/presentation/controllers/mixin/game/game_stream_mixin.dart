import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:futzada/core/di/service_locator.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/models/game_model.dart';
import 'package:futzada/data/models/snapshot_model.dart';
import 'package:futzada/data/models/game_event_model.dart';
import 'package:futzada/data/services/game_stream_service.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';

mixin GameStreamMixin on ChangeNotifier implements GameBase {
  //RESGATAR SERVIÇO DE STREAM
  GameStreamService get streamService => sl<GameStreamService>();

  //ESTADO - CONEXÃO DE STREAM
  ConnectionState get streamState => streamService.connectionState;
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
    if (message.type == SnapshotType.unknown) return;
    if (message.gameId != currentGame.id) return;
    if (message.type == SnapshotType.action) updateAction(message.payload);
  }

  //FUNÇÃO DE MAPEAMENTO DE EVENTOS DA PARTIDA
  void updateAction(Map<String, dynamic> payload) {
    GameEvent actionType = GameEvent.values[payload['action']];
    switch (actionType) {
      case GameEvent.StartGame:
      case GameEvent.ExtraTime:
      case GameEvent.ExtraTimeStart:
        isGameRunning = true;
        currentGame = currentGame.copyWith(status: GameStatus.InProgress);
        break;
      case GameEvent.EndGame:
      case GameEvent.ExtraTimeEnd:
        isGameRunning = false;
        currentGame = currentGame.copyWith(status: GameStatus.Completed);
        break;
      case GameEvent.HalfTimeEnd:
        isGameRunning = false;
        break;
      case GameEvent.Penalties:
        currentGame = currentGame.copyWith(status: GameStatus.Completed);
        break;
      case GameEvent.Goal:
        final team = payload['team'] as String? ?? '';
        if (team == 'A') {
          teamAScore++;
        } else {
          teamBScore++;
        }
        break;
      case GameEvent.Corner:
        final team = payload['team'] as String? ?? '';
        if (team == 'A') {
          teamACorners++;
        } else {
          teamBCorners++;
        }
        break;
      case GameEvent.Offside:
        final team = payload['team'] as String? ?? '';
        if (team == 'A') {
          teamAOffside++;
        } else {
          teamBOffside++;
        }
        break;
      case GameEvent.Foul:
      case GameEvent.FoulTaken:
        final team = payload['team'] as String? ?? '';
        if (team == 'A') {
          teamAFouls++;
        } else {
          teamBFouls++;
        }
        break;
      case GameEvent.YellowCard:
        final team = payload['team'] as String? ?? '';
        if (team == 'A') {
          teamAYellowCard++;
        } else {
          teamBYellowCard++;
        }
        break;
      case GameEvent.RedCard:
        final team = payload['team'] as String? ?? '';
        if (team == 'A') {
          teamARedCard++;
        } else {
          teamBRedCard++;
        }
        break;
      default:
        break;
    }
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
      gameEvents.insert(0, event);
      notifyListeners();
    } catch (_) {}
  }
}
