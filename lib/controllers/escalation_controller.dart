import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:futzada/services/escalation_service.dart';
import 'package:futzada/services/market_service.dart';
import 'package:get/get.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/services/player_service.dart';
import 'package:futzada/models/player_model.dart';

class EscalationController extends GetxController{
  //DEFINIR CONTROLLER UNICO NO GETX
  static EscalationController get instace => Get.find();
  //INSTANCIAR SERVICE DE JOGADORES
  static EscalationService escalationService = EscalationService();
  //INSTANCIAR SERVICE DE JOGADORES
  static PlayerService playerService = PlayerService();
  //INSTANCIAR SERVICE DE JOGADORES
  static MarketService _marketService = MarketService();

  //CONTROLADOR DE INPUT DE PESQUISA
  final TextEditingController pesquisaController = TextEditingController();

  //CONTROLADOR DE CATEGORIA DO CAMPO
  final String category = 'Futebol';
  
  //FORMAÇÃO SELECIONADA
  String selectedFormation = '4-3-3';
  
  //CONTROLADOR DE EVENTO SELECIONADO
  int selectedEvent = 0;

  //CONTROLADOR DE PATRIMONIO DO USUARIO
  RxDouble userPatrimony = 100.0.obs;

  //CONTROLADOR DE PREÇO DA EQUIPE DO USUARIO
  RxDouble userTeamPrice = 0.0.obs;

  //CONTROLADOR DE INDEX PARA JOGADOR ADICIONADO OU REMOVIDO
  RxInt selectedPlayer = 0.obs;
  
  //CONTROLADOR DE OCUPAÇÃO DO JOGADOR NA ESCALAÇÃO
  RxString selectedOcupation = ''.obs;
  
  //CONTROLADOR DE OCUPAÇÃO DO JOGADOR NA ESCALAÇÃO
  RxInt playerCapitan = 0.obs;

  //CONTROLADOR DE FORMAÇÕES 
  List<String> formations = [];

  //CONTROLADOR DE FILTROS 
  RxMap<String, dynamic> filtrosMarket = _marketService.filtrosMarket.obs;
  
  //LISTA DE FILTROS DO MERCADO
  Map<String, List<Map<String, dynamic>>> filterOptions = _marketService.filterOptions;
  
  //LISTA DE FILTROS DO MERCADO
  Map<String, List<Map<String, dynamic>>> filterPlayerOptions = _marketService.filterPlayerOptions;

  //LISTA DE EVENTOS DO USUARIO
  RxList<Map<String, dynamic>> myEvents = [
    /* for(var i = 0; i <= 2; i++) */
      {
        'id' : 0,
        'title': 'Fut dos Cria',
        'photo': null,
      },
      {
        'id' : 1,
        'title': 'Pelada Divineia',
        'photo': null,
      },
      {
        'id' : 2,
        'title': 'Ginásio',
        'photo': null,
      },
  ].obs;
  
  //LISTA DE ESCALASÕES DO USUARIO
  RxList<Map<String, dynamic>> myEscalations = [
    /* for(var i = 0; i <= 2; i++) */
      {
        'id' : 0,
        'title': 'Fut dos Cria',
        'photo': null,
      },
      {
        'id' : 1,
        'title': 'Pelada Divineia',
        'photo': null,
      },
      {
        'id' : 2,
        'title': 'Ginásio',
        'photo': null,
      },
  ].obs;

  //JOGADORES DO MERCADO
  late RxList<PlayerModel> playersMarket;
  
  //ESCALAÇÃO DO USUARIO
  late RxMap<String, RxMap<int, PlayerModel?>> escalation;

  @override
  void onInit() {
    super.onInit();
    //DEFINIR JOGADORES DO MERCADO
    playersMarket = filterMarketPlayers();
    //DEFINIR ESCALAÇÃO DO USUARIO
    escalation = escalationService.setEscalation(category);
    //DEFINIR ARRAY DE FORMAÇÕES APARTIR DE CATEGORIA SELECIONADA
    formations = escalationService.formationsPerCategory(category);
    //DEFINIR ESCALAÇÃO PRÉ SELECIONADA
    selectedFormation = formations[0];
  }

  //FUNÇÃO PARA CONTABILIZAR PREÇO DA EQUIPE E PATRIMONIO DO USUARIO
  void calcTeamPrice(double playerPrice, String action){
    //ARREDONDAR VALOR DO JOGADOR RECEBIDO
    final roundedPrice = double.parse(playerPrice.toStringAsFixed(2));
    //VERIFICAR FLAG DE AÇÃO
    if (action == 'add') {
      //ADICIONAR PREÇO DO JOGADOR AO PREÇO DA EQUIPE
      userTeamPrice.value = double.parse((userTeamPrice.value + roundedPrice).toStringAsFixed(2));
      //DESCONTAR PREÇO DO JOGADOR DO PATRIMONIO DO USUARIO
      userPatrimony.value = double.parse((userPatrimony.value - roundedPrice).toStringAsFixed(2));
    } else {
      //DESCONTAR PREÇO DO JOGADOR AO PREÇO DA EQUIPE
      userTeamPrice.value = double.parse((userTeamPrice.value - roundedPrice).toStringAsFixed(2));
      //ADICIONAR PREÇO DO JOGADOR DO PATRIMONIO DO USUARIO
      userPatrimony.value = double.parse((userPatrimony.value + roundedPrice).toStringAsFixed(2));
    }
  }

  //FUNÇÃO PARA RESETAR FILTRO
  void resetFilter(){
    //RESETAR FILTRO
    filtrosMarket.value = _marketService.filtrosMarket;
  }

  //FUNÇÃO DE DEFINIÇÃO DE FILTRO DO MERCADO
  void setFilter(String name, dynamic newValue){
    //VERIFICAR SE NAME E VALOR RECEBIDOS NÃO SETA VAZIOS
    if(name != 'positions' && name != 'status'){
      //ATUALIZAR CHAVE DO FILTRO
      filtrosMarket[name] = newValue;
    }
    //VERIFICAÇÃO PARA POSIÇÕES
    if(name == 'positions' || name == 'status'){
      //VERIFICAR SE RECEBIDO FOI POSIÇÃO E SE ESTA NO FORMATO DE ARRAY
      if(name == 'positions' && newValue is List<String>){
        //ATUALIZAR CHAVE DO FILTRO
        filtrosMarket[name] = newValue;
      }else{
        //RESGATAR POSIÇÕES SALVAS NO FILTRO
        final arr = filtrosMarket[name];
        //VERIFICAR SE POSIÇÃO RESCEBIDA ESTA NO FILTRO
        if (arr.contains(newValue)) {
          //REMOVER POSIÇÃO
          arr.remove(newValue);
        } else {
          //ADICIONAR POSIÇÃO
          arr.insert(0, newValue);
        }
        //REATRIBUIR POSIÇÕES NO FILTRO
        filtrosMarket[name] = arr; 
      }
    }
    //APLICAR FILTRO NOS JOGADORES DO MERCADO
    playersMarket.value = filterMarketPlayers();
  }

  //FUNÇÃO DE APLICAÇÃO DE FILTRO
  RxList<PlayerModel> filterMarketPlayers() {
    //RESGATAR FILTROS
    final filters = filtrosMarket;
    //RESGATAR JOGADORES DO MERCADO
    final players = playerService.playersMarket;
    //APLICAR FILTROS NÃO NÚMERICOS
    List<PlayerModel> filteredPlayers = players.where((player) {
      //FILTRO NOS STATUS
      if (filters['status'] != null && filters['status'].isNotEmpty && filters['status'] != 'Todos') {
        final selectedStatus = List<String>.from(filters['status']);
        //VERIFICAR STATUS DO JOGADOR
        final hasStatus = selectedStatus.any((status) => player.status == status );
        if (!hasStatus) {
          return false;
        }
      }

      //FILTRO DE PESQUISA DE NOME NOMES
      if(filters['search'] != null && filters['search'] != '') {
        final nome = filters['search'].toLowerCase();
        //VERIFICAR NOME DO JOGADOR
        if (!player.user.userName!.toLowerCase().contains(nome) &&
            !player.user.firstName!.toLowerCase().contains(nome) &&
            !player.user.lastName!.toLowerCase().contains(nome)) {
          return false;
        }
      }

      //FILTRO MELHOR PÉ
      if (filters['bestSide'] != null && 
          filters['bestSide'] != '' && 
          player.bestSide != filters['bestSide']) {
        return false;
      }

      //FILTRO POR POSIÇÕES
      if (filters['positions'] != null && filters['positions'].isNotEmpty) {
        final selectedPositions = List<String>.from(filters['positions']);
        final playerPositions = jsonDecode(player.positions) as List<dynamic>;
        //VERIFICAR SE JOGADOR CONTEM UMA DAS OPÇÕES DEFINIDAS NO FILTRO
        final hasPosition = selectedPositions.any((pos) => 
            player.mainPosition == pos || 
            playerPositions.contains(pos));
        //VERIFICAR SE JOGADOR NÃO TEM POSIÇÃO DEFINIDA NO FILTRO            
        if (!hasPosition) {
          return false;
        }
      }

      return true;
    }).toList();

    //ORDENAÇÃO DE NUMERICOS
    if (filters['price'] != null && filters['price'] != '') {
      filteredPlayers.sort((a, b) {
        if (filters['price'] == 'Maior preço') {
          //ORDEM POR MAIOR PREÇO
          return b.price!.compareTo(a.price!); 
        } else {
          //ORDEM POR MENO PREÇO
          return a.price!.compareTo(b.price!);
        }
      });
    }
    //ORDENAR PO MÉDIA
    if (filters['media'] != null && filters['media'] != '') {
      filteredPlayers.sort((a, b) {
        if (filters['media'] == 'Maior média') {
          //ORDEM POR MAIOR MÉDIA
          return b.media!.compareTo(a.media!);
        } else {
          //ORDEM POR MENOR MÉDIA
          return a.media!.compareTo(b.media!);
        }
      });
    }
    //ORDENAR POR QUANTIDADE DE JOGOS
    if (filters['game'] != null && filters['game'] != '') {
      filteredPlayers.sort((a, b) {
        if (filters['game'] == 'Mais jogos') {
          //ORDEM POR MAIS JOGOS
          return b.games!.compareTo(a.games!);
        } else {
          //ORDEM POR MENOS JOGOS
          return a.games!.compareTo(b.games!);
        }
      });
    }
    //ORNDENAR POR VALORIZAÇÃO
    if (filters['valorization'] != null && filters['valorization'] != '') {
      filteredPlayers.sort((a, b) {
        if (filters['valorization'] == 'Maior valorização') {
          //ORDEM POR MAIOR VALORIZAÇÃO
          return b.valorization!.compareTo(a.valorization!);
        } else {
          //ORDEM POR MENOR VALORIZAÇÃO
          return a.valorization!.compareTo(b.valorization!);
        }
      });
    }
    //ORDENAR POR ULTIMA PONTUAÇÃO
    if (filters['lastPontuation'] != null && filters['lastPontuation'] != '') {
      filteredPlayers.sort((a, b) {
        if (filters['lastPontuation'] == 'Maior pontuação') {
          //ORDEM POR MAIOR PONTUAÇÃO
          return b.lastPontuation!.compareTo(a.lastPontuation!);
        } else {
          //ORDEM POR MENOR PONTUAÇÃO
          return a.lastPontuation!.compareTo(b.lastPontuation!);
        }
      });
    }
    //FILTRO DE ORDENAÇÃO POR NOME
    if(filters['nome'] != null && filters['nome'] != '') {
      filteredPlayers.sort((a, b) {
        return a.user.firstName!.toLowerCase().compareTo(b.user.firstName!.toLowerCase());
      });
    }
  //RETORNAR JOGADORES FILTRADOS E ORDENADOS
  return filteredPlayers.obs;
}

  //FUNÇÃO PARA ADICIONAR OU REMOVER JOGADOR DA ESCALAÇÃO
  void setPlayerEscalation(dynamic id){
    //RESGATR JOGADOR DO MERCADO
    final player = playerService.findPlayer(id);
    //VERIFICAR SE JOGADOR FOI ENCONTRADO
    if (player == null) {
      //EXIBIR MENSAGEM DE ERRO
      AppHelper.erroMessage(Get.context, 'Jogador não encontrado!');
      return;
    }
    try {
      //VERIFICAR EM QUE OCUPAÇÃO O JOGADOR ESTA NA ESCALAÇÃO
      bool isEscaled = verifyPlayerEscalation(player);
      //RESGATAR CONTROLADORES DE OCUPACAO E INDEX DO JOGADOR
      int playerIndex = selectedPlayer.value;
      String playerOcupation = selectedOcupation.value;
      //VERIFICAR SE JOGADOR JÁ ESTA ESCALADO
      if(!isEscaled){
        //ADICIONAR JOGADOR NA POSIÇÃO
        escalation[playerOcupation]![playerIndex] = player;
        //CALCULAR PATRIMONIO DISPONIVEL E PREÇO DA EQUIPE
        calcTeamPrice(player.price!, 'add');
      }else{
        //REMOVER JOGADOR DA POSIÇÃO
        escalation[playerOcupation]![playerIndex] = null;
        //CALCULAR PATRIMONIO DISPONIVEL E PREÇO DA EQUIPE
        calcTeamPrice(player.price!, 'remove');
      }
    } catch (e) {
      print(e);
      //EXIBIR MENSAGEM DE ERRO
      AppHelper.erroMessage(Get.context, 'Houve um erro, Tente novamente!');
    }
    //RESETAR POSIÇÃO E OCUPAÇÃO DO JOGADOR SELECIONADO
    selectedPlayer.value = 0;
    selectedOcupation.value = '';
  }
  
  //FUNÇÃO PARA VERIFICAR SE JOGADOR JA FOI ESCALADO
  bool verifyPlayerEscalation(PlayerModel player){
    //PERCORRER ESCALAÇÕES DO USUARIO (STARTERS E RESERVES)
    for (var arr in escalation.entries){
      //RESGATAR CHAVE
      var chave = arr.key;
      //RESGATAR LISTA POR CHAVE
      var map = arr.value;
      //LOOP NA LISTA
      for (int i = 0; i < map.length; i++) {
        //VERIFICAR SE JOGADOR FOI ESCALADO COMO TITULAR OU RESERVA
        if (map[i] == player) {
          //ATUALIZAR INDEX E OCUPAÇÃOS
          selectedPlayer.value = i;
          selectedOcupation.value = chave;
          return true;
        }
      }
    }
    return false;
  }
  
  //FUNÇÃO DE BUSCA DE JOGADOR NA ESCALAÇÃO
  bool findPlayerEscalation(int id) {
    //PERCORRER ESCALAÇÕES DO USUARIO (STARTERS E RESERVES)
    for (var arr in escalation.entries){
      //RESGATAR LISTA POR CHAVE
      var map = arr.value;
      //LOOP NA LISTA
      for (int i = 0; i < map.length; i++) {
        //VERIFICAR SE JOGADOR FOI ESCALADO COMO TITULAR OU RESERVA
        if (map[i] != null && map[i]!.id == id) {
          return true;
        }
      }
    }
    return false;
  }

  //FUNÇÃO PARA DEFINIR POSIÇÃO DINAMICAMENTE (TEMPORARIAMENTE)
  String getPositionFromEscalation(i){
    if(i == 0){
      return 'gol';
    }else if(i ==  1 || i ==  2 || i == 3 || i == 4){
      return 'zag';
    }else if(i ==  5 || i == 6 || i == 7){
      return 'mei';
    }else{
      return 'ata';
    }
  }

  //FUNÇÃO PARA DEFINIR JOGADOR COMO CAPITÃO
  void setPlayerCapitan(dynamic id){
    try {
      //VERIFICAR EM QUE OCUPAÇÃO O JOGADOR ESTA NA ESCALAÇÃO
      bool isEscaled = findPlayerEscalation(id);
      //VERIFICAR SE JOGADOR FOI ENCONTRADO NA ESCALÇÃO
      if(isEscaled){
        //VERIFICAR SE JOGADOR JA ESTA DEFINIDO COMO CAPITÃO
        if(playerCapitan.value == id){
          //REMOVER CAPITÃO
          playerCapitan.value = 0;
        }else{
          //ADICIONAR ID DO JOGADOR CAPITÃO
          playerCapitan.value = id;
        }
      }
    } catch (e) {
      print(e);
      //EXIBIR MENSAGEM DE ERRO
      AppHelper.erroMessage(Get.context, 'Houve um erro, Tente novamente!');
    }
  }
}