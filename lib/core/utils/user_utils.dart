import 'package:futzada/data/models/participant_model.dart';
import 'package:futzada/data/models/player_model.dart';
import 'package:futzada/data/models/rating_model.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:get/get.dart';

class UserUtils {
  //FUNÇÃO PARA RESGATAR NOME COMPLETO DO USUARIO
  static getFullName(UserModel user){
    return "${user.firstName!.capitalizeFirst} ${user.lastName!.capitalizeFirst}";
  }

  static ParticipantModel? getParticipant(List<ParticipantModel>? participants, int eventId){
    if(participants != null) {
      participants.firstWhere((p) => p.eventId == eventId);
    }
    return null;
  }
  
  static RatingModel getRating(PlayerModel player, int eventId){
    return player.ratings!.firstWhere((r) => r.eventId == eventId);
  }
}