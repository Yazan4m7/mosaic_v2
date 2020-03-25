import 'dart:collection';
import 'package:flutter/rendering.dart';
import 'package:mosaic/Utils/Custom_Font_Style.dart';
import 'package:mosaic/Utils/utils.dart';
import 'package:mosaic/appointment/appointments_controller.dart';
import 'package:mosaic/business/Logger.dart';
import 'package:mosaic/appointment/appointment_model.dart';
import 'package:mosaic/doctor/doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mosaic/widgets/Widgets.dart';
import 'package:mosaic/doctor/doctors_controller.dart';
import 'package:intl/intl.dart';

class Calender extends StatefulWidget {
  @override
  _CalenderState createState() => _CalenderState();
}

Future<List<Appointment>> appointmentsList;
List<String> times9to2 = [
  "9AM - 10AM",
  "10AM - 11AM",
  "11AM - 12PM",
  "12PM - 1PM",
  "1PM - 2PM"
];
List<String> times2to7 = [
  "2PM - 3PM",
  "3PM - 4PM",
  "4PM - 5PM",
  "5PM - 6PM",
  "6PM - 7PM"
];

class _CalenderState extends State<Calender> {
  @override
  void initState() {
    appointmentsList = AppointmentsController.getAppointments();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MOSAIC',
        theme: new ThemeData(
          primaryColor: Color.fromRGBO(58, 66, 86, 1.0)
          ,
        ),
        home: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(58, 66, 86, 1.0),
              Color.fromRGBO(30, 38, 58, 15.0)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Scaffold(
                backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
                body: new ListView.builder(
                    shrinkWrap: true,
                    itemCount: 7,
                    itemBuilder: (BuildContext context, int index) {
                      String date = DateFormat('yyyy-MM-dd')
                          .format(DateTime.now().add(Duration(days: index)));
                      return appointmentsOfSingleDayCopied(date);
                    }))));
  }

  Widget appointmentsOfSingleDayCopied(String date) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[Text("Date : $date",style: CustomTextStyle.previewCaseSmallFont(context)),
      Container(
        width: screenAwareSize(300, context),
        // height: screenAwareSize(80, context),
        child: FutureBuilder(
          future: appointmentsList,
          builder: (context, appointmentsFuturelist) {
            if (appointmentsFuturelist.connectionState ==
                ConnectionState.none ||
                appointmentsFuturelist.data == null) {
              print(
                  'snapshot data is: ${appointmentsFuturelist.data} and connecting is ${appointmentsFuturelist.connectionState}');
              return CircularProgressIndicator();
            }
            print(
                "cases list length${appointmentsFuturelist.data.length}");
            List<Appointment> appointmentslist =
                appointmentsFuturelist.data;
            return ListView(children: <Widget>[],

            );
          },
        ),
      ),],

    );
  }
}
