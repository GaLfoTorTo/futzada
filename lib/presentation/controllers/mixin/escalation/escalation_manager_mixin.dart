import 'package:futzada/data/models/escalation_model.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:futzada/presentation/controllers/escalation_controller.dart';

//===MIXIN - GERENCIAMENTO DE ESCALAÇÃO===
mixin EscalationManagerMixin on GetxController implements EscalationBase {
  @override
  bool canManager = false;
  @override
  final RxString category = ''.obs;
  @override
  final RxString formation = ''.obs;
  @override
  final RxInt selectedPlayer = 0.obs;
  @override
  final RxString selectedOccupation = ''.obs;
  @override
  final RxInt selectedPlayerCapitan = 0.obs;
  @override
  final RxDouble managerPatrimony = 100.0.obs;
  @override
  final RxDouble managerTeamPrice = 0.0.obs;
  @override
  final RxDouble managerValuation = 0.0.obs;
  @override
  List<String> formations = [];
  
  //DADOS DO EVENTO
  @override
  late EventModel? event;
  @override
  late RxList<Map<String, dynamic>> myEscalations;
  //ESTADOS
  @override
  late RxMap<String, RxMap<int, UserModel?>> escalation;
  @override
  late RxList<int?> starters = <int?>[].obs;
  @override
  late RxList<int?> reserves = <int?>[].obs;
  
  //FUNÇÃO PARA SELECIONAR EVENTO E ATUALIZAR DADOS REFERNTES AO EVENTO
  void setEvent(id) async{
    isLoading.value = true;
    try {  
      //ATUALIZAR EVENTO SELECIONADO
      event = events.firstWhere((event) => event.id == id);
      //CARREGAR JOGADORES DO MERCADO
      playersMarket.value = await userService.fecthSuggestionFriends();
      //APLICAR FILTRO INICIAL NOS JOGADORES DO MERCADO
      filteredPlayersMarket.value = [];//filterMarketPlayers();
      //ATUALIZAR CATEGORIA DO EVENTO SELECIONADOS
      category.value = events.firstWhere((event) => event.id == event.id).gameConfig!.category;
      //DEFINIR FORMAÇÕES APARTIR DE CATEGORIA SELECIONADA
      formations = escalationService.getFormations(category.value);
    } catch (e) {
      hasError.value = true;
    }
    isLoading.value = false;
  }

  //FUNÇÃO QUE RESGATAR DADOS DE ESCALAÇÃO DO USUARIO NO EVENTO SELECIONADO
  void setUserInfo() {
    isLoading.value = true;
    try {  
      //RESGATAR ESCALAÇÃO DO USUARIO PARA EVENTO SELECIONADO
      EscalationModel userEscalation = escalationService.generateEscalation(category.value);
      //RESGATAR FORMAÇÃO DA ESCALAÇÃO
      formation.value = userEscalation.formation!;
      //RESGATAR ESCALAÇÃO (TITULARES E RESERVAS)
      starters.value = userEscalation.starters ?? escalationService.setEscalation(category.value, 'starters');
      reserves.value = userEscalation.reserves ?? escalationService.setEscalation(category.value, 'reserves');
      //RESGATR ECONOMIA DO MANAGER
      managerPatrimony.value = user.manager!.economies!.firstWhere((e) => e.eventId == event!.id).patrimony!;
      managerTeamPrice.value = user.manager!.economies!.firstWhere((e) => e.eventId == event!.id).price!;
      managerValuation.value = user.manager!.economies!.firstWhere((e) => e.eventId == event!.id).valuation!;
    } catch (e) {
      hasError.value = true;
    }
    isLoading.value = false;
  }
}