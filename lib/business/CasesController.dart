

import 'package:shared_preferences/shared_preferences.dart';
import 'Logger.dart';
import 'package:mosaic/models/Case.dart';
import 'package:http/http.dart' as http;
import 'GeneralServices.dart';
import 'dart:convert';

class CasesController{
  static const ROOT = 'http://manshore.com/services_actions.php';
  static const _GET_ALL_ACTION = 'GET_ALL';


  static Future<List<Case>> getCases() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String permissions = "(" + prefs.get('permissions_ids') +")";
    var map = Map<String, dynamic>();
    map['action'] = _GET_ALL_ACTION;
    map['query'] = "SELECT * from tasks ORDER BY id DESC";
    //WHERE current_status in $permissions
    final response = await http.post(ROOT, body: map);
    WriteToFile.write('get all response body: ${response.body}');

    List<Case> list = GeneralServices.parseResponse(response.body);

    return list;
  }


}