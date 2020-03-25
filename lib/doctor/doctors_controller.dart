import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mosaic/business/Constants.dart';
import 'package:mosaic/business/Logger.dart';
import 'package:mosaic/doctor/doctor.dart';

class DoctorsController {

  static List<int> doctorsIdsListFromCasesController ;
  static HashMap<String,Doctor> doctors = HashMap<String,Doctor>();
  static String root = Constants.ROOT;
  static setIdsList(List<int> list){
    doctorsIdsListFromCasesController = list;
  }

  static fetchDoctors() async {
    var map = Map<String, dynamic>();
    map['action'] = "GET";
    //String requiredDoctorsString = "($requiredDoctorsIds)";
    String requiredDoctorsString = doctorsIdsListFromCasesController.toString().replaceAll(
        RegExp('[|[|]|]'), '');
    map['query'] = "SELECT * from doctors WHERE id in ($requiredDoctorsString) ORDER BY id DESC";
    print(map['query']);
    final response = await http.post(root, body: map);

    print('get all doctors body: ${response.body}');

    var parsed = json.decode(response.body);
    for (int i = 0; i < parsed.length; i++) {
      Doctor doctor = Doctor.fromJson(parsed[i]);
      doctors[doctor.id]=doctor;
    }
    Logger.log("doctors map full ${doctors.length}");

  }

  static Doctor getDoctorById(int id){
    Logger.log("doctors list lenght ${doctors.length}");
    return doctors[id.toString()];
  }
}