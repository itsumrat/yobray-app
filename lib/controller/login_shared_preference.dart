import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yo_bray/data/model/user_info_model.dart';
import 'package:yo_bray/ulits/strings.dart';

class LoginSharedPreference {
  static final _preferences = Get.find<SharedPreferences>();

  static Future<void> setLoginInformation(Userinfo profile) async {
    _preferences.setString(Strings.profile, json.encode(profile));
  }

  static String getLoginInformation() {
    return _preferences.getString(Strings.profile) ?? '';
  }

  static Future<void> setLowStockList(Map<String, int> profile) async {
    profile = {...getLowStockList(), ...profile};
    _preferences.setString(Strings.lowStockList, json.encode(profile));
  }

  static Map getLowStockList() {
    final _dataList = _preferences.getString(Strings.lowStockList) ?? '';
    if (_dataList.isNotEmpty) return json.decode(_dataList) as Map;
    return {};
  }

  static Map<String, dynamic> getProductReminder(int id) {
    final _dataList = getLowStockList();
    if (_dataList.containsKey('$id'))
      return {'isFind': true, 'value': _dataList['$id']};
    return {'isFind': false};
  }

  static Future<void> setAccessToken(String accessToken) async {
    _preferences.setString(Strings.token, accessToken);
  }

  static String getAccessToken() {
    return _preferences.getString(Strings.token) ?? '';
  }

  static Future<void> logout() async {
    await _preferences.clear();
    _preferences.setBool('isFastLoading', true);
  }

  static int getLowStock() {
    return _preferences.getInt(Strings.stock) ?? 0;
  }

  static Future<void> setLowStock(int stock) async {
    _preferences.setInt(Strings.stock, stock);
  }
}
