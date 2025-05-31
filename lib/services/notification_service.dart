import 'package:faker/faker.dart';
import 'package:intl/intl.dart';

class NotificationService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();

  //GENERATE NOTIFICATIONS
  List<Map<String, dynamic>> generateNotifications(){
    List<Map<String, dynamic>> arr = [];
    //LOOP PARA TITULARES
    for (var i = 1; i <= 50; i++) {
      //ADICIONAR JOGADOR A LISTA
      arr.add({
        'title': faker.sport.name(),
        'user': "${faker.person.firstName()} ${faker.person.lastName()}",
        'description': faker.lorem.sentence().toString(),
        'date': DateFormat('dd/MM/yyyy').format(faker.date.dateTime(minYear: 2024, maxYear: 2026)),
        'time': faker.date.justTime(),
        'image': faker.image.loremPicsum(),
      });
    }
    //AGRUPAR NOTIFICAÇÕES
    arr = groupNotifications(arr);
    //ORDENAR NOTIFICAÇÕES DA MAIS RECENTE PARA A MAIS ANTIGA
    arr = orderNotifications(arr);
    //RETORNAR LISTA DE NOTIFICAÇÕES
    return arr;
  }

  //AGRUPAR NOTIFICAÇÕES
  List<Map<String, dynamic>> groupNotifications(List<Map<String, dynamic>> notifications) {
    //MAP DE AGRUPAMENTO
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    //LISTA FINAL DE NOTIFICAÇÕES
    List<Map<String, dynamic>> finalList = [];
    //LOOP NAS NOTIFICAÇÕES
    for (var notif in notifications) {
      //GERAR GRUPO DE NOTIFICAÇÕES POR TIUTULO
      grouped.putIfAbsent("${notif['title']}", () => []).add(notif);
    }
    //LOOP NO GRUPO DE NOTIFICAÇÕES
    grouped.forEach((key, group) {
      //VERIFICAR SE GRUPO E MAIOR OU IGUAL A 1
      if (group.length == 1) {
        //ADICIONAR A LISTA FINAL DE NOTIFICAÇÕES
        finalList.add(group.first);
      } else {
        //RESGATAR NOTIFICAÇÕES AGRUPADAS
        final first = group.first;
        //ADICIONAR A LISTA FINAL DE NOTIFICAÇÕES AGRUPADAS
        finalList.add({
          'title': first['title'],
          'description': "${first['user']} e ${first['user']} ${first['description']}",
          'date': first['date'],
          'time': first['time'],
          'image': group.map((n) => n['image']).toList(),
        });
      }
    });
    return finalList;
  }

  //ORDENAR NOTIFICAÇÕES
  List<Map<String, dynamic>> orderNotifications(List<Map<String, dynamic>> notifications) {
    //COMPARAR DATAS DE NOTIFICAÇÕES
    notifications.sort((a, b) {
      return b['date']!.compareTo(a['date']!);
    });
    //RETORNAR LISTA ORDENADA
    return notifications;
  }  
}