import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/models/snapshot_model.dart';
import 'package:futzada/data/services/game_stream_service.dart';
import 'package:futzada/core/providers/game/game_session_provider.dart';
import 'package:futzada/core/providers/game/game_match_provider.dart';

//ESTADO - GAME STREAM
class GameStreamState {
  final ConnectionState streamState;
  const GameStreamState({this.streamState = ConnectionState.disconnected});

  GameStreamState copyWith({ConnectionState? streamState}) => GameStreamState(streamState: streamState ?? this.streamState);
}

//NOTIFICADOR - GAME STREAM
class GameStreamNotifier extends Notifier<GameStreamState> {
  late final GameStreamService _streamService;
  StreamSubscription<SnapshotModel>? _streamSub;

  @override
  GameStreamState build() {
    _streamService = GameStreamService();
    ref.onDispose(disconnectChannel);
    return const GameStreamState();
  }

  //FUNÇÃO DE CONEXÃO NO CANAL DO EVENTO
  void connectChannel({required String uuid}) {
    _streamService.connect(uuid: uuid);
    _streamSub?.cancel();
    _streamSub = _streamService.messages.listen(_handleStream);
    state = state.copyWith(streamState: ConnectionState.connected);
  }

  //FUNÇÃO PARA DESCONECTAR DO CANAL DO EVENTO
  void disconnectChannel() {
    _streamSub?.cancel();
    _streamSub = null;
    _streamService.disconnect();
    state = state.copyWith(streamState: ConnectionState.disconnected);
  }

  //FUNÇÃO DE MANIPULAÇÃO DE STREAM
  void _handleStream(SnapshotModel message) {
    if (message.type == SnapshotType.unknown) return;
    final session = ref.read(gameSessionProvider);
    if (session.currentGame == null) return;
    if (message.gameId != session.currentGame!.id) return;
    if (message.type == SnapshotType.action) {
      ref.read(gameMatchProvider.notifier).applyStreamAction(message.payload);
    }
  }
}

//PROVIDER - GAME STREAM
final gameStreamProvider = NotifierProvider<GameStreamNotifier, GameStreamState>(GameStreamNotifier.new);
