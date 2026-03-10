import 'package:get/get.dart';
import 'package:futzada/data/models/player_model.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/controllers/escalation_controller.dart';

//===MIXIN - MERCADO DE JOGADORES===
mixin EscalationMarketMixin on GetxController implements EscalationBase {
  //ESTADOS
  @override
  late RxMap<String, dynamic> filtrosMarket = marketService.filtrosMarket.obs;
  @override
  late Map<String, List<Map<String, dynamic>>> filterOptions = marketService.filterOptions;
  @override
  late Map<String, List<Map<String, dynamic>>> filterPlayerOptions = marketService.filterPlayerOptions;
  @override
  RxList<UserModel> playersMarket = <UserModel>[].obs;
  @override
  RxList<UserModel> filteredPlayersMarket = <UserModel>[].obs;
  
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
    filteredPlayersMarket.value = [];//filterMarketPlayers();
  }

  //FUNÇÃO DE APLICAÇÃO DE FILTROS
  RxList<UserModel> filterMarketPlayers() {
    //RESGATAR FILTROS
    final filters = filtrosMarket;
    //RESGATAR JOGADORES DO MERCADO JOGADORES ORIGINAIS
    final participants = List<UserModel>.from(playersMarket);
    //VERIFICAR SE EVENTO TEM PARTICIPANTES VALIDOS
    if (participants.isEmpty) {
      //RETORNAR PARTICIPANTES VAZIOS
      return <UserModel>[].obs;
    }
    //APLICAR FILTROS NÃO NÚMERICOS
    List<UserModel> filteredPlayers = participants.where((item) {
      UserModel user = event!.participants!.firstWhere((p) => p.id == item.id);
      //VERIFICAR SE PARTICIPANT É UM JOGADOR
      if(user.player != null) {
        //RESGATAR JOGADOR
        PlayerModel player = user.player!;
        //FILTRO NOS STATUS
        if (filters['status'] != null && filters['status'] != 'Todos') {
          //SELECIONAR STATUS DO JOGADOR
          final selectedStatus = List<String>.from(filters['status']);
          //VERIFICAR STATUS DO JOGADOR
          final hasStatus = selectedStatus.any((status) => user.participants?.any((p) => p.status.name == status) ?? false);
          if(!hasStatus) {
            return false;
          }
        }

        //FILTRO DE PESQUISA DE NOME NOMES
        if(filters['search'] != null && filters['search'] != '') {
          //RESGATAR NOME DO PARTICIPANTE
          final nome = filters['search'].toLowerCase();
          //VERIFICAR NOME DO JOGADOR
          if (!user.userName!.toLowerCase().contains(nome) &&
              !user.firstName!.toLowerCase().contains(nome) &&
              !user.lastName!.toLowerCase().contains(nome)) {
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
          //REMOVER POSIÇÃO PRINCIPAL DO ARRAY
          final playerPositions = player.mainPosition[event!.modality!.name];
          //VERIFICAR SE JOGADOR CONTEM UMA DAS OPÇÕES DEFINIDAS NO FILTRO
          final hasPosition = selectedPositions.any((pos) => player.mainPosition == pos || playerPositions == pos);
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
        return user.firstName!.toLowerCase().compareTo(user.firstName!.toLowerCase());
      });
    }
    //FILTRAR POR METRICAS 
    filteredPlayers = filterMetricsPlayer(filteredPlayers);
    //RETORNAR JOGADORES FILTRADOS E ORDENADOS
    return filteredPlayers.obs;
  }

  //FUNÇÃO DE APLICAÇÃO DE FILTROS POR MÉTRICAS
  List<UserModel> filterMetricsPlayer(List<UserModel> participants) {
    //RESGATAR FILTROS DO MERCADO
    final filters = filtrosMarket;
    
    //ORDENAR POR PREÇO
    if (filters['price'] != null && filters['price'] != '') {
      participants.sort((a, b) {
        final aPrice = a.player?.ratings?.firstWhere((r) => r.eventId == event!.id).price ?? 0;
        final bPrice = b.player?.ratings?.firstWhere((r) => r.eventId == event!.id).price ?? 0;
        return filters['price'] == 'Maior preço'
            ? bPrice.compareTo(aPrice)
            : aPrice.compareTo(bPrice);
      });
    }

    //ORDENAR POR MÉDIA (average)
    if (filters['media'] != null && filters['media'] != '') {
      participants.sort((a, b) {
        final aAvg = a.player?.ratings?.firstWhere((r) => r.eventId == event!.id).avarage ?? 0;
        final bAvg = b.player?.ratings?.firstWhere((r) => r.eventId == event!.id).avarage ?? 0;
        return filters['media'] == 'Maior média'
            ? bAvg.compareTo(aAvg)
            : aAvg.compareTo(bAvg);
      });
    }

    //ORDENAR POR QUANTIDADE DE JOGOS
    if (filters['game'] != null && filters['game'] != '') {
      participants.sort((a, b) {
        final aGames = a.player?.ratings?.firstWhere((r) => r.eventId == event!.id).games ?? 0;
        final bGames = b.player?.ratings?.firstWhere((r) => r.eventId == event!.id).games ?? 0;
        return filters['game'] == 'Mais jogos'
            ? bGames.compareTo(aGames)
            : aGames.compareTo(bGames);
      });
    }

    //ORDENAR POR VALORIZAÇÃO
    if (filters['valorization'] != null && filters['valorization'] != '') {
      participants.sort((a, b) {
        final aVal = a.player?.ratings?.firstWhere((r) => r.eventId == event!.id).valuation ?? 0;
        final bVal = b.player?.ratings?.firstWhere((r) => r.eventId == event!.id).valuation ?? 0;
        return filters['valorization'] == 'Maior valorização'
            ? bVal.compareTo(aVal)
            : aVal.compareTo(bVal);
      });
    }

    //ORDENAR POR ÚLTIMA PONTUAÇÃO (usando points)
    if (filters['lastPontuation'] != null && filters['lastPontuation'] != '') {
      participants.sort((a, b) {
        final aPoints = a.player?.ratings?.firstWhere((r) => r.eventId == event!.id).points ?? 0;
        final bPoints = b.player?.ratings?.firstWhere((r) => r.eventId == event!.id).points ?? 0;
        return filters['lastPontuation'] == 'Maior pontuação'
            ? bPoints.compareTo(aPoints)
            : aPoints.compareTo(bPoints);
      });
    }
    //RETORNAR PARTICIPANTS
    return participants;
  }
}