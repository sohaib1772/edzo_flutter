import 'package:edzo/core/helpers/role_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences sharedPreferences;
  static late FlutterSecureStorage secureStorage;
  
  
  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    secureStorage = const FlutterSecureStorage();
  }
  static Future<void> saveRole(String role) async {
     await secureStorage.write(key: 'role', value: role);
  }
  static Future<Role> getRole() async {
    String? role = await secureStorage.read(key: 'role');
    return (Role.values.where((element) => element.toString() == role).firstOrNull ?? Role.student);
  }
  static Future<void> saveToken(String token) async {
    await secureStorage.write(key: 'token', value: token);
  }

  static Future<String?> getToken() async {
    return await secureStorage.read(key: 'token');
  }

  static Future<void> removeToken() async {
    await secureStorage.delete(key: 'token');
  }

  static Future<void> saveTheme(bool isDarkMode) async {
    await sharedPreferences.setBool('isDarkMode', isDarkMode);
  }

  static Future<bool> getTheme() async {
    return sharedPreferences.getBool('isDarkMode') ?? true;
  }

  static Future<void> saveLastChunkNumber(String key,int lastChunkNumber) async {
    await sharedPreferences.setInt('lastUploadedChunk_$key', lastChunkNumber);
  }
  static Future<int?> getLastChunkNumber(String key) async {
    return sharedPreferences.getInt('lastUploadedChunk_$key');
  }
  static Future<void> removeLastChunkNumber(String key) async {
    await sharedPreferences.remove('lastUploadedChunk_$key');
  }
}
