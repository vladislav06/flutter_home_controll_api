import 'dart:convert';

import 'package:home_controller/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static final SettingsManager _instance = SettingsManager._internal();

  factory SettingsManager() {
    return _instance;
  }

  SettingsManager._internal() {}

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    ip1 = IP(prefs.getString("ip1") ?? "1.1.1.1");
    ip2 = IP(prefs.getString("ip2") ?? "1.1.1.1");
    fovilightIp = IP(prefs.getString("fovilightIp") ?? "1.1.1.1");
  }

  Future<void> save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ip1', ip1.ip);
    prefs.setString('ip2', ip2.ip);
    prefs.setString('fovilightIp', fovilightIp.ip);
  }

  late IP ip1;
  late IP ip2;
  late IP fovilightIp;
}
