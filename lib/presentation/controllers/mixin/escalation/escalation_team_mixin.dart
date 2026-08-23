import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/helpers/app_helper.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/presentation/controllers/escalation_controller.dart';

//===MIXIN - GERENCIAMENTO DE EQUIPE===
mixin EscalationTeamMixin on ChangeNotifier implements EscalationBase {

  //FUNÇÃO PARA ALTERAR JOGADOR NA ESCALAÇÃO (TITULARES)
  void setPlayerPosition(UserModel? player) {
    if (selectedOccupation == 'starters') {
      starters[selectedPlayer] = starters[selectedPlayer] == null ? player!.id : null;
    } else {
      reserves[selectedPlayer] = starters[selectedPlayer] == null ? player!.id : null;
    }
    notifyListeners();
  }

  //FUNÇÃO DE DEFINIÇÃO JOGADOR COMO CAPITÃO
  void setPlayerCapitan(dynamic id) {
    try {
      bool isEscaled = findPlayerEscalation(id);
      if (isEscaled) {
        selectedPlayerCapitan = selectedPlayerCapitan == id ? 0 : id;
      }
    } catch (e) {
      print(e);
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) AppHelper.feedbackMessage(ctx, 'Houve um erro, Tente novamente!');
    }
  }

  //FUNÇÃO DE ALTERAÇÃO JOGADOR NA ESCALAÇÃO
  void setPlayerEscalation(dynamic id) {
    final idx = playersMarket.indexWhere((p) => p.id == id);
    final player = idx != -1 ? playersMarket[idx] : null;
    if (player == null) {
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) AppHelper.feedbackMessage(ctx, 'Jogador não encontrado!');
      return;
    }
    try {
      bool isEscaled = findPlayerEscalation(id);
      setPlayerPosition(player);
      String action = isEscaled ? 'remove' : 'add';
      calcTeamPrice(user.player!.ratings!.first.price!, action);
    } catch (e) {
      print(e);
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) AppHelper.feedbackMessage(ctx, 'Houve um erro, Tente novamente!');
    }
    selectedPlayer = 0;
    selectedOccupation = '';
  }

  //FUNÇÃO DE BUSCA DE JOGADOR NA ESCALAÇÃO
  bool findPlayerEscalation(int id) {
    bool found = false;
    starters.asMap().forEach((i, participant) {
      if (participant != null && participant == id) found = true;
    });
    reserves.asMap().forEach((i, participant) {
      if (participant != null && participant == id) found = true;
    });
    return found;
  }

  //FUNÇÃO PARA CONTABILIZAÇÃO DE PREÇO DA EQUIPE E PATRIMONIO
  void calcTeamPrice(double playerPrice, String action) {
    final roundedPrice = double.parse(playerPrice.toStringAsFixed(2));
    if (action == 'add') {
      managerTeamPrice = double.parse((managerTeamPrice + roundedPrice).toStringAsFixed(2));
      managerPatrimony = double.parse((managerPatrimony - roundedPrice).toStringAsFixed(2));
    } else {
      managerTeamPrice = double.parse((managerTeamPrice - roundedPrice).toStringAsFixed(2));
      managerPatrimony = double.parse((managerPatrimony + roundedPrice).toStringAsFixed(2));
    }
  }
}
