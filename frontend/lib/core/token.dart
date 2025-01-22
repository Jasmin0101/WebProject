import 'package:shared_preferences/shared_preferences.dart';

final class TokenService {
  final String _key = 'access_token';
  late final SharedPreferences prefs;

  String? _token;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_key);
  }

  Future<void> saveToken(String newToken) async {
    _token = newToken;
    prefs.setString(_key, newToken);
  }

  Future<void> removeToken() async {
    _token = null;
    prefs.remove(_key);
  }

  bool haveValidToken() {
    return _token != null;
  }

  String? getToken() {
    return _token;
  }
}

final tokenService = TokenService();
