
//===MIXIN - VISÃO GERAL===
import 'package:flutter/foundation.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/presentation/controllers/event_controller.dart';

mixin EventOverviewMixin on ChangeNotifier {

  //FUNÇÃO PARA BUSCAR SUGESTÕES DE EVENTOS
  Future<List<EventModel>> getSuggestions() async{
    //REGATAR SERVIÇO DE VENTO
    return await EventController.instance.eventRepository.getEvents() ?? [];
  }
}