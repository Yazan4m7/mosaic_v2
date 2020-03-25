import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mosaic/business/Services.dart';
import 'file:///D:/officalProject%20-%20Copy/mosaic/lib/user/Permission.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../business/Logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mosaic/cases/cases_view.dart';

class UserController {
  static const ROOT = 'http://10.0.2.2/flutter_api.php';
  static String name="N/A";
  static Future<bool> logIn(
      String username, String password, BuildContext context) async {
    print("logging in");
    var map = Map<String, dynamic>();
    map['action'] = 'GET';
    map['query'] = "SELECT * FROM users WHERE username='$username' ";
    //AND password ='$password'

    final getUserResponse = await http.post(ROOT, body: map);

    Logger.log("Get user response : ${map.length.toString()}");

    if (getUserResponse.body.isNotEmpty) {
      print(getUserResponse.body);
      map['query'] =
          "SELECT permission_id FROM user_permissions WHERE user_id='${jsonDecode(getUserResponse.body)[0]['id']}'";
      print(map['query']);
      final getPermissionsResponse = await http.post(ROOT, body: map);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString(
          "user_id", jsonDecode(getUserResponse.body)[0]['id']);
      prefs.setString(
          "user_name", jsonDecode(getUserResponse.body)[0]['username']);
      prefs.setString("name", jsonDecode(getUserResponse.body)[0]['name']);
      name = jsonDecode(getUserResponse.body)[0]['name'];

      List<Permission> list =
          Services.parsePermissionsResponse(getPermissionsResponse.body);

      prefs.setString("permissionsIds", list.toString());

      Logger.log(
          'Prefs set successfuly for ${prefs.get('user_name')} perms are ${list.toString()}');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CasesMainView()));
      return true;
    } else {
      Logger.log('Login response body is empty');
      Alert(context: context, title: "Oops", desc: "Invalid username/password")
          .show();
      return false;
    }
  }
}
