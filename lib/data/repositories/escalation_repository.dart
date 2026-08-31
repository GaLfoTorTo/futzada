import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/services/escalation_service.dart';

class EscalationRepository {
  //SERVIÇOS - USUARIO, CACHE LOCAL
  final EscalationService remoteService = EscalationService();

  //CHAMADA - BUSCA DE PARTICIPANTS
  Future<List<UserModel?>> getParticipants(int id) async {
    try {
      //BUSCAR USUARIO
      final participants = await remoteService.participantsFetch(id);
      return participants;
    } catch (e) {
      return [];
    }
  }
}