import 'package:flutter/foundation.dart';
import 'package:esportly/presentation/controllers/game_controller.dart';

//===MIXIN - VOTES===
mixin GameVotesMixin on ChangeNotifier implements GameBase {
  //ESTADOS - VOTOS
  int _votesGameCount = 25;
  @override
  int get votesGameCount => _votesGameCount;
  set votesGameCount(int v) { _votesGameCount = v; notifyListeners(); }

  int _votesMVPCount = 25;
  @override
  int get votesMVPCount => _votesMVPCount;
  set votesMVPCount(int v) { _votesMVPCount = v; notifyListeners(); }

  final Map<String, double> _votesGame = {};
  @override
  Map<String, double> get votesGame => _votesGame;

  final Map<String, int> _votesMVP = {};
  @override
  Map<String, int> get votesMVP => _votesMVP;

  //FUNÇÃO DE DEFINIÇÃO DE OPÇÕES DE VOTO
  void setVotesGame() {
    _votesGame.clear();
    _votesGame.addAll({
      "team1": 70,
      "draw": 20,
      "team2": 10,
    });
    notifyListeners();
  }

  //FUNÇÃO DE DEFINIÇÃO DE OPÇÕES DE VOTO MVP
  void setVotesMVP() {
    _votesMVP.clear();
    notifyListeners();
  }
}
