import 'package:mosaic/models/Case.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class GeneralServices {





  static getDataFromSharedPreferences(String key) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key).toString();
  }


  static List<Case> parseResponse(String responseBody) {
    var parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    parsed = parsed.map<Case>((json) => Case.fromJson(json)).toList();
    return parsed;
  }
}