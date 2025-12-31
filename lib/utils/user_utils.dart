import 'package:futzada/models/user_model.dart';

class UserUtils {
  static getFullName(UserModel user){
    return "${user.firstName} ${user.lastName}";
  }
}