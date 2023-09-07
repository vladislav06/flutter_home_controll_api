import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class IP {
  IP(this.ip);

  String ip;
}

enum Command {
  time("set-time", "time"),
  volume("set-volume", "volume"),
  on("on", "");

  const Command(this.path, this.val);

  final String path;
  final String val;
}

class Api {
  static bool getBool(IP ip, int deviceId) {
    return false;
  }

  static double getDouble(IP ip, int deviceId) {
    return 0;
  }

  static Future<void> post(Command command, IP ip, int deviceId) async {
    Fluttertoast.showToast(
        msg: Uri.http(ip.ip, command.path, {"deviceId": deviceId.toString()})
            .toString());

    try {
      http.Response response = await http.get(
          Uri.http(ip.ip, command.path, {"deviceId": deviceId.toString()}));
      Fluttertoast.showToast(msg: response.body);
    } catch (e) {
      _showDialog(e.toString());
    }
  }

  static Future<void> postBool(
      Command command, IP ip, int deviceId, bool val) async {
    Fluttertoast.showToast(
        msg: Uri.http(ip.ip, command.path, {
      "deviceId": deviceId.toString(),
      command.val: val.toString()
    }).toString());

    try {
      http.Response response = await http.get(Uri.http(ip.ip, command.path,
          {"deviceId": deviceId.toString(), command.val: val.toString()}));
      Fluttertoast.showToast(msg: response.body);
    } catch (e) {
      _showDialog(e.toString());
    }
  }

  static Future<void> postInt(
      Command command, IP ip, int deviceId, int val) async {
    Fluttertoast.showToast(
        msg: Uri.http(ip.ip, command.path, {
      "deviceId": deviceId.toString(),
      command.val: val.toString()
    }).toString());

    try {
      http.Response response = await http.get(Uri.http(ip.ip, command.path,
          {"deviceId": deviceId.toString(), command.val: val.toString()}));
      Fluttertoast.showToast(msg: response.body);
    } catch (e) {
      _showDialog(e.toString());
    }
  }

  static void _showDialog(String text) {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => Center(
              child: Material(
                color: Colors.transparent,
                child: Text(text),
              ),
            ));
  }
}
