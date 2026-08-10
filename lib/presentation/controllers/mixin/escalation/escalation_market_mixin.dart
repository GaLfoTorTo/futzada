import 'package:flutter/foundation.dart';
import 'package:futzada/data/models/player_model.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/controllers/escalation_controller.dart';

//===MIXIN - MERCADO DE JOGADORES===
mixin EscalationMarketMixin on ChangeNotifier implements EscalationBase {
  //ESTADOS
  @override
  late Map<String, dynamic> filtrosMarket = marketService.filtrosMarket;
  @override
  late Map<String, List<Map<String, dynamic>>> filterOptions = marketService.filterOptions;
  @override
  late Map<String, List<Map<String, dynamic>>> filterPlayerOptions = marketService.filterPlayerOptions;

  final List<UserModel> _playersMarket = [];
  @override
  List<UserModel> get playersMarket => _playersMarket;

  final List<UserModel> _filteredPlayersMarket = [];
  @override
  List<UserModel> get filteredPlayersMarket => _filteredPlayersMarket;

  void setPlayersMarket(List<UserModel> list) {
    _playersMarket.clear();
    _playersMarket.addAll(list);
    notifyListeners();
  }

  void setFilteredPlayersMarket(List<UserModel> list) {
    _filteredPlayersMarket.clear();
    _filteredPlayersMarket.addAll(list);
    notifyListeners();
  }

  //FUNÇÃO PARA RESETAR FILTRO
  void resetFilter() {
    filtrosMarket = Map.from(marketService.filtrosMarket);
    notifyListeners();
  }

  //FUNÇÃO DE DEFINIÇÃO DE FILTRO DO MERCADO
  void setFilter(String name, dynamic newValue) {
    if (name != 'positions' && name != 'status' && name != 'bestSide') {
      filtrosMarket[name] = newValue;
    }
    if (name == 'positions' || name == 'status' || name == 'bestSide') {
      if (name == 'positions' && newValue is List<String>) {
        filtrosMarket[name] = newValue;
      } else if (name == 'bestSide') {
        filtrosMarket[name] = newValue != filtrosMarket[name] ? newValue : '';
      } else {
        final arr = filtrosMarket[name] as List<String>;
        if (arr.contains(newValue)) {
          arr.remove(newValue);
        } else {
          arr.insert(0, newValue);
        }
        filtrosMarket[name] = arr;
      }
    }
    setFilteredPlayersMarket([]);
    notifyListeners();
  }

  //FUNÇÃO DE APLICAÇÃO DE FILTROS
  List<UserModel> filterMarketPlayers() {
    final filters = filtrosMarket;
    final participants = List<UserModel>.from(_playersMarket);
    if (participants.isEmpty) {
      return [];
    }
    List<UserModel> filteredPlayers = participants.where((item) {
      UserModel user = event!.participants!.firstWhere((p) => p.id == item.id);
      if (user.player != null) {
        PlayerModel player = user.player!;
        if (filters['status'] != null && filters['status'] != 'Todos') {
          final selectedStatus = List<String>.from(filters['status']);
          final hasStatus = selectedStatus.any((status) => user.participants?.any((p) => p.status.name == status) ?? false);
          if (!hasStatus) return false;
        }
        if (filters['search'] != null && filters['search'] != '') {
          final nome = filters['search'].toLowerCase();
          if (!user.userName!.toLowerCase().contains(nome) &&
              !user.firstName!.toLowerCase().contains(nome) &&
              !user.lastName!.toLowerCase().contains(nome)) {
            return false;
          }
        }
        if (filters['bestSide'] != null &&
            filters['bestSide'] != '' &&
            player.bestSide != filters['bestSide']) {
          return false;
        }
        if (filters['positions'] != null && filters['positions'].isNotEmpty) {
          final selectedPositions = List<String>.from(filters['positions']);
          final playerPositions = player.mainPosition[event!.modality!.name];
          final hasPosition = selectedPositions.any((pos) => player.mainPosition == pos || playerPositions == pos);
          if (!hasPosition) return false;
        }
        return true;
      }
      return false;
    }).toList();
    filteredPlayers = filterMetricsPlayer(filteredPlayers);
    return filteredPlayers;
  }

  //FUNÇÃO DE APLICAÇÃO DE FILTROS POR MÉTRICAS
  List<UserModel> filterMetricsPlayer(List<UserModel> participants) {
    final filters = filtrosMarket;
    if (filters['price'] != null && filters['price'] != '') {
      participants.sort((a, b) {
        final aPrice = a.player?.ratings?.firstWhere((r) => r.eventId == event!.id).price ?? 0;
        final bPrice = b.player?.ratings?.firstWhere((r) => r.eventId == event!.id).price ?? 0;
        return filters['price'] == 'Maior preço' ? bPrice.compareTo(aPrice) : aPrice.compareTo(bPrice);
      });
    }
    if (filters['media'] != null && filters['media'] != '') {
      participants.sort((a, b) {
        final aAvg = a.player?.ratings?.firstWhere((r) => r.eventId == event!.id).avarage ?? 0;
        final bAvg = b.player?.ratings?.firstWhere((r) => r.eventId == event!.id).avarage ?? 0;
        return filters['media'] == 'Maior média' ? bAvg.compareTo(aAvg) : aAvg.compareTo(bAvg);
      });
    }
    if (filters['game'] != null && filters['game'] != '') {
      participants.sort((a, b) {
        final aGames = a.player?.ratings?.firstWhere((r) => r.eventId == event!.id).games ?? 0;
        final bGames = b.player?.ratings?.firstWhere((r) => r.eventId == event!.id).games ?? 0;
        return filters['game'] == 'Mais jogos' ? bGames.compareTo(aGames) : aGames.compareTo(bGames);
      });
    }
    if (filters['valorization'] != null && filters['valorization'] != '') {
      participants.sort((a, b) {
        final aVal = a.player?.ratings?.firstWhere((r) => r.eventId == event!.id).valuation ?? 0;
        final bVal = b.player?.ratings?.firstWhere((r) => r.eventId == event!.id).valuation ?? 0;
        return filters['valorization'] == 'Maior valorização' ? bVal.compareTo(aVal) : aVal.compareTo(bVal);
      });
    }
    if (filters['lastPontuation'] != null && filters['lastPontuation'] != '') {
      participants.sort((a, b) {
        final aPoints = a.player?.ratings?.firstWhere((r) => r.eventId == event!.id).points ?? 0;
        final bPoints = b.player?.ratings?.firstWhere((r) => r.eventId == event!.id).points ?? 0;
        return filters['lastPontuation'] == 'Maior pontuação' ? bPoints.compareTo(aPoints) : aPoints.compareTo(bPoints);
      });
    }
    return participants;
  }
}
