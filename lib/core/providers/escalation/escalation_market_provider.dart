import 'package:esportly/data/models/participant_model.dart';
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
    final filters = state.filtrosMarket;
    //FILTRAR PARA POSIÇÕES
    if (name == 'positions') {
      if (newValue is List<String>) {
        filters[name] = newValue;
      } else if (newValue is String) {
        final arr = List<String>.from(filters[name] as List);
        if (arr.contains(newValue)) {
          arr.remove(newValue);
        } else {
          arr.add(newValue);
        }
        filters[name] = arr;
      }
    }
    //FILTRAR PARA STATUS
    if (name == 'status') {
      final arr = List<String>.from(filters[name] as List);
      if (arr.contains(newValue)) {
        arr.remove(newValue);
      } else {
        arr.insert(0, newValue);
      }
      filters[name] = arr;
    }
    //FILTRAR PARA MELHOR LADO
    if (name == 'bestSide') {
      final arr = List<String>.from(filters[name] as List);
      if (arr.contains(newValue)) {
        arr.remove(newValue);
      } else {
        arr.add(newValue);
      }
      filters[name] = arr;
    }
    //DEMAIS FILTROS (seleção única)
    if (!['positions', 'status', 'bestSide'].contains(name)) {
      filters[name] = newValue;
    }

    state = state.copyWith(filtrosMarket: filters);
  }

  //FUNÇÃO DE ATUALIZAÇÃO DE JOGADORES FILTRADOS
  void updatePlayersFiltered(List<UserModel> filtered) {
    state = state.copyWith(playersFiltered: filtered);
  }

  //FUNÇÃO DE FILTRO DE JOGADORES
  List<UserModel> filterMarketPlayers(EventModel event) {
    final filters = state.filtrosMarket;
    final participants = state.playersMarket;
    if (participants.isEmpty) return [];

    List<UserModel> filteredPlayers = participants.where((user) {
      if (user.player == null) return false;
      final ParticipantModel participant = user.participants!.first;
      final PlayerModel player = user.player!;

      //FILTRO DE STATUS
      if (filters['status'] != null) {
        final selectedStatus = List<String>.from(filters['status']);
        if (selectedStatus.isNotEmpty) {
          if (!selectedStatus.contains(participant.status.name)) return false;
        }
      }
      //FILTRO DE PESQUISA
      if (filters['search'] != null) {
        final nome = (filters['search'] as String).toLowerCase();
        if (!user.userName!.toLowerCase().contains(nome) &&
            !user.firstName!.toLowerCase().contains(nome) &&
            !user.lastName!.toLowerCase().contains(nome)) {
          return false;
        }
      }
      //FILTRO MELHOR LADO
      if (filters['bestSide'] != null) {
        final selectedSides = List<String>.from(filters['bestSide'] as List);
        if (selectedSides.isNotEmpty && selectedSides.contains(player.bestSide)) return false;
      }
      //FILTRO DE POSIÇÃO
      if (filters['positions'] != null) {
        final selectedPositions = List<String>.from(filters['positions']);
        if (selectedPositions.isNotEmpty && selectedPositions.any((pos) => player.positions.any((p) => p.alias == pos))) return false;
      }
      //FILTRO DE PREÇO MÁXIMO (reservas)
      if (filters['maxPrice'] != null) {
        final maxPrice = (filters['maxPrice'] as num).toDouble();
        final playerPrice = player.ratings
            ?.firstWhere((r) => r.eventId == event.id, orElse: () => player.ratings!.first)
            .price ?? double.infinity;
        if (playerPrice > maxPrice) return false;
      }
      return true;
    }).toList();
    return _filterMetricsPlayer(filteredPlayers, event);
  }

  //FUNÇÃO DE FILTRO DE METRICAS
  List<UserModel> _filterMetricsPlayer(List<UserModel> participants, EventModel event) {
    final filters = state.filtrosMarket;
    //FILTRO DE PREÇO
    if (filters['price'] != null) {
      participants.sort((a, b) {
        final aPrice = a.player?.ratings?.firstWhere((r) => r.eventId == event.id).price ?? 0;
        final bPrice = b.player?.ratings?.firstWhere((r) => r.eventId == event.id).price ?? 0;
        return filters['price'] == 'Maior preço' ? bPrice.compareTo(aPrice) : aPrice.compareTo(bPrice);
      });
    }
    //FILTRO DE MÉDIA
    if (filters['media'] != null) {
      participants.sort((a, b) {
        final aAvg = a.player?.ratings?.firstWhere((r) => r.eventId == event.id).avarage ?? 0;
        final bAvg = b.player?.ratings?.firstWhere((r) => r.eventId == event.id).avarage ?? 0;
        return filters['media'] == 'Maior média' ? bAvg.compareTo(aAvg) : aAvg.compareTo(bAvg);
      });
    }
    //FILTRO DE NUMERO DE PARTIDAS
    if (filters['game'] != null) {
      participants.sort((a, b) {
        final aGames = a.player?.ratings?.firstWhere((r) => r.eventId == event.id).games ?? 0;
        final bGames = b.player?.ratings?.firstWhere((r) => r.eventId == event.id).games ?? 0;
        return filters['game'] == 'Mais jogos' ? bGames.compareTo(aGames) : aGames.compareTo(bGames);
      });
    }
    //FILTRO DE VALORIZAÇÃO
    if (filters['valorization'] != null) {
      participants.sort((a, b) {
        final aVal = a.player?.ratings?.firstWhere((r) => r.eventId == event.id).valuation ?? 0;
        final bVal = b.player?.ratings?.firstWhere((r) => r.eventId == event.id).valuation ?? 0;
        return filters['valorization'] == 'Maior valorização' ? bVal.compareTo(aVal) : aVal.compareTo(bVal);
      });
    }
    //FILTRO DE ULTIMA PONTUAÇÃO
    if (filters['lastPontuation'] != null) {
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
