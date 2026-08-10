import 'package:flutter/foundation.dart';
import 'package:futzada/core/helpers/user_helper.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';

//===MIXIN - DIA DE EVENTO===
mixin GameDayEventMixin on ChangeNotifier implements GameBase {
  @override
  List<UserModel> participantsClone = [];

  final List<UserModel> _participantsPresent = [];
  @override
  List<UserModel> get participantsPresent => _participantsPresent;

  //FUNÇÃO DE SIMULAÇÃO DE CONFIRMAÇÃO DE JOGADORES
  void addParticipantsPresents() {
    for (var user in event!.participants!) {
      final player = UserHelper.getParticipant(user.participants, event!.id!);
      if (user.player != null && player != null && player.role!.contains("Player")) {
        participantsClone.add(user);
        _participantsPresent.add(user);
        notifyListeners();
      }
    }
  }

  //FUNÇÃO PARA DEFINIR LISTA DE PARTICIPANTES PRESENTES
  void setParticipantsPresent(List<UserModel> list) {
    _participantsPresent.clear();
    _participantsPresent.addAll(list);
    notifyListeners();
  }

  //FUNÇÃO PARA REORDENAR JOGADORES PRESENTES
  void reorderParticipants(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final participant = _participantsPresent.removeAt(oldIndex);
    _participantsPresent.insert(newIndex, participant);
    notifyListeners();
  }
}
