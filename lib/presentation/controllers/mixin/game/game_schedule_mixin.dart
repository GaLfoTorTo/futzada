import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/game_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';

//===MIXIN - PARTIDAS===
mixin GameScheduleMixin on GetxController implements GameBase{
  //RESGATAR DATA DO DIA
  final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  //ESTADOS - PARTIDAS
  final loadGames = false.obs;
  final hasGames = true.obs;
  final loadHistoricGames = false.obs;
  //ESTADO - QTD CARDS VISIVEIS
  var qtdView = 3.obs; 
  //ESTADO - PARTIDAS (EM CURSO, PROXIMAS, AGENDADAS, FINALIZADAS)
  final RxList<GameModel?> inProgressGames = <GameModel?>[].obs;
  final RxList<GameModel?> nextGames = <GameModel?>[].obs;
  final RxList<GameModel?> scheduledGames = <GameModel?>[].obs;
  final RxMap<String, List<GameModel>?> finishedGames = <String, List<GameModel>?>{}.obs;

  //FUNÇÃO PARA VERIFICAR SE EVENTO É HOJE
  bool isToday(){
    return today.isAtSameMomentAs(eventDate!);
  }

  //FUNÇÃO DE BUSCA DE HISTÓRICO
  Future<bool> getHistoricGames() async {
    // RESETAR ESTADO DE CARREGAMENTO
    loadHistoricGames.value = false;
    //DEFINIR MAPA DE PARTIDAS DO HISTÓRICO
    Map<String, List<GameModel>> mapGames = {};
    try {
      //DELAY DE SIMULAÇÃO
      await Future.delayed(const Duration(seconds: 3));
      //REMOVER ITENS DO HISTÓRICO
      finishedGames.value = mapGames;
      //BUSCAR PARTIDAS DO EVENTO (SIMULAÇÃO)
      final games = gameService.getListGames(event!);
      //VERIFICAR SE EXISTEM PARTIDAS FINALIZADAS
      if (games.isNotEmpty) {
        //LOOP NAS PARTIDAS
        for (var item in games) {
          //RESGATAR DIA E MÊS DA PARTIDA
          final dateKey = DateFormat('d/MM').format(item!.createdAt!);
          //ADICIONAR PARTIDA AO MAPA
          mapGames.putIfAbsent(dateKey, () => []).add(item);
        }
        //RESGATAR PARTIDAS FINALIZADAS (HISTÓRICO)
        finishedGames.assignAll(mapGames);
      }
      //RETORNAR VALOR PARA ESTADO DE CARREGAMENTO
      return true;
    } catch (e) {
      print('Erro ao buscar partidas: $e');
      return false;
    }
  }
  
  //FUNÇÃO PARA ADICIONAR PARTIDA AO ARRAY DE PARTIDSA FINALIZADAS
  void addGameHistoric(GameModel game) {
    //RESGATAR DATA DE CRIAÇÃO DA PARTIDA
    String data = DateFormat('d/MM').format(game.createdAt!);
    //VERIFICAR SE OUTRA PARTIDA FOI FINALIZADA NO MESMO DIA
    if (finishedGames.containsKey(data)) {
      //ADICIONAR A CHAVE EXISTENTE
      finishedGames[data]!.add(game);
      finishedGames[data] = List.from(finishedGames[data]!);
    } else {
      //CRIAR NOVA CHAVE E ADICIONAR
      finishedGames[data] = [game];
    }
}
  
  //FUNÇÃO DE BUSCA DE PARTIDAS DO EVENTO
  Future<bool> setGamesEvent(EventModel event) async{
    //RESETAR ESTADO DE CARREGAMENTO
    loadGames.value = false;
    try {
      await Future.delayed(const Duration(seconds: 3));
      //BUSCAR PARTIDAS DO EVENTO (SIMULAÇÃO)
      final games = gameService.getListGames(event);
      //VERIFICAR SE EVENTO ESTA ACONTECENDO HOJE
      if(today.isAtSameMomentAs(eventDate!)){
        //VERIFICAR SE EXISTEM PARTIDAS FINALIZADAS
        if(games.isNotEmpty){
          //GERAR PROXIMAS PARTIDAS DO DIA 
          nextGames.assignAll(games.toList());
          //ATUALIZAR ESTADO DE PARTIDAS
          hasGames.value = true;
        }
      }else{
        //GERAR PARTIDAS PROGRAMADAS AUTOMATICAMENTE
        if(games.isNotEmpty){
          //GERAR PROXIMAS PARTIDAS DO DIA 
          scheduledGames.assignAll(games.toList());
          //ATUALIZAR ESTADO DE PARTIDAS
          hasGames.value = true;
        }
      }
      //RETORNAR VALOR PARA ESTADO DE CARREGAMENTO
      return true;
    } catch (e, stackTrace) {
      print('=== ERRO COMPLETO ===');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      print('=====================');
      //ATUALIZAR ESTADO DE CARREGAMENTO
      hasGames.value = false;
      //RETORNAR VALOR PARA ESTADO DE CARREGAMENTO
      return true;
    }
  }

  //FUNÇÃO PARA DEFINIR QUANTIDADE DE ITENS VISIVEIS
  void setView(bool view, int qtdGames){
    //VERIFICAR SE PRECISA EXIBIR OU ESCONDER PARTIDAS
    if(view){
      int increment = qtdGames - qtdView.value;
      qtdView.value = increment > 3 ? qtdView.value + 3 : qtdView.value + increment;
    }else{
      qtdView.value = qtdView.value - 3 > 3 ? qtdView.value - 3 : 3;
    }
  }
}