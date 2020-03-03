import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'Logger.dart';
import 'package:mosaic/models/Case.dart';
import 'package:http/http.dart' as http;
import 'Services.dart';


class CasesController {
  static const ROOT = 'http://manshore.com/services_actions.php';
  static const _GET_ALL_ACTION = 'GET_ALL';


  static Future<List<Case>> getCases() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String permissions = "(" + prefs.get('permissions_ids') + ")";
    var map = Map<String, dynamic>();
    map['action'] = _GET_ALL_ACTION;
    map['query'] = "SELECT * from tasks WHERE current_status in $permissions ORDER BY id DESC";
    final response = await http.post(ROOT, body: map);
    WriteToFile.write('get all response body: ${response.body}');

    List<Case> list = GeneralServices.parseResponse(response.body);

    return list;
  }

  static updateToActive(int caseID, String currentStatus, String stage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phaseBeingDone;
    switch (int.parse(currentStatus)) {
      case 0:
        phaseBeingDone = "design";
        break;
      case 1:
        phaseBeingDone = "milled";
        break;
      case 2:
        phaseBeingDone = "sintered";
        break;
      case 3:
        phaseBeingDone = "finished";
        break;
      case 4:
        phaseBeingDone = "approved";
        break;
      case 5:
        phaseBeingDone = "delivered";
        break;
    }

    String query = "UPDATE tasks SET ${phaseBeingDone}_by = '${prefs.get(
        'name')}' , stage='active' WHERE id = $caseID";
    WriteToFile.write("query is : $query");


    var map = Map<String, dynamic>();
    map['query'] = query;
    map ['action'] = "UPDATE_task_to_active";
    final response = await http.post(ROOT, body: map);
    WriteToFile.write('Assign task reponse body: ${response.body}');
  }

  static updateToDone(int caseID, String currentStatus) async {
    String query = "UPDATE tasks SET current_status ='${int.parse(
        currentStatus) + 1}' , stage='waiting' WHERE id = $caseID";
    WriteToFile.write("query is : $query");

    var map = Map<String, dynamic>();
    map['query'] = query;
    map ['action'] = "UPDATE_task_to_done";
    final response = await http.post(ROOT, body: map);
    WriteToFile.write('Assign task to done reponse body: ${response.body}');
  }

  void createCase(String doctorName, String patientName) {


  }

  static void checkVersion() async {
    String query = "SELECT version from constants";
    WriteToFile.write("query is : $query");

    // setting up and sending the request
    var map = Map<String, dynamic>();
    map['query'] = query;
    map ['action'] = "CHECK_VERSION";
    final response = await http.post(ROOT, body: map);

    // get the version number out of json response
    var latestVersion = int.parse(json.decode(response.body)[0]['version']);
    WriteToFile.write("latest version is $latestVersion");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.get('currentVersion') != null)
      if (prefs.get('currentVersion') < latestVersion) {
        initiateApplicationUpdate();
        prefs.setInt('CurrentVersion', latestVersion);
        WriteToFile.write("Updated App to $latestVersion");
      }
      else {
        prefs.setInt('CurrentVersion', 1);
        WriteToFile.write("Current version set to 1");
      }
  }

  static void initiateApplicationUpdate() {

  }

  static void updateCaseStatue(Case caseItem){
      print("code to update case status goes here");
  }

  static casesGetter() async {
    return CasesController.getCases();
  }
}