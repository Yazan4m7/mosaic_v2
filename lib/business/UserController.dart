import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mosaic/business/Services.dart';
import 'Logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mosaic/screens/oldcasesUi.dart';

class UserController{

  static const ROOT = 'http://manshore.com/services_actions.php';
  static const _LOGIN = 'LOGIN';

  static Future<bool> logIn(String username,String password,BuildContext context) async{

    var map = Map<String, dynamic>();
    map['action'] = _LOGIN;
    map['username'] = username;
    map['password'] = password;
    final response =await http.post(ROOT, body: map);
    WriteToFile.write(map.toString());

    if (response.body.isNotEmpty){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("user_name",jsonDecode(response.body)[0]['username']);
      prefs.setString("name",jsonDecode(response.body)[0]['name']);
      prefs.setString("permissions_ids",jsonDecode(response.body)[0]['permissions_ids']);

      WriteToFile.write('Prefs set successfuly for ${prefs.get('user_name')}');
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()));
      return true;
    }
    else {
      WriteToFile.write('Login response body is empty');
      //Alert(context: context, title: "Oops", desc: "Invalid username/password").show();
      return false;
    }
  }
}