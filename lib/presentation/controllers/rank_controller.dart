import 'package:flutter/foundation.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/services/rank_service.dart';
import 'package:esportly/presentation/controllers/event_controller.dart';

abstract class RankBase {
  //GETTER - SERVIÇO DE PARTIDAS
  RankService get rankService;
  //ESTADO - RANKING
  String get type;
  set type(String v);
  //ESTADO - LISTA DE RANKINGS
  List<UserModel?> get topRanking;
}

class RankController extends ChangeNotifier implements RankBase {
  //GETTER DE CONTROLLERS
  static RankController get instance => sl<RankController>();
  final EventController eventController = EventController.instance;

  //GETTER DE SERVIÇOS
  @override
  RankService rankService = RankService();

  //ESTADO - RANKING TYPE
  String _type = 'Artilheiros';
  @override
  String get type => _type;
  @override
  set type(String v) { _type = v; notifyListeners(); }

  //ESTADO - LISTA DE RANKINGS
  final List<UserModel> _topRanking = [];
  @override
  List<UserModel> get topRanking => _topRanking;

  void init() {
    //topRanking..addAll(eventController.event.participants!.take(10));
  }

  void setTopRanking(List<UserModel> list) {
    _topRanking.clear();
    _topRanking.addAll(list);
    notifyListeners();
  }
}
