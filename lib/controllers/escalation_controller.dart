import 'package:get/get.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/services/player_services.dart';
import 'package:futzada/models/player_model.dart';

class EscalationController extends GetxController{
  //DEFINIR CONTROLLER UNICO NO GETX
  static EscalationController get instace => Get.find();
  //INSTANCIAR SERVICE DE JOGADORES
  static PlayerService _playerService = PlayerService();
  
  //CONTROLADOR DE CATEGORIA DO CAMPO
  final String category = 'Campo';
  
  //FORMAÇÃO SELECIONADA
  String selectedFormation = '4-3-3';
  
  //CONTROLADOR DE EVENTO SELECIONADO
  int selectedEvent = 0;
  
  //CONTROLADOR DE INDEX PARA JOGADOR ADICIONADO OU REMOVIDO
  RxInt selectedPlayer = 0.obs;
  
  //CONTROLADOR DE OCUPAÇÃO DO JOGADOR NA ESCALAÇÃO
  RxString selectedOcupation = ''.obs;
  
  //LISTA DE EVENTOS DO USUARIO
  RxList<Map<String, dynamic>> myEvents = [
    /* for(var i = 0; i <= 2; i++) */
      {
        'id' : 0,
        'title': 'Fut dos Cria',
        'photo': AppImages.userDefault,
      },
      {
        'id' : 1,
        'title': 'Pelada Divineia',
        'photo': AppImages.userDefault,
      },
      {
        'id' : 2,
        'title': 'Ginásio',
        'photo': AppImages.userDefault,
      },
  ].obs;
  
  //JOGADORES DO MERCADO
  RxList<PlayerModel> playersMarket = _playerService.playersMarket;
  
  //ESCALAÇÃO DO USUARIO
  final RxMap<String, RxMap<int, PlayerModel?>> escalation = setEscalation();

  //FUNÇÃO PARA INICIALIZAR ESCALAÇÃO COM VALORES NULOS
  static RxMap<String, RxMap<int, PlayerModel?>> setEscalation() {
  //CRIAR MAPS DE TITULARES E RESERVAS OBSERVAVEIS
  final starters = <int, PlayerModel?>{}.obs;
  final reserves = <int, PlayerModel?>{}.obs;
  //INICIALIZAR COM VALORES NULOS
  for (var i = 0; i < 11; i++) {
    starters[i] = null;
  }
  for (var i = 0; i < 5; i++) {
    reserves[i] = null;
  }
  //RETORNAR ESCALAÇÃO
  return <String, RxMap<int, PlayerModel?>>{
    'starters': starters,
    'reserves': reserves,
  }.obs;
  }

  //FUNÇÃO PARA ADICIONAR OU REMOVER JOGADOR DA ESCALAÇÃO
  void setPlayerEscalation(dynamic id){
    //RESGATR JOGADOR DO MERCADO
    final player = _playerService.findPlayer(id);
    //VERIFICAR SE JOGADOR FOI ENCONTRADO
    if (player == null) {
      //EXIBIR MENSAGEM DE ERRO
      AppHelper.erroMessage(Get.context, 'Jogador não encontrado!');
      return;
    }
    try {
      //VERIFICAR EM QUE OCUPAÇÃO O JOGADOR ESTA NA ESCALAÇÃO
      bool isEscaled = verifyPlayerEscalation(player);
      //RESGATAR CONTROLADORES DE OCUPACAO E INDEX DO JOGADOR
      int playerIndex = selectedPlayer.value;
      String playerOcupation = selectedOcupation.value;
      //VERIFICAR SE JOGADOR JÁ ESTA ESCALADO
      if(!isEscaled){
        //ADICIONAR JOGADOR NA POSIÇÃO
        escalation[playerOcupation]![playerIndex] = player;
      }else{
        //REMOVER JOGADOR DA POSIÇÃO
        escalation[playerOcupation]![playerIndex] = null;
      }
    } catch (e) {
      print(e);
      //EXIBIR MENSAGEM DE ERRO
      AppHelper.erroMessage(Get.context, 'Houve um erro, Tente novamente!');
    }
    //RESETAR POSIÇÃO E OCUPAÇÃO DO JOGADOR SELECIONADO
    selectedPlayer.value = 0;
    selectedOcupation.value = '';
  }
  
  //FUNÇÃO PARA VERIFICAR SE JOGADOR JA FOI ESCALADO
  bool verifyPlayerEscalation(PlayerModel player){
    //PERCORRER ESCALAÇÕES DO USUARIO (STARTERS E RESERVES)
    for (var arr in escalation.entries){
      //RESGATAR CHAVE
      var chave = arr.key;
      //RESGATAR LISTA POR CHAVE
      var map = arr.value;
      //LOOP NA LISTA
      for (int i = 0; i < map.length; i++) {
        //VERIFICAR SE JOGADOR FOI ESCALADO COMO TITULAR OU RESERVA
        if (map[i] == player) {
          //ATUALIZAR INDEX E OCUPAÇÃOS
          selectedPlayer.value = i;
          selectedOcupation.value = chave;
          return true;
        }
      }
    }
    return false;
  }
  
  //FUNÇÃO DE BUSCA DE JOGADOR NA ESCALAÇÃO
  bool findPlayerEscalation(int id) {
    //PERCORRER ESCALAÇÕES DO USUARIO (STARTERS E RESERVES)
    for (var arr in escalation.entries){
      //RESGATAR LISTA POR CHAVE
      var map = arr.value;
      //LOOP NA LISTA
      for (int i = 0; i < map.length; i++) {
        //VERIFICAR SE JOGADOR FOI ESCALADO COMO TITULAR OU RESERVA
        if (map[i] != null && map[i]!.id == id) {
          return true;
        }
      }
    }
    return false;
  }
}