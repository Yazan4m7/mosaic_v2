import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mosaic/business/Constants.dart';
import 'package:mosaic/business/Logger.dart';
import 'package:mosaic/doctor/doctor.dart';

class DoctorsController {
  static List<int> doctorsIdsListFromCasesController;
  static HashMap<String, Doctor> doctors = HashMap<String, Doctor>();
  static String root = Constants.ROOT;
  static setIdsList(List<int> list) {
    doctorsIdsListFromCasesController = list;
  }

  static fetchDoctors() async {
    var map = Map<String, dynamic>();
    map['action'] = "GET";
    //String requiredDoctorsString = "($requiredDoctorsIds)";
    String requiredDoctorsString = doctorsIdsListFromCasesController
        .toString()
        .replaceAll(RegExp('[|[|]|]'), '');
    map['query'] =
        "SELECT * from doctors WHERE id in ($requiredDoctorsString) ORDER BY id DESC";
    print(map['query']);
    final response = await http.post(root, body: map);



    var parsed = json.decode(response.body);
    for (int i = 0; i < parsed.length; i++) {
      Doctor doctor = Doctor.fromJson(parsed[i]);
      doctors[doctor.id] = doctor;
    }
    Logger.log("doctors map full ${doctors.length}");
  }

  static fetchAllDoctors() async {
    var map = Map<String, dynamic>();
    map['action'] = "GET";
    map['query'] = "SELECT * from doctors ORDER BY id DESC";
    print(map['query']);
    final response = await http.post(root, body: map);
    print(response.body);
    var parsed = json.decode(response.body);
    for (int i = 0; i < parsed.length; i++) {
      Doctor doctor = Doctor.fromJson(parsed[i]);
      doctors[doctor.id] = doctor;
    }
    Logger.log("full doctors map size ${doctors.length}");
  }

  static Doctor getDoctorById(int id) {

    return doctors[id.toString()];
  }
  static String getDoctorIdByName(String name) {
    return doctors.values.firstWhere((element) => element.name==name).id;
  }

  static List<String> getDoctorsNamesAsList() {
    List<String> list = List();
    doctors.forEach((key, value) {
      list.add(value.name);
    });
    return list;
  }
}
