import 'package:mosaic/models/Case.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class GeneralServices {



  static SharedPreferences prefs;

  static getDataFromSharedPreferences(String key) async{
    if(prefs==null){ prefs = initialize() ;}
    return prefs.getString(key).toString();
  }
  static setDataToSharedPreferences(String key,String value) async{
    if(prefs==null){initialize() ;}
   prefs.setString(key, value);
  }
  static initialize() async{
     prefs = await SharedPreferences.getInstance();}

  static Future<SharedPreferences> getSharedPreferencesInstance() async{
    if (prefs==null) await initialize();
  return prefs;
  }

  static List<Case> parseResponse(String responseBody) {
    var parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    parsed = parsed.map<Case>((json) => Case.fromJson(json)).toList();
    return parsed;
  }
}