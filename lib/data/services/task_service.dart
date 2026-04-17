import 'dart:math';
import 'package:faker/faker.dart';
import 'package:futzada/data/models/task_model.dart';


class TaskService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();
  
  //FUNÇÃO DE GERAÇÃO DE USUARIOS
  TaskModel generateTask(){
    //DEFINIR USUARIO
    return TaskModel.fromMap({
      "id" : faker.randomGenerator.integer(100, min: 1),
      "uuid" : faker.jwt.secret.toString(),
      "title" : faker.company.name(),
      "description" : faker.lorem.sentence().toString(),
      "points" : faker.randomGenerator.integer(10000, min: 1),
      "recurrent" : false,
      "createdAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
      "updatedAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
    });
  }
}