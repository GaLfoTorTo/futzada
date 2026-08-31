import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/models/player_model.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/services/market_service.dart';

//ESTADO - MERCADO DE ESCALAÇÃO
class EscalationMarketState {
  final List<UserModel> playersMarket;
  final List<UserModel> playersFiltered;
  final Map<String, dynamic> filtrosMarket;
  final Map<String, List<Map<String, dynamic>>> filterOptions;
  final Map<String, List<Map<String, dynamic>>> filterPlayerOptions;

  const EscalationMarketState({
    this.playersMarket = const [],
    this.playersFiltered = const [],
    required this.filtrosMarket,
    required this.filterOptions,
    required this.filterPlayerOptions,
  });

  EscalationMarketState copyWith({
    List<UserModel>? playersMarket,
    List<UserModel>? playersFiltered,
    Map<String, dynamic>? filtrosMarket,
    Map<String, List<Map<String, dynamic>>>? filterOptions,
    Map<String, List<Map<String, dynamic>>>? filterPlayerOptions,
  }) => EscalationMarketState(
    playersMarket: playersMarket ?? this.playersMarket,
    playersFiltered: playersFiltered ?? this.playersFiltered,
    filtrosMarket: filtrosMarket ?? this.filtrosMarket,
    filterOptions: filterOptions ?? this.filterOptions,
    filterPlayerOptions: filterPlayerOptions ?? this.filterPlayerOptions,
  );
}

//NOTIFICADOR - MERCADO DE ESCALAÇÃO
class EscalationMarketNotifier extends Notifier<EscalationMarketState> {
  final TextEditingController pesquisaController = TextEditingController();

  MarketService get _marketService => MarketService();

  @override
  EscalationMarketState build() => EscalationMarketState(
    filtrosMarket: Map.from(_marketService.filtrosMarket),
    filterOptions: Map.from(_marketService.filterOptions),
    filterPlayerOptions: Map.from(_marketService.filterPlayerOptions),
  );

  //FUNÇÃO DE DEFINIÇÃO DE JOGADORES DO MERCADO
  void setPlayersMarket(List<UserModel?> list) {
    state = state.copyWith(
      playersMarket: List.from(list),
      playersFiltered: List.from(list)
    );
  }
  
  //FUNÇÃO DE RESET DE OPÇÕES DE FILTROS
  void resetFilter() {
    state = state.copyWith(filtrosMarket: Map.from(_marketService.filtrosMarket));
  }
  
  //FUNÇÃO DE DEFINIÇÃO DE FILTROS
  void setFilter(String name, dynamic newValue) {
    final filters = Map<String, dynamic>.from(state.filtrosMarket);
    //FILTRAR PARA POSIÇÕES
    if (name == 'positions' && newValue is List<String>) {
      filters[name] = newValue;
    }
    //FILTRAR PARA MELHOR PÉ
    if (name == 'bestSide') {
      filters[name] = newValue != filters[name] ? newValue : '';
    }
    //DEMAIS FILTROS
    if (name != 'positions' && name != 'status' && name != 'bestSide') {
      final arr = List<String>.from(filters[name] as List);
      if (arr.contains(newValue)) {
        arr.remove(newValue);
      } else {
        arr.insert(0, newValue);
      }
      filters[name] = arr;
    }

    state = state.copyWith(filtrosMarket: filters);
  }
  
  //FUNÇÃO DE FILTRO DE JOGADORES
  List<UserModel> filterMarketPlayers(EventModel? event) {
    if (event == null) return [];
    final filters = state.filtrosMarket;
    final participants = List<UserModel>.from(state.playersMarket);
    if (participants.isEmpty) return [];

    List<UserModel> filteredPlayers = participants.where((item) {
      final user = event.participants!.firstWhere((p) => p.id == item.id);
      if (user.player != null) {
        final PlayerModel player = user.player!;
        if (filters['status'] != null && filters['status'] != 'Todos') {
          final selectedStatus = List<String>.from(filters['status']);
          final hasStatus = selectedStatus.any(
            (status) => user.participants?.any((p) => p.status.name == status) ?? false,
          );
          if (!hasStatus) return false;
        }
        if (filters['search'] != null && filters['search'] != '') {
          final nome = (filters['search'] as String).toLowerCase();
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
        if (filters['positions'] != null &&
            (filters['positions'] as List).isNotEmpty) {
          final selectedPositions = List<String>.from(filters['positions']);
          final playerPositions = player.getPositionsByModality(event.modality!.name);
          final hasPosition = selectedPositions.any(
            (pos) => playerPositions.any((p) => p.alias == pos),
          );
          if (!hasPosition) return false;
        }
        return true;
      }
      return false;
    }).toList();

    return _filterMetricsPlayer(filteredPlayers, event);
  }

  //FUNÇÃO DE FILTRO DE METRICAS
  List<UserModel> _filterMetricsPlayer(List<UserModel> participants, EventModel event) {
    final filters = state.filtrosMarket;
    if (filters['price'] != null && filters['price'] != '') {
      participants.sort((a, b) {
        final aPrice = a.player?.ratings?.firstWhere((r) => r.eventId == event.id).price ?? 0;
        final bPrice = b.player?.ratings?.firstWhere((r) => r.eventId == event.id).price ?? 0;
        return filters['price'] == 'Maior preço' ? bPrice.compareTo(aPrice) : aPrice.compareTo(bPrice);
      });
    }
    if (filters['media'] != null && filters['media'] != '') {
      participants.sort((a, b) {
        final aAvg = a.player?.ratings?.firstWhere((r) => r.eventId == event.id).avarage ?? 0;
        final bAvg = b.player?.ratings?.firstWhere((r) => r.eventId == event.id).avarage ?? 0;
        return filters['media'] == 'Maior média' ? bAvg.compareTo(aAvg) : aAvg.compareTo(bAvg);
      });
    }
    if (filters['game'] != null && filters['game'] != '') {
      participants.sort((a, b) {
        final aGames = a.player?.ratings?.firstWhere((r) => r.eventId == event.id).games ?? 0;
        final bGames = b.player?.ratings?.firstWhere((r) => r.eventId == event.id).games ?? 0;
        return filters['game'] == 'Mais jogos' ? bGames.compareTo(aGames) : aGames.compareTo(bGames);
      });
    }
    if (filters['valorization'] != null && filters['valorization'] != '') {
      participants.sort((a, b) {
        final aVal = a.player?.ratings?.firstWhere((r) => r.eventId == event.id).valuation ?? 0;
        final bVal = b.player?.ratings?.firstWhere((r) => r.eventId == event.id).valuation ?? 0;
        return filters['valorization'] == 'Maior valorização' ? bVal.compareTo(aVal) : aVal.compareTo(bVal);
      });
    }
    if (filters['lastPontuation'] != null && filters['lastPontuation'] != '') {
      participants.sort((a, b) {
        final aPoints = a.player?.ratings?.firstWhere((r) => r.eventId == event.id).points ?? 0;
        final bPoints = b.player?.ratings?.firstWhere((r) => r.eventId == event.id).points ?? 0;
        return filters['lastPontuation'] == 'Maior pontuação'
            ? bPoints.compareTo(aPoints)
            : aPoints.compareTo(bPoints);
      });
    }
    return participants;
  }
}

//PROVIDER - MERCADO DE ESCALAÇÃO
final escalationMarketProvider = NotifierProvider<EscalationMarketNotifier, EscalationMarketState>(EscalationMarketNotifier.new);
