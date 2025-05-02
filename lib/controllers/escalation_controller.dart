import 'package:get/get.dart';
import 'package:futzada/theme/app_images.dart';

class EscalationController extends GetxController{
  //DEFINIR CONTROLLER UNICO NO GETX
  static EscalationController get instace => Get.find();
  //JOGADORES NO MERCADO
  final RxList<Map<String, dynamic>> playersMarket = [
    for(var i = 0; i <= 25; i++)
      {
        'uuid': i,
        'firstName': 'Jeferson',
        'lastName': 'Vasconcelos',
        'userName': 'jeff_vasconcelos',
        'position': 'ata',
        'status' : 'Ativo',
        'lastPontuation': -7.85,
        'media': 3.64,
        'price': 12.85,
        'valorization': 1.02,
        'games': 23,
        'photo': null,
      },
  ].obs;
  //ESCALAÇÃO DO USUARIO
  RxMap<String, dynamic> userEscalation = setEscalation();
  //FUNÇÃO PARA GERAÇÃO DE FORMAÇÃO (TEMPORARIAMENTE)
  static RxMap<String, dynamic> setEscalation() {
    //DEFINIR MAPS DE ESCALAÇÃO (TITULARES E RESERVAS)
    Map<int, dynamic> starters = {};
    Map<int, dynamic> reserves = {};
    //LOOP PARA TITULARES
    for (var s = 0; s < 11; s++) {
      //map['starters']![i] = null;
      starters[s] = {
        'uuid': s,
        'firstName': 'Jeferson',
        'lastName': 'Vasconcelos',
        'userName': 'jeff_vasconcelos',
        'position': getPosition(s),
        'status': 'Ativo',
        'lastPontuation': -7.85,
        'media': 3.64,
        'price': 12.85,
        'valorization': 1.02,
        'games': 23,
        'photo': null,
      };
    }
    //LOOP PARA RESERVAS
    for (int r = 0; r < 5; r++) {
      reserves[r] = null;
      /* map['reserves']![i] = {
        'uuid': r,
        'firstName': 'Jeferson',
        'lastName': 'Vasconcelos',
        'userName': 'jeff_vasconcelos',
        'position': getPosition(r),
        'status': 'Ativo',
        'lastPontuation': -7.85,
        'media': 3.64,
        'price': 12.85,
        'valorization': 1.02,
        'games': 23,
        'photo': null,
      }; */
    }
    //JUNTAR MAPS
    final Map<String, dynamic> map = {
      'starters': starters,
      'reserves': reserves,
    };
    return map.obs;
  }
  //FUNÇÃO PARA DEFINIR POSIÇÃO DINAMICAMENTE (TEMPORARIA)
  static String getPosition(i){
    if(i == 0){
      return 'gol';
    }else if(i ==  1 || i ==  2 || i == 3 || i == 4){
      return 'zag';
    }else if(i ==  5 || i == 6 || i == 7){
      return 'mei';
    }else{
      return 'ata';
    }
  }
  //FORMAÇÃO SELECIONADA
  String selectedFormation = '4-3-3';
  //EVENTO SELECIONADO
  int selectedEvent = 0;
  //LISTA DE EVENTOS DO USUARIO
  final RxList<Map<String, dynamic>> myEvents = [
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
}