import 'dart:math';
import 'package:futzada/data/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';

class ChatService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();

  //INSTANCIAR SERVIÇO DE USUARIO
  UserService userService = UserService();
  
  //GENERATE CHATS
  List<Map<String, dynamic>> generateChats(){
    //DEFINIR LISTA DE CHATS
    List<Map<String, dynamic>> arr = [];
    //LOOP PARA TITULARES
    List.generate(50, (i){
      //ADICIONAR CHAT A LISTA
      arr.add({
        'user': userService.generateUser(i),
        'messages': List.generate(random.nextInt(20), (index) => {
          'text': faker.lorem.sentence().toString(),
          'autor': random.nextBool(),
          'time': faker.date.justTime(),
          'readed': random.nextBool(),
        }),
        'date': DateFormat('dd/MM/yyyy').format(faker.date.dateTime(minYear: 2024, maxYear: 2026)),
      });
    });
    //RETORNAR LISTA DE NOTIFICAÇÕES
    return arr;
  }
}