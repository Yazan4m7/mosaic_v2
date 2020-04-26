import 'dart:convert';
import 'package:mosaic/doctor/doctors_controller.dart';

import '../business/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../business/Logger.dart';
import 'package:mosaic/cases/case_model.dart';
import 'package:http/http.dart' as http;



class CasesController {

  static const ROOT = Constants.ROOT;
  static List<int> requiredDoctorsIds= List<int>();
  static List<Case> LocalCaseslist= List<Case>();
  static Future<List<Case>> getCases() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var map = Map<String, dynamic>();
    map['action'] = "GET";
    map['query'] =
    "SELECT * from orders WHERE current_status in (0,1,3,4,5) ORDER BY id DESC";
    print(map['query']);
    final response = await http.post(ROOT, body: map);


    LocalCaseslist.clear();
    var parsed = json.decode(response.body);
    for(int i=0;i<parsed.length;i++){
      Case caseItem =Case.fromJson(parsed[i]);
      LocalCaseslist.add(caseItem);
      requiredDoctorsIds.add(int.parse(caseItem.doctorId));
    }
    DoctorsController.setIdsList(requiredDoctorsIds);
    await DoctorsController.fetchDoctors();

    return LocalCaseslist;
  }
  static  void removeFromLocalList(String id) async {
    LocalCaseslist.removeWhere((element) => element.id == id);
  }
  static  void startCaseInLocalList(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LocalCaseslist.firstWhere((element) => element.id == id).madeBy=prefs.getString('userId');
  }
  static  void finishCaseInLocalList(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Case caseItem = LocalCaseslist.firstWhere((element) => element.id == id);
    caseItem.madeBy=null;
    caseItem.currentStatus =(int.parse(caseItem.currentStatus)+1).toString();
  }
  static  Future<List<Case>> getLocalList() async{
    return LocalCaseslist;
}


  static void checkVersion() async {
    String query = "SELECT version from constants";
    Logger.log("query is : $query");

    // setting up and sending the request
    var map = Map<String, dynamic>();
    map['query'] = query;
    map ['action'] = "CHECK_VERSION";
    final response = await http.post(ROOT, body: map);

    // get the version number out of json response
    var latestVersion = int.parse(json.decode(response.body)[0]['version']);
    Logger.log("latest version is $latestVersion");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.get('currentVersion') != null)
      if (prefs.get('currentVersion') < latestVersion) {
        initiateApplicationUpdate();
        prefs.setInt('CurrentVersion', latestVersion);
        Logger.log("Updated App to $latestVersion");
      }
      else {
        prefs.setInt('CurrentVersion', 1);
        Logger.log("Current version set to 1");
      }
  }

  static void initiateApplicationUpdate() {

  }

  static casesGetter() async {
    return CasesController.getCases();
  }


}