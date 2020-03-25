import 'file:///D:/officalProject%20-%20Copy/mosaic/lib/appointment/appointments_view.dart';
import 'package:flutter/material.dart';
import 'package:mosaic/appointment/appointment_model.dart';
import 'package:mosaic/appointment/preview_appointment.dart';
import 'file:///D:/officalProject%20-%20Copy/mosaic/lib/user/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cases/cases_view.dart';
import 'appointment/calender_view.dart';
import'package:mosaic/appointment/appointments_controller.dart';
import 'package:intl/intl.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs= await SharedPreferences.getInstance();
  prefs.setString(
      "userId",'11');
  prefs.setString(
      "userName", 'yazan');
  prefs.setString("name", 'Yazan Abulaila');
  runApp(MaterialApp(home: new Calender()));
  print("main");
  List<Appointment> appointmentsList = List<Appointment>();
  appointmentsList = await AppointmentsController.getAppointments();
  print(appointmentsList.length);
  Appointment a = appointmentsList.firstWhere((item) => item.time=="3PM - 4PM");
  print(a.toString());
  var now = new DateTime.now();
  var formatter = new DateFormat('EEEE');

  String formattedDate = formatter.format(now);
  print(formattedDate);
  print(appointmentsList.where((item) => item.time=="3PM - 4PM" && item.date=="2020-03-22"));
}