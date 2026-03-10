import 'package:get/get.dart';
import 'package:futzada/core/helpers/user_helper.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';

//===MIXIN - DIA DE EVENTO===
mixin GameDayEventMixin on GetxController implements GameBase{
  @override
  List<UserModel> participantsClone = [];
  @override
  RxList<UserModel> participantsPresent = <UserModel>[].obs;
  
  //FUNÇÃO DE SIMULAÇÃO DE CONFIRMAÇÃO DE JOGADORES
  void addParticipantsPresents() {
    for(var user in event!.participants!) {
      final player = UserHelper.getParticipant(user.participants, event!.id!);
      //VERIFICAR SE PARTICIPANTE ATUA COMO JOGADOR
      if(user.player != null && player != null && player.role!.contains("Player")){
        participantsClone.add(user);
        participantsPresent.add(user);
        update();
      }
    }
  }

  //FUNÇÃO PARA REORDENAR JOGADORES PRESENTES
  void reorderParticipants(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final participant = participantsPresent.removeAt(oldIndex);
    participantsPresent.insert(newIndex, participant);
  }
}