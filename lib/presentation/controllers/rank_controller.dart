import 'package:flutter/foundation.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/services/rank_service.dart';

abstract class RankBase {
  RankService get rankService;
  String get type;
  set type(String v);
  List<UserModel?> get topRanking;
}

class RankController extends ChangeNotifier implements RankBase {
  static RankController get instance => sl<RankController>();

  @override
  RankService rankService = RankService();

  String _type = 'Artilheiros';
  @override
  String get type => _type;
  @override
  set type(String v) { _type = v; notifyListeners(); }

  final List<UserModel> _topRanking = [];
  @override
  List<UserModel> get topRanking => _topRanking;

  void setTopRanking(List<UserModel> list) {
    _topRanking.clear();
    _topRanking.addAll(list);
    notifyListeners();
  }
}
