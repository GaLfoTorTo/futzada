import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/models/game_model.dart';
import 'package:esportly/presentation/controllers/game_controller.dart';

//===MIXIN - PARTIDAS===
mixin GameScheduleMixin on ChangeNotifier implements GameBase {
  //RESGATAR DATA DO DIA
  final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  //ESTADOS - PARTIDAS
  bool _loadGames = false;
  bool get loadGames => _loadGames;
  set loadGames(bool v) { _loadGames = v; notifyListeners(); }

  bool _hasGames = true;
  bool get hasGames => _hasGames;
  set hasGames(bool v) { _hasGames = v; notifyListeners(); }

  bool _loadHistoricGames = false;
  bool get loadHistoricGames => _loadHistoricGames;
  set loadHistoricGames(bool v) { _loadHistoricGames = v; notifyListeners(); }

  //ESTADO - QTD CARDS VISIVEIS
  int _qtdView = 3;
  int get qtdView => _qtdView;
  set qtdView(int v) { _qtdView = v; notifyListeners(); }

  //ESTADO - PARTIDAS (EM CURSO, PROXIMAS, AGENDADAS, FINALIZADAS)
  final List<GameModel?> _inProgressGames = [];
  List<GameModel?> get inProgressGames => _inProgressGames;

  final List<GameModel?> _nextGames = [];
  List<GameModel?> get nextGames => _nextGames;

  final List<GameModel?> _scheduledGames = [];
  List<GameModel?> get scheduledGames => _scheduledGames;

  final Map<String, List<GameModel>?> _finishedGames = {};
  Map<String, List<GameModel>?> get finishedGames => _finishedGames;

  //FUNÇÃO PARA VERIFICAR SE EVENTO É HOJE
  bool isToday() {
    return today.isAtSameMomentAs(eventDate!);
  }

  //FUNÇÃO DE BUSCA DE HISTÓRICO
  Future<bool> getHistoricGames() async {
    loadHistoricGames = false;
    Map<String, List<GameModel>> mapGames = {};
    try {
      await Future.delayed(const Duration(seconds: 3));
      _finishedGames.clear();
      final games = gameService.getListGames(event!);
      if (games.isNotEmpty) {
        for (var item in games) {
          final dateKey = DateFormat('d/MM').format(item!.createdAt!);
          mapGames.putIfAbsent(dateKey, () => []).add(item);
        }
        _finishedGames.addAll(mapGames);
      }
      notifyListeners();
      return true;
    } catch (e) {
      print('Erro ao buscar partidas: $e');
      return false;
    }
  }

  //FUNÇÃO PARA ADICIONAR PARTIDA AO ARRAY DE PARTIDAS FINALIZADAS
  void addGameHistoric(GameModel game) {
    String data = DateFormat('d/MM').format(game.createdAt!);
    if (_finishedGames.containsKey(data)) {
      _finishedGames[data]!.add(game);
      _finishedGames[data] = List.from(_finishedGames[data]!);
    } else {
      _finishedGames[data] = [game];
    }
    notifyListeners();
  }

  //FUNÇÃO DE BUSCA DE PARTIDAS DO EVENTO
  Future<bool> setGamesEvent(EventModel event) async {
    loadGames = false;
    try {
      await Future.delayed(const Duration(seconds: 3));
      final games = gameService.getListGames(event);
      if (today.isAtSameMomentAs(eventDate!)) {
        if (games.isNotEmpty) {
          _nextGames.clear();
          _nextGames.addAll(games);
          hasGames = true;
        }
      } else {
        if (games.isNotEmpty) {
          _scheduledGames.clear();
          _scheduledGames.addAll(games);
          hasGames = true;
        }
      }
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      print('=== ERRO COMPLETO ===');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      print('=====================');
      hasGames = false;
      return true;
    }
  }

  //FUNÇÃO PARA DEFINIR QUANTIDADE DE ITENS VISIVEIS
  void setView(bool view, int qtdGamesList) {
    if (view) {
      int increment = qtdGamesList - qtdView;
      qtdView = increment > 3 ? qtdView + 3 : qtdView + increment;
    } else {
      qtdView = qtdView - 3 > 3 ? qtdView - 3 : 3;
    }
  }
}
