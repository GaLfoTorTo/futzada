import 'dart:math';
import 'package:faker/faker.dart';
import 'package:esportly/data/models/task_model.dart';


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
      "category" : faker.randomGenerator.element(["onboarding", "player", "manager", "participation", "organization", "social"]),
      "modality" : null,
      "completed" : null,
      "completedAt" : null,
    });
  }
}