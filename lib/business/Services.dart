
import 'package:http/http.dart' as http;
import 'file:///D:/officalProject%20-%20Copy/mosaic/lib/cases/case_model.dart';
import 'file:///D:/officalProject%20-%20Copy/mosaic/lib/user/Permission.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class Services {



  static SharedPreferences prefs;

  static String getDataFromSharedPreferences(String key) {
    if(prefs==null){ initialize() ;}
    print ("Data from prefs : ${prefs.getString(key)}");
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


  static Future<List<Case>> do2() async {
    const ROOT = 'http://10.0.2.2/flutter_api.php';
    var map = Map<String, dynamic>();
    map['action'] = "GET";
    map['query'] =
    "SELECT * from orders WHERE current_status in (1,2,3) ORDER BY id DESC";
    print(map['query']);

    final response = await http.post(ROOT, body: map);

    print('get all response body: ${response.body}');
    List<dynamic> list= List<dynamic>();
    var parsed = json.decode(response.body);
    print("parsed map ${parsed[1].runtimeType}");
    for(int i=0;i<parsed.length;i++){
      Case caseItem =Case.fromJson(parsed[i]);
      print ('parsed $caseItem');
      list.add(caseItem);
      print ('case added');
    }
    //parsed = parsed.map<Case>((json) => Case.jsonToCase(json)).toList();
    print("returning list $list");
    return parsed;
    //List<Case> list = GeneralServices.parseCasesResponse(response.body);
    //print();
    //return list;
  }
  static List<Case> parseCasesResponse(String responseBody) {
    do2();
//    List<dynamic> list=List<dynamic>();
//    var parsed = json.decode(responseBody);
//    print("parsed map ${parsed[1].runtimeType}");
//    for(int i=0;i<parsed.length;i++){
//      Case caseItem =Case.fromJson(parsed[i]);
//      print ('parsed $caseItem');
//      list.add(caseItem);
//      print ('case added');
//    }
//    //parsed = parsed.map<Case>((json) => Case.jsonToCase(json)).toList();
//    print("returning list $list");
//    return list;
  }
  static List<Permission> parsePermissionsResponse(String responseBody) {

    var parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    parsed = parsed.map<Permission>((json) => Permission.fromJson(json)).toList();

    return parsed;
  }
}