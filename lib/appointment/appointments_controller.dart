import 'dart:convert';
import 'appointment_model.dart';
import 'package:mosaic/appointment/appointment_model.dart';
import '../business/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mosaic/cases/Case.dart';
import 'package:http/http.dart' as http;

import '../doctor/doctors_controller.dart';

class AppointmentsController {
  static const ROOT = Constants.ROOT;
  static List<Appointment> appointments = List<Appointment>();
  static List<Appointment> localAppointmentList = List<Appointment>();
  static List<int> requiredDoctorsIds = List<int>();


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

  static Future<List<Case>> removeFromLocalList(String id) async {
    localAppointmentList.removeWhere((element) => element.id == id);
  }

  static Future<List<Appointment>> getLocalList() async {
    return localAppointmentList;
  }

  static addAppointment() async {
    return AppointmentsController.getAppointments();
  }


}
