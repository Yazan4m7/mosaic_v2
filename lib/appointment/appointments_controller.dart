import 'dart:convert';
import 'package:mosaic/appointment/calender_view.dart';
import 'package:mosaic/business/Logger.dart';

import 'appointment_model.dart';
import 'package:mosaic/appointment/appointment_model.dart';
import '../business/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mosaic/cases/case_model.dart';
import 'package:http/http.dart' as http;
import 'calender_view.dart';
import '../doctor/doctors_controller.dart';
import 'camera.dart';

class AppointmentsController {
  static const ROOT = Constants.ROOT;

  static List<Appointment> localAppointmentList = List<Appointment>();
  static List<int> requiredDoctorsIds = List<int>();
  static List<Camera> localCamerasList = List<Camera>();
  static String firstCameraName="N/A";
  static Future<List<Appointment>> getAppointments() async {
    var map = Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");
    map['action'] = "GET";
    map['query'] = "SELECT id,description,DATE_FORMAT(date, '%W')"
        "as day,date, time,doctor_id,camera_id,created_by,taken_by,status FROM `appointments` "
        "WHERE taken_by is NULL OR taken_by=$userId ORDER BY date, STR_TO_DATE(time, '%l%p')";

    final response = await http.post(ROOT, body: map);
    //print(response.body);
    // refreshing will add new cases to old cases at launch
    localAppointmentList.clear();
    var parsed = json.decode(response.body);
    for (int i = 0; i < parsed.length; i++) {
      Appointment appointmentItem = Appointment.fromJson(parsed[i]);
      localAppointmentList.add(appointmentItem);
      requiredDoctorsIds.add(int.parse(appointmentItem.doctor_id));
    }
    DoctorsController.setIdsList(requiredDoctorsIds);
    await DoctorsController.fetchDoctors();
    print("returning appoinments list ${localAppointmentList.length}");
    return localAppointmentList;
  }

  static  removeFromLocalList(String id) async {
    localAppointmentList.removeWhere((element) => element.id == id);
  }

  static Future<List<Appointment>> getLocalList() async {
    return localAppointmentList;
  }

  static Future<List<Camera>> getCameras() async {
    var map = Map<String, dynamic>();
    map['action'] = "GET";
    map['query'] = "SELECT id,name FROM `cameras` ";

    final response = await http.post(ROOT, body: map);
    // refreshing will add new cases to old cases at launch
    localCamerasList.clear();
    var parsed = json.decode(response.body);
    firstCameraName = Camera.fromJson(parsed[0]).name;

    for (int i = 0; i < parsed.length; i++) {

      Camera cameraItem = Camera.fromJson(parsed[i]);
      localCamerasList.add(cameraItem);
    }
    return localCamerasList;
  }

  static  startAppointmentInLocalList(String id) async {
    Appointment appItem = localAppointmentList.firstWhere((element) => element.id == id);
    appItem.status=1.toString();
  }
  static  assignAppointmentInLocalList(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Appointment appItem = localAppointmentList.firstWhere((element) => element.id == id);
    appItem.taken_by=prefs.getString('userId');
  }
  static  finishAppointmentInLocalList(String id) async {
    Appointment appItem = localAppointmentList.firstWhere((element) => element.id == id);
    appItem.status=2.toString();
  }


  static  addToLocalList(Appointment newAppointment) async {
    localAppointmentList.add(newAppointment);
  }
}
