import 'package:get/get.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/models/user_config_model.dart';
import 'package:futzada/data/services/manager_service.dart';
import 'package:futzada/data/services/participant_service.dart';
import 'package:futzada/data/services/player_service.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/services/user_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  //SERVIÇOS - USUARIO, LOCAL STORAGE
  final UserService remoteService = UserService();
  final GetStorage localStorage =  GetStorage();
  final List<UserModel>_cache = <UserModel>[].obs;
  
  @override
  Future<UserModel> getUser(int id) async {
    //VERIFICAR SE CACHE ESTA VAZIO
    if (_cache.isNotEmpty) {
      //USUARIO EM CACHE
      return _cache.firstWhere((u) => u.id == id); 
    }
    
    try {
      //BUSCAR USUARIO
      final user = await remoteService.fetchUser(id);
      //ADICICONAR AO CACHE
      _cache.add(user);
      return user;
    } catch (e) {
      //BUSCAR USUARIOS NO STORAGE LOCAL
      Get.log('API failed, using local data: $e');
      return await localStorage.read("user");
    }
  }
  
  //FUNÇÃO DE TESTE
  @override
  Future<UserModel?> getUserGoogle(GoogleSignInAccount? data) async {    
    try {
      if(data != null){
        //RESGATAR DADOS DO USUÁRIO FORNECIDOS PELO GOOGLE
        String? firstName = data.displayName?.split(' ')[0] ?? 'Usuario';
        String? lastName = data.displayName?.split(' ').skip(1).join(' ') ?? 'Anônimo';
        final config = UserConfigModel(
          id: 1,
          userId: 1,
          mainModality: Modality.Football,
          modalities: [Modality.Football, Modality.Volleyball, Modality.Basketball],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        //CRIAR NOVA INSTANCIA DE USUARIO COM DADOS DO GOOGLE
        return UserModel(
          id: 1,
          uuid: "9813yty3h4nlang90g0jpsigoisjiod",
          firstName: firstName,
          lastName: lastName,
          userName: "${firstName}_${lastName}",
          email: data.email,
          bornDate: "1998-06-12",
          phone: "61982413358",
          photo: data.photoUrl,
          privacy: Privacy.Public,
          config: config,
          player: PlayerService().generatePlayer(1),
          manager: ManagerService().generateManager(1),
          participants: List.generate(2, (i) => ParticipantService().generateParticipant(i + 1, 1)),
        );
      }
      return null;
    } catch (e, stackTrace) {
      //BUSCAR USUARIOS NO STORAGE LOCAL
      Get.log('API failed, using local data: $e');
      print('Stack trace: $stackTrace');
      return await localStorage.read("user");
    }
  }
}