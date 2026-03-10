import 'package:get/get.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';

//===MIXIN - VOTES===
mixin GameVotesMixin on GetxController implements GameBase{
  //ESTADOS - VOTOS
  @override
  RxInt votesGameCount = 25.obs;
  @override
  RxInt votesMVPCount = 25.obs;
  @override
  RxMap<String, double> votesGame = <String, double>{}.obs;
  @override
  RxMap<String, int> votesMVP = <String, int>{}.obs;

  //FUNÇÃO DE DEFINIÇÃO DE OPÇÕES DE VOTO
  void setVotesGame() {
    //LIMPAR LISTA
    votesGame.clear();
    //ADICIONAR JOGADORES DA EQUIPE A
    votesGame.value = {
      "team1": 70,
      "draw": 20,
      "team2": 10,
    };
  }
  //FUNÇÃO DE DEFINIÇÃO DE OPÇÕES DE VOTO
  void setVotesMVP() {
    //LIMPAR LISTA
    votesMVP.clear();
    //ADICIONAR JOGADORES DA EQUIPE A
    /* votesMVP.addAll({
      for (final p in teamA.players) event.participants.firstWhere((u) => u.id == p.userId).participants[0]!: 0,
    });
    //ADICIONAR JOGADORES DA EQUIPE B
    votesMVP.addAll({
      for (final p in teamB.players) event.participants.firstWhere((u) => u.id == p.userId).participants[0]!: 0,
    }); */
  }
}