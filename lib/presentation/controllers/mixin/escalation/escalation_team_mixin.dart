import 'package:get/get.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/controllers/escalation_controller.dart';

//===MIXIN - GERENCIAMENTO DE EQUIPE===
mixin EscalationTeamMixin on GetxController implements EscalationBase {  
  
  //FUNÇÃO PARA ALTERAR JOGADOR NA ESCALAÇÃO (TITULARES)
  void setPlayerPosition(UserModel? player) {
    //VERIFICAR SE JOGADOR E TITULAR OU RESERVA
    if(selectedOccupation.value == 'starters'){
      starters[selectedPlayer.value] = starters[selectedPlayer.value] == null ? player!.id : null;
    }else{
      reserves[selectedPlayer.value] = starters[selectedPlayer.value] == null ? player!.id : null;
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
      calcTeamPrice(user.player!.ratings!.first.price!, action);
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
      if (participant != null && participant == id) {
        found = true;
      }
    });
    //PERCORRER MAPA DE RESERVAS
    reserves.asMap().forEach((i, participant) {
      //VERIFICAR SE JOGADOR FOI ESCALADO
      if (participant != null && participant == id) {
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