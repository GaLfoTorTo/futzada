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

//===DEPENDENCIAS BASE===
abstract class EscalationBase {
  //GETTER - SERVIÇOS
  EscalationService get escalationService;
  ParticipantService get participantService;
  MarketService get marketService;
  ManagerService get managerService;
  
  //GETTER - USUÁRIO E EVENTOS
  UserModel get user;
  List<EventModel> get myEvents;
  
  //GETTER - ESTADOS
  bool get canManager;
  RxString get selectedCategory;
  RxString get selectedFormation;
  RxInt get selectedPlayer;
  RxString get selectedOccupation;
  RxInt get selectedPlayerCapitan;
  RxDouble get managerPatrimony;
  RxDouble get managerTeamPrice;
  RxDouble get managerValuation;
  List<String> get formations;
  
  //GETTER - FILTROS
  RxMap<String, dynamic> get filtrosMarket;
  Map<String, List<Map<String, dynamic>>> get filterOptions;
  Map<String, List<Map<String, dynamic>>> get filterPlayerOptions;
  
  //GETTER - DADOS DO EVENTO
  EventModel? get selectedEvent;
  RxList<Map<String, dynamic>> get myEscalations;
  RxList<ParticipantModel> get playersMarket;
  RxList<ParticipantModel> get filteredPlayersMarket;
  RxMap<String, RxMap<int, ParticipantModel?>> get escalation;
  List<ParticipantModel?> get starters;
  List<ParticipantModel?> get reserves;
  
  //CONTROLADOR DE PESQUISA
  TextEditingController get pesquisaController;
}

class EscalationController extends GetxController 
  with EscalationManagerMixin, EscalationMarketMixin, EscalationTeamMixin {
  
  //GETTER DE CONTROLLERS
  static EscalationController get instance => Get.find();
  
  //GETTER DE SERVIÇOS
  @override
  final EscalationService escalationService = EscalationService();
  @override
  final ParticipantService participantService = ParticipantService();
  @override
  final MarketService marketService = MarketService();
  @override
  final ManagerService managerService = ManagerService();
  
  //CONTROLADOR DE PESQUISA
  @override
  final TextEditingController pesquisaController = TextEditingController();

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
        //CARREGAR JOGADORES DO MERCADO
        playersMarket.value = participantService.getParticipants();
        //APLICAR FILTRO INICIAL NOS JOGADORES DO MERCADO
        filteredPlayersMarket.value = filterMarketPlayers();
      }
    }
  }
}

//===MIXIN - GERENCIAMENTO DE ESCALAÇÃO===
mixin EscalationManagerMixin on GetxController implements EscalationBase {
  //ESTADOS
  @override
  final UserModel user = Get.find(tag: 'user');
  @override
  final List<EventModel> myEvents = Get.find(tag: 'events');
  @override
  bool canManager = false;
  @override
  final RxString selectedCategory = ''.obs;
  @override
  final RxString selectedFormation = ''.obs;
  @override
  final RxInt selectedPlayer = 0.obs;
  @override
  final RxString selectedOccupation = ''.obs;
  @override
  final RxInt selectedPlayerCapitan = 0.obs;
  @override
  final RxDouble managerPatrimony = 100.0.obs;
  @override
  final RxDouble managerTeamPrice = 0.0.obs;
  @override
  final RxDouble managerValuation = 0.0.obs;
  @override
  List<String> formations = [];
  
  //DADOS DO EVENTO
  @override
  late EventModel? selectedEvent;
  @override
  late RxList<Map<String, dynamic>> myEscalations;
  //ESTADOS
  @override
  late RxMap<String, RxMap<int, ParticipantModel?>> escalation;
  @override
  late RxList<ParticipantModel?> starters = <ParticipantModel?>[].obs;
  @override
  late RxList<ParticipantModel?> reserves = <ParticipantModel?>[].obs;
  
  //FUNÇÃO PARA SELECIONAR EVENTO E ATUALIZAR DADOS REFERNTES AO EVENTO
  void setEvent(id) {
    //ATUALIZAR EVENTO SELECIONADO
    selectedEvent = myEvents.firstWhere((event) => event.id == id);
    //ATUALIZAR CATEGORIA DO EVENTO SELECIONADOS
    selectedCategory.value = myEvents.firstWhere((event) => event.id == selectedEvent!.id).gameConfig!.category!;
    //ADICIONAR DADOS DE TECNICO CASO EXISTAM
    user.manager = managerService.generateManager(1);
    //DEFINIR FORMAÇÕES APARTIR DE CATEGORIA SELECIONADA
    formations = escalationService.getFormations(selectedCategory.value);
    //DEFINIR INFORMAÇÕES REFERENTES AO USUARIO NO EVENTO SELECIONADO
    setUserInfo();
  }

  //FUNÇÃO QUE RESGATAR DADOS DE ESCALAÇÃO DO USUARIO NO EVENTO SELECIONADO
  void setUserInfo() {
    //RESGATAR ESCALAÇÃO DO USUARIO PARA EVENTO SELECIONADO
    EscalationModel userEscalation = escalationService.generateEscalation(selectedCategory.value, selectedEvent!.participants!);
    //RESGATAR FORMAÇÃO DA ESCALAÇAÕ DO USUARIO NO EVENTO SELECIONADO
    selectedFormation.value = userEscalation.formation!;
    //RESGATAR ESCALAÇÃO DE TITULARES E RESERVAS DO USUARIO NO EVENTO SELECIONADO
    starters.value = userEscalation.starters ?? escalationService.setEscalation(selectedCategory.value, 'starters');
    reserves.value = userEscalation.reserves ?? escalationService.setEscalation(selectedCategory.value, 'reserves');
    //DEFINIR VALOR DE PATRIMÔNIO DO USUARIO NO EVENTO SELECIONADO
    managerPatrimony.value = user.manager!.economy!.patrimony!;
    //DEFINIR VALOR DA EQUIPE DO USUARIO NO EVENTO SELECIONADO
    managerTeamPrice.value = user.manager!.economy!.price!;
    //DEFINIR VALOR DA EQUIPE DO USUARIO NO EVENTO SELECIONADO
    managerValuation.value = user.manager!.economy!.valuation!;
  }
}

//===MIXIN - MERCADO DE JOGADORES===
mixin EscalationMarketMixin on GetxController implements EscalationBase {
  //ESTADOS
  @override
  final RxMap<String, dynamic> filtrosMarket = MarketService().filtrosMarket.obs;
  @override
  final Map<String, List<Map<String, dynamic>>> filterOptions = MarketService().filterOptions;
  @override
  final Map<String, List<Map<String, dynamic>>> filterPlayerOptions = MarketService().filterPlayerOptions;
  @override
  RxList<ParticipantModel> playersMarket = <ParticipantModel>[].obs;
  @override
  RxList<ParticipantModel> filteredPlayersMarket = <ParticipantModel>[].obs;
  
  //FUNÇÃO PARA RESETAR FILTRO
  void resetFilter() {
    //RESETAR FILTRO
    filtrosMarket.value = marketService.filtrosMarket;
  }

  //FUNÇÃO DE DEFINIÇÃO DE FILTRO DO MERCADO
  void setFilter(String name, dynamic newValue) {
    //VERIFICAR SE NAME E VALOR RECEBIDOS NÃO ESTÂO VAZIOS
    if(name != 'positions' && name != 'status' && name != 'bestSide') {
      //ATUALIZAR CHAVE DO FILTRO
      filtrosMarket[name] = newValue;
    }
    //VERIFICAÇÃO PARA POSIÇÕES
    if(name == 'positions' || name == 'status' || name == 'bestSide') {
      //VERIFICAR SE RECEBIDO FOI POSIÇÃO E SE ESTA NO FORMATO DE ARRAY
      if(name == 'positions' && newValue is List<String>) {
        //ATUALIZAR CHAVE DO FILTRO
        filtrosMarket[name] = newValue;
      }else if(name == 'bestSide'){
        //ATUALIZAR CHAVE DO FILTRO
        filtrosMarket[name] = newValue != filtrosMarket[name] ? newValue : '';
      } else {
        //RESGATAR POSIÇÕES SALVAS NO FILTRO
        final arr = filtrosMarket[name] as List<String>;
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
    filteredPlayersMarket.value = filterMarketPlayers();
  }

  //FUNÇÃO DE APLICAÇÃO DE FILTROS
  RxList<ParticipantModel> filterMarketPlayers() {
    //RESGATAR FILTROS
    final filters = filtrosMarket;
    //RESGATAR JOGADORES DO MERCADO JOGADORES ORIGINAIS
    final participants = List<ParticipantModel>.from(playersMarket);
    //VERIFICAR SE EVENTO TEM PARTICIPANTES VALIDOS
    if (participants.isEmpty) {
      //RETORNAR PARTICIPANTES VAZIOS
      return <ParticipantModel>[].obs;
    }
    //APLICAR FILTROS NÃO NÚMERICOS
    List<ParticipantModel> filteredPlayers = participants.where((participant) {
      //VERIFICAR SE PARTICIPANT É UM JOGADOR
      if(participant.user.player != null) {
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
}

//===MIXIN - GERENCIAMENTO DE EQUIPE===
mixin EscalationTeamMixin on GetxController implements EscalationBase {  
  
  //FUNÇÃO PARA ALTERAR JOGADOR NA ESCALAÇÃO (TITULARES)
  void setPlayerPosition(ParticipantModel? player) {
    //VERIFICAR SE JOGADOR E TITULAR OU RESERVA
    if(selectedOccupation.value == 'starters'){
      starters[selectedPlayer.value] = starters[selectedPlayer.value] == null ? player : null;
    }else{
      reserves[selectedPlayer.value] = starters[selectedPlayer.value] == null ? player : null;
    }
  }

  //FUNÇÃO DE DEFINIÇÃO JOGADOR COMO CAPITÃO
  void setPlayerCapitan(dynamic id) {
    try {
      //VERIFICAR EM QUE OCUPAÇÃO O JOGADOR ESTA NA ESCALAÇÃO
      bool isEscaled = findPlayerEscalation(id);
      //VERIFICAR SE JOGADOR FOI ENCONTRADO NA ESCALÇÃO
      if(isEscaled) {
        //ADICIONAR ID DO JOGADOR CAPITÃO
        selectedPlayerCapitan.value = selectedPlayerCapitan.value == id ? 0 : id;
      }
    } catch (e) {
      print(e);
      //EXIBIR MENSAGEM DE ERRO
      AppHelper.feedbackMessage(Get.context, 'Houve um erro, Tente novamente!');
    }
  }

  //FUNÇÃO DE ALTERAÇÃO JOGADOR NA ESCALAÇÃO
  void setPlayerEscalation(dynamic id) {
    //RESGATR JOGADOR DO MERCADO
    final player = playersMarket.firstWhereOrNull((player) => player.id == id);
    //VERIFICAR SE JOGADOR FOI ENCONTRADO
    if (player == null) {
      //EXIBIR MENSAGEM DE ERRO
      AppHelper.feedbackMessage(Get.context, 'Jogador não encontrado!');
      return;
    }
    try {
      //VERIFICAR SE JOGADOR ESTA ESCALADO
      bool isEscaled = findPlayerEscalation(id);
      //ADICIONAR JOGADOR A POSIÇÃO
      setPlayerPosition(player);
      //RESGATAR AÇÃO DE PATRIMONIO E PREÇO DA EQUIPE
      String action = isEscaled ? 'remove' : 'add';
      //CALCULAR PATRIMONIO E PREÇO DA EQUIPE
      calcTeamPrice(player.user.player!.rating!.price!, action);
    } catch (e) {
      print(e);
      //EXIBIR MENSAGEM DE ERRO
      AppHelper.feedbackMessage(Get.context, 'Houve um erro, Tente novamente!');
    }
    //RESETAR POSIÇÃO E OCUPAÇÃO DO JOGADOR SELECIONADO
    selectedPlayer.value = 0;
    selectedOccupation.value = '';
  }
  
  //FUNÇÃO DE BUSCA DE JOGADOR NA ESCALAÇÃO
  bool findPlayerEscalation(int id) {
    bool found = false;
    //PERCORRER MAPA DE TITULARES
    starters.asMap().forEach((i, participant) {
      //VERIFICAR SE JOGADOR FOI ESCALADO
      if (participant != null && participant.id == id) {
        found = true;
      }
    });
    //PERCORRER MAPA DE RESERVAS
    reserves.asMap().forEach((i, participant) {
      //VERIFICAR SE JOGADOR FOI ESCALADO
      if (participant != null && participant.id == id) {
        found = true;
      }
    });
    return found;
  }

  //FUNÇÃO PARA CONTABILIZAÇÃO DE PREÇO DA EQUIPE E PATRIMONIO
  void calcTeamPrice(double playerPrice, String action) {
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