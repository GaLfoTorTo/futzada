import 'dart:convert';
import 'package:futzada/models/escalation_model.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/services/manager_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/models/player_model.dart';
import 'package:futzada/services/escalation_service.dart';
import 'package:futzada/services/market_service.dart';
import 'package:futzada/services/participant_service.dart';

class EscalationController extends GetxController{
  //DEFINIR CONTROLLER UNICO NO GETX
  static EscalationController get instace => Get.find();
  //INSTANCIAR SERVIÇO DE ESCALAÇÃO
  static EscalationService escalationService = EscalationService();
  //INSTANCIAR SERVIÇO DE PARTICIPANTES
  static ParticipantService participantService = ParticipantService();
  //INSTANCIAR SERVIÇO DE MERCADO
  static MarketService marketService = MarketService();
  //INSTANCIAR SERVIÇO DE TECNICO
  static ManagerService managerService = ManagerService();

  //CONTROLADOR DE INPUT DE PESQUISA
  final TextEditingController pesquisaController = TextEditingController();

  //RESGATAR USUARIO LOGADO
  UserModel user = Get.find(tag: 'user');
  //LISTA DE EVENTOS DO USUARIO
  List<EventModel> myEvents = Get.find(tag: 'events');
  //ESTADO CONTROLADOR DE VERIFICAÇÃO SE USUÁRIO ESTA PARTICIPANDO DE UM EVENTO COMO TECNICO
  bool canManager = false;
  //ESTADO CONTROLADOR DE CATEGORIA DO EVENTO
  String selectedCategory = '';
  //ESTADO CONTROLLADOR DE FORMAÇÃO SELECIONADA
  String selectedFormation = '';
  //ESTADO CONTROLADOR DE INDEX DO JOGADOR NA ESCALAÇÃO
  RxInt selectedPlayer = 0.obs;
  //ESTADO CONTROLADOR DE SIGLA DE OCUPAÇÃO DO JOGADOR NA ESCALAÇÃO
  RxString selectedOcupation = ''.obs;
  //ESTADO CONTROLADOR DE ID DE CAPITÃO NA ESCALAÇÃO
  RxInt selectedPlayerCapitan = 0.obs;
  //ESTADO CONTROLADOR DE PATRIMONIO DO USUARIO
  RxDouble managerPatrimony = 100.0.obs;
  //ESTADO CONTROLADOR DE PREÇO DA EQUIPE DO USUARIO
  RxDouble managerTeamPrice = 0.0.obs;
  //ESTADO CONTROLADOR DE VALORIZAÇÃO DE PATRIMONIO DO USUARIO
  double managerValuation = 0.0;
  //ESTADO CONTROLADOR DE FORMAÇÕES DISPONIVIES POR CATEGORIA
  List<String> formations = [];

  //ESTADO DE FILTROS DO MERCADO
  RxMap<String, dynamic> filtrosMarket = marketService.filtrosMarket.obs;
  //LISTA DE OPÇÕES DE FILTROS DE METRICA
  Map<String, List<Map<String, dynamic>>> filterOptions = marketService.filterOptions;
  //LISTA DE OPÇÕES DE FILTROS DE USUARIO
  Map<String, List<Map<String, dynamic>>> filterPlayerOptions = marketService.filterPlayerOptions;

  //ESTADO CONTROLADOR DE ID DO EVENTO SELECIONADO
  late EventModel? selectedEvent;
  //LISTA DE ESCALAÇÕES DO USUARIO
  late RxList<Map<String, dynamic>> myEscalations;
  //LISTA DE JOGADORES DO MERCADO
  late RxList<ParticipantModel> playersMarket;
  //ESTADO DE ESCALAÇÃO DO USUARIO
  late RxMap<String, RxMap<int, ParticipantModel?>> escalation;
  //ESTADO DE ESCALAÇÃO DE TITULARES DO USUARIO
  RxMap<int, ParticipantModel?> starters = <int, ParticipantModel?>{}.obs;
  //ESTADO DE ESCALAÇÃO DE RESERVAS DO USUARIO
  RxMap<int, ParticipantModel?> reserves = <int, ParticipantModel?>{}.obs;

  @override
  void onInit() {
    super.onInit();
    //VERIFICAR SE USUARIO ESTA PARTICIPANDO DE ALGUM EVENTO
    if(myEvents.isNotEmpty){
      //VERIFICAR SE USUARIO ESTA HABILITADO COMO TECNICO NO EVENTO 
      if(user.manager != null){
        //PERMITIR GERENCIAR ESCALAÇÃO
        canManager = true;
        //DEFINIR DADOS DO EVENTO
        setEvent(myEvents.first.id);
      }
    }
  }

  //FUNÇÃO PARA SELECIONAR EVENTO E ATUALIZAR DADOS REFERNTES AO EVENTO
  void setEvent(id){
    //ATUALIZAR EVENTO SELECIONADO
    selectedEvent = myEvents.firstWhere((event) => event.id == id);
    //ATUALIZAR CATEGORIA DO EVENTO SELECIONADOS
    selectedCategory =  myEvents.firstWhere((event) => event.id == selectedEvent!.id).category!;
    //ADICIONAR DADOS DE TECNICO CASO EXISTAM
    user.manager = managerService.generateManager(1);
    //DEFINIR JOGADORES DO MERCADO DO EVENTO SELECIONADO
    playersMarket = filterMarketPlayers();
    //DEFINIR FORMAÇÕES APARTIR DE CATEGORIA SELECIONADA
    formations = escalationService.getFormations(selectedCategory);
    //DEFINIR INFORMAÇÕES REFERENTES AO USUARIO NO EVENTO SELECIONADO
    setUserInfo();
  }

  //FUNÇÃO QUE RESGATAR DADOS DE ESCALAÇÃO DO USUARIO NO EVENTO SELECIONADO
  void setUserInfo(){
    //RESGATAR ESCALAÇÃO DO USUARIO PARA EVENTO SELECIONADO
    EscalationModel userEscalation = escalationService.generateEscalation(selectedCategory, selectedEvent!.participants!);
    //RESGATAR FORMAÇÃO DA ESCALAÇAÕ DO USUARIO NO EVENTO SELECIONADO
    selectedFormation = userEscalation.formation!;
    //RESGATAR ESCALAÇÃO DE TITULARES E RESERVAS DO USUARIO NO EVENTO SELECIONADO
    starters.value = userEscalation.starters ?? <int, ParticipantModel?>{}.obs;
    reserves.value = userEscalation.reserves ?? <int, ParticipantModel?>{}.obs;
    //DEFINIR VALOR DE PATRIMÔNIO DO USUARIO NO EVENTO SELECIONADO
    managerPatrimony.value = user.manager!.economy!.patrimony!;
    //DEFINIR VALOR DA EQUIPE DO USUARIO NO EVENTO SELECIONADO
    managerTeamPrice.value = user.manager!.economy!.price!;
    //DEFINIR VALOR DA EQUIPE DO USUARIO NO EVENTO SELECIONADO
    managerValuation = user.manager!.economy!.valuation!;
  }

  //FUNÇÃO PARA RESETAR FILTRO
  void resetFilter(){
    //RESETAR FILTRO
    filtrosMarket.value = marketService.filtrosMarket;
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

  //FUNÇÃO DE APLICAÇÃO DE FILTROS
  RxList<ParticipantModel> filterMarketPlayers() {
    //RESGATAR FILTROS
    final filters = filtrosMarket;
    //RESGATAR JOGADORES DO MERCADO
    final participants = participantService.getParticipants();
    //VERIFICAR SE EVENTO TEM PARTICIPANTES VALIDOS
    if (participants.isEmpty) {
      //RETORNAR PARTICIPANTES VAZIOS
      return <ParticipantModel>[].obs;
    }
    //APLICAR FILTROS NÃO NÚMERICOS
    List<ParticipantModel> filteredPlayers = participants.where((participant) {
      //VERIFICAR SE PARTICIPANT É UM JOGADOR
      if(participant.user.player != null){
        //RESGATAR JOGADOR
        PlayerModel player = participant.user.player!;
        //FILTRO NOS STATUS
        if (filters['status'] != null && filters['status'] != 'Todos') {
          //SELECIONAR STATUS DO JOGADOR
          final selectedStatus = List<String>.from(filters['status']);
          //VERIFICAR STATUS DO JOGADOR
          final hasStatus = selectedStatus.any((status) => participant.status.name == status );
          if (!hasStatus) {
            return false;
          }
        }

        //FILTRO DE PESQUISA DE NOME NOMES
        if(filters['search'] != null && filters['search'] != '') {
          //RESGATAR NOME DO PARTICIPANTE
          final nome = filters['search'].toLowerCase();
          //VERIFICAR NOME DO JOGADOR
          if (!participant.user.userName!.toLowerCase().contains(nome) &&
              !participant.user.firstName!.toLowerCase().contains(nome) &&
              !participant.user.lastName!.toLowerCase().contains(nome)) {
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
          //SELECIONAR POSIÇÕES DO FILTRO
          final selectedPositions = List<String>.from(filters['positions']);
          //SELECIONAR POSIÇÕES DO JOGADOR
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
      }
      //RETORNAR FALSO SE PARTICIPANTE NÃO FOR UM JOGADOR
      return false;
    }).toList();
    //FILTRO DE ORDENAÇÃO POR NOME
    if(filters['nome'] != null && filters['nome'] != '') {
      filteredPlayers.sort((a, b) {
        return a.user.firstName!.toLowerCase().compareTo(b.user.firstName!.toLowerCase());
      });
    }
    //FILTRAR POR METRICAS 
    filteredPlayers = filterMetricsPlayer(filteredPlayers);
    //RETORNAR JOGADORES FILTRADOS E ORDENADOS
    return filteredPlayers.obs;
  }

  //FUNÇÃO DE APLICAÇÃO DE FILTROS POR MÉTRICAS
  List<ParticipantModel> filterMetricsPlayer(List<ParticipantModel> participants) {
    //RESGATAR FILTROS DO MERCADO
    final filters = filtrosMarket;

    //ORDENAR POR PREÇO
    if (filters['price'] != null && filters['price'] != '') {
      participants.sort((a, b) {
        final aPrice = a.user.player?.rating?.price ?? 0;
        final bPrice = b.user.player?.rating?.price ?? 0;
        return filters['price'] == 'Maior preço'
            ? bPrice.compareTo(aPrice)
            : aPrice.compareTo(bPrice);
      });
    }

    //ORDENAR POR MÉDIA (average)
    if (filters['media'] != null && filters['media'] != '') {
      participants.sort((a, b) {
        final aAvg = a.user.player?.rating?.avarage ?? 0;
        final bAvg = b.user.player?.rating?.avarage ?? 0;
        return filters['media'] == 'Maior média'
            ? bAvg.compareTo(aAvg)
            : aAvg.compareTo(bAvg);
      });
    }

    //ORDENAR POR QUANTIDADE DE JOGOS
    if (filters['game'] != null && filters['game'] != '') {
      participants.sort((a, b) {
        final aGames = a.user.player?.rating?.games ?? 0;
        final bGames = b.user.player?.rating?.games ?? 0;
        return filters['game'] == 'Mais jogos'
            ? bGames.compareTo(aGames)
            : aGames.compareTo(bGames);
      });
    }

    //ORDENAR POR VALORIZAÇÃO
    if (filters['valorization'] != null && filters['valorization'] != '') {
      participants.sort((a, b) {
        final aVal = a.user.player?.rating?.valuation ?? 0;
        final bVal = b.user.player?.rating?.valuation ?? 0;
        return filters['valorization'] == 'Maior valorização'
            ? bVal.compareTo(aVal)
            : aVal.compareTo(bVal);
      });
    }

    //ORDENAR POR ÚLTIMA PONTUAÇÃO (usando points)
    if (filters['lastPontuation'] != null && filters['lastPontuation'] != '') {
      participants.sort((a, b) {
        final aPoints = a.user.player?.rating?.points ?? 0;
        final bPoints = b.user.player?.rating?.points ?? 0;
        return filters['lastPontuation'] == 'Maior pontuação'
            ? bPoints.compareTo(aPoints)
            : aPoints.compareTo(bPoints);
      });
    }
    //RETORNAR PARTICIPANTS
    return participants;
  }

  //FUNÇÃO PARA ALTERAR JOGADOR NA ESCALAÇÃO (TITULARES)
  void setStarter(int index, ParticipantModel? player) {
    starters[index] = player;
    starters.refresh();
  }

  //FUNÇÃO PARA ALTER JOGADOR NA ESCALAÇÃO (RESERVAS)
  void setReserve(int index, ParticipantModel? player) {
    reserves[index] = player;
    reserves.refresh();
  }

  //FUNÇÃO DE ALTERAÇÃO JOGADOR NA ESCALAÇÃO
  void setPlayerEscalation(dynamic id){
    //RESGATR JOGADOR DO MERCADO
    final player = participantService.findPlayer(playersMarket, id);
    //VERIFICAR SE JOGADOR FOI ENCONTRADO
    if (player == null) {
      //EXIBIR MENSAGEM DE ERRO
      AppHelper.feedbackMessage(Get.context, 'Jogador não encontrado!');
      return;
    }
    try {
      //VERIFICAR SE JOGADOR ESTA ESCALADO
      bool isEscaled = findPlayerEscalation(id);
      //VERIFICAR SE JOGADOR JÁ ESTA ESCALADO
      if(!isEscaled){
        //VERIFICAR OCUPAÇÃO NA ESCALAÇÃO
        if (selectedOcupation.value == 'starters') {
          //ADICIONAR JOGADOR A POSIÇÃO
          setStarter(selectedPlayer.value, player);
        } else if (selectedOcupation.value == 'reserves') {
          //ADICIONAR JOGADOR A POSIÇÃO
          setReserve(selectedPlayer.value, player);
        }
        //CALCULAR PATRIMONIO DISPONIVEL E PREÇO DA EQUIPE
        calcTeamPrice(player.user.player!.rating!.price!, 'add');
      }else{
        //VERIFICAR OCUPAÇÃO NA ESCALAÇÃO
        if (selectedOcupation.value == 'starters') {
          //REMOVER JOGADOR DA POSIÇÃO
          setStarter(selectedPlayer.value, player);
        } else if (selectedOcupation.value == 'reserves') {
          //REMOVER JOGADOR DA POSIÇÃO
          setReserve(selectedPlayer.value, player);
        }
        //CALCULAR PATRIMONIO DISPONIVEL E PREÇO DA EQUIPE
        calcTeamPrice(player.user.player!.rating!.price!, 'remove');
      }
    } catch (e) {
      print(e);
      //EXIBIR MENSAGEM DE ERRO
      AppHelper.feedbackMessage(Get.context, 'Houve um erro, Tente novamente!');
    }
    //RESETAR POSIÇÃO E OCUPAÇÃO DO JOGADOR SELECIONADO
    selectedPlayer.value = 0;
    selectedOcupation.value = '';
  }
  
  //FUNÇÃO DE BUSCA DE JOGADOR NA ESCALAÇÃO
  bool findPlayerEscalation(int id) {
    //DEFINIR VALOR PADRÃO
    bool player = false;
    //PERCORRER MAPA DE TITULARES
    starters.forEach((i, participant) {
      //VERIFICAR SE JOGADOR FOI ESCALADO
      if (participant != null && participant.id == id) {
        //ATUALIZAR INDEX E OCUPAÇÃOS DO JOGADOR QUE ESTA SENDO BUSCADO
        selectedPlayer.value = i;
        selectedOcupation.value = 'starters';
        //ATUALIZAR RETORNO DA FUNÇÃO
        player = true;
      }
    });
    //PERCORRER MAPA DE RESERVAS
    reserves.forEach((i, participant) {
      //VERIFICAR SE JOGADOR FOI ESCALADO
      if (participant != null && participant.id == id) {
        //ATUALIZAR INDEX E OCUPAÇÃOS DO JOGADOR QUE ESTA SENDO BUSCADO
        selectedPlayer.value = i;
        selectedOcupation.value = 'reserves';
        //ATUALIZAR RETORNO DA FUNÇÃO
        player = true;
      }
    });
    //RETORNAR SE JOGADOR FOI ENCONTRADO NA ESCALAÇÃO
    return player;
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

  //FUNÇÃO DE DEFINIÇÃO JOGADOR COMO CAPITÃO
  void setPlayerCapitan(dynamic id){
    try {
      //VERIFICAR EM QUE OCUPAÇÃO O JOGADOR ESTA NA ESCALAÇÃO
      bool isEscaled = findPlayerEscalation(id);
      //VERIFICAR SE JOGADOR FOI ENCONTRADO NA ESCALÇÃO
      if(isEscaled){
        //VERIFICAR SE JOGADOR JA ESTA DEFINIDO COMO CAPITÃO
        if(selectedPlayerCapitan.value == id){
          //REMOVER CAPITÃO
          selectedPlayerCapitan.value = 0;
        }else{
          //ADICIONAR ID DO JOGADOR CAPITÃO
          selectedPlayerCapitan.value = id;
        }
      }
    } catch (e) {
      print(e);
      //EXIBIR MENSAGEM DE ERRO
      AppHelper.feedbackMessage(Get.context, 'Houve um erro, Tente novamente!');
    }
  }

  //FUNÇÃO PARA CONTABILIZAÇÃO DE PREÇO DA EQUIPE E PATRIMONIO
  void calcTeamPrice(double playerPrice, String action){
    //ARREDONDAR VALOR DO JOGADOR RECEBIDO
    final roundedPrice = double.parse(playerPrice.toStringAsFixed(2));
    //VERIFICAR FLAG DE AÇÃO
    if (action == 'add') {
      //ADICIONAR PREÇO DO JOGADOR AO PREÇO DA EQUIPE
      managerTeamPrice.value = double.parse((managerTeamPrice.value + roundedPrice).toStringAsFixed(2));
      //DESCONTAR PREÇO DO JOGADOR DO PATRIMONIO DO USUARIO
      managerPatrimony.value = double.parse((managerPatrimony.value - roundedPrice).toStringAsFixed(2));
    } else {
      //DESCONTAR PREÇO DO JOGADOR AO PREÇO DA EQUIPE
      managerTeamPrice.value = double.parse((managerTeamPrice.value - roundedPrice).toStringAsFixed(2));
      //ADICIONAR PREÇO DO JOGADOR DO PATRIMONIO DO USUARIO
      managerPatrimony.value = double.parse((managerPatrimony.value + roundedPrice).toStringAsFixed(2));
    }
  }
}