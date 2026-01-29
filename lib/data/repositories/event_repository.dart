import 'package:futzada/data/models/event_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:futzada/data/services/event_service.dart';

class EventRepository {
  //SERVIÇOS - USUARIO, LOCAL STORAGE
  final EventService remoteService = EventService();
  final GetStorage localStorage =  GetStorage();
  final List<EventModel> _cache = <EventModel>[].obs;
  
  @override
  Future<List<EventModel>?> getEvents() async {
    //VERIFICAR SE CACHE ESTA VAZIO
    if (_cache.isNotEmpty) {
      //USUARIO EM CACHE
      return _cache;
    }
    try {
      //BUSCAR USUARIO
      final events = await remoteService.fetchEvents();
      //ADICICONAR AO CACHE
      _cache.assignAll(events);
      return events;
    } catch (e, stackTrace) {
      //BUSCAR USUARIOS NO STORAGE LOCAL
      print('=== ERRO COMPLETO ===');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      print('=====================');
      return [];
    }
  }

  @override
  Future<EventModel> getEventById(int id) async {
    //VERIFICAR SE CACHE ESTA VAZIO
    if (_cache.isNotEmpty) {
      //USUARIO EM CACHE
      return _cache.firstWhere((u) => u.id == id); 
    }
    
    try {
      //BUSCAR USUARIO
      final events = await remoteService.fetchEventById(id);
      return events;
    } catch (e) {
      //BUSCAR USUARIOS NO STORAGE LOCAL
      Get.log('API failed, using local data: $e');
      return await localStorage.read("events");
    }
  }

  @override
  Future<List<EventModel>> getUserEvents(int? userId) async {
    try {
      //BUSCAR EVENTOS DO USUARIO
      return await remoteService.fetchUserEvents(userId);
    } catch (e, stackTrace) {
      //BUSCAR USUARIOS NO STORAGE LOCAL
      print('=== ERRO COMPLETO ===');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      print('=====================');
      return await localStorage.read("events") ?? [];
    }
  }
}