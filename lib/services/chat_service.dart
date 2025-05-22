import 'dart:math';
import 'package:faker/faker.dart';
import 'package:futzada/models/user_model.dart';
import 'package:intl/intl.dart';

class ChatService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();
  
  //GENERATE CHATS
  List<Map<String, dynamic>> generateChats(){
    List<Map<String, dynamic>> map = [];
    //LOOP PARA TITULARES
    for (var i = 1; i <= 50; i++) {
      //ADICIONAR JOGADOR A LISTA
      map.add({
        'user': UserModel.fromMap({
          'uuid' : "$i",
          'firstName': faker.person.firstName(),
          'lastName': faker.person.lastName(),
          'userName': "${faker.person.firstName()}_${faker.person.lastName()}",
          'photo': faker.image.loremPicsum()
        }),
        'messages': List.generate(random.nextInt(20), (index) => {
          'text': faker.lorem.sentence().toString(),
          'autor': random.nextBool(),
          'time': faker.date.justTime(),
          'readed': random.nextBool(),
        }),
        'date': DateFormat('dd/MM/yyyy').format(faker.date.dateTime(minYear: 2024, maxYear: 2026)),
      });
    }
    //RETORNAR LISTA DE NOTIFICAÇÕES
    return map;
  }
}