import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static late SharedPreferences _storage;

  //GETTER DE LEITURA
  static T? read<T>(String key) => _storage.get(key) as T?;

  //GETTER DE VERIFICAÇÃO
  static bool hasData(String key) => _storage.containsKey(key);

  //FUNÇÃO DE INICIALIZAÇÃO DE STORAGE (SHARED PREFERENCES)
  static Future<void> init() async {
    _storage = await SharedPreferences.getInstance();
  }

  //FUNÇÃO DE ESCRITA NO STORAGE
  static Future<void> write(String key, dynamic value) async {
    if (value is String) {
      await _storage.setString(key, value);
    } else if (value is bool) {
      await _storage.setBool(key, value);
    } else if (value is int) {
      await _storage.setInt(key, value);
    } else if (value is double) {
      await _storage.setDouble(key, value);
    }
  }

  //FUNÇÃO DE ESCRITA SE NULL
  static Future<void> writeIfNull(String key, dynamic value) async {
    if (!_storage.containsKey(key)) await write(key, value);
  }

  //FUNÇÃO DE REMOÇÃO
  static Future<void> remove(String key) async => _storage.remove(key);
}
