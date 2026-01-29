import 'dart:math';
import 'package:futzada/data/models/participant_model.dart';

class RankService {
  static var random = Random();

  //FUNÇÃO DE GERAÇÃO DE RANKING
  List<ParticipantModel> generateRank(int qtd, List<ParticipantModel> participants){
    return List.generate(qtd, (participant){
      int index = random.nextInt(participants.length) ;
      return participants[index];
    });
  }
}