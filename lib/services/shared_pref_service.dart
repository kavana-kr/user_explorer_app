import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  // ---------------- LOGIN ----------------

  // saves login status (user is logged in)
  static Future<void> saveLogin() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isLoggedIn', true);
  }

  // returns whether user is logged in
  static Future<bool> getLogin() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('isLoggedIn') ?? false;
  }

  // clears login state (user is logged out)
  static Future<void> removeLogin() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isLoggedIn', false);
  }

  // ---------------- THEME ----------------

  // save theme mode (true = dark, false = light)
  static Future<void> saveTheme(bool isDark) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isDark', isDark);
  }

  // get stored theme mode
  static Future<bool> getTheme() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('isDark') ?? false;
  }

  // ---------------- FAVORITES ----------------

  // save list of favorite user IDs
  static Future<void> saveFavoriteIds(List<int> ids) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setStringList(
      'favoriteIds',
      ids.map((e) => e.toString()).toList(),
    );
  }

  // returns saved favorite user IDs
  static Future<List<int>> getFavoriteIds() async {
    final pref = await SharedPreferences.getInstance();
    final list = pref.getStringList('favoriteIds') ?? [];
    return list.map(int.parse).toList();
  }

  // clears all favorite user IDs
  static Future<void> clearFavorites() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('favoriteIds');
  }

  // ---------------- CREDENTIALS ----------------

  // save email + password for "Remember Me" feature
  static Future<void> saveCredentials(String email, String password) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('savedEmail', email);
    await pref.setString('savedPassword', password);
  }

  // get stored email + password
  static Future<Map<String, String>> getCredentials() async {
    final pref = await SharedPreferences.getInstance();
    return {
      "email": pref.getString('savedEmail') ?? "",
      "password": pref.getString('savedPassword') ?? "",
    };
  }

  // remove stored login credentials
  static Future<void> clearCredentials() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('savedEmail');
    await pref.remove('savedPassword');
  }
}
