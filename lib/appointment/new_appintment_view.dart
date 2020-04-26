import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mosaic/Utils/font_style.dart';
import 'package:mosaic/Utils/dataSearch.dart';
import 'package:mosaic/Utils/utils.dart';
import 'package:mosaic/appointment/appointments_controller.dart';
import 'package:mosaic/business/Queries.dart';
import 'package:mosaic/doctor/doctor.dart';
import 'package:mosaic/doctor/doctors_controller.dart';

import 'appointment_model.dart';
import 'appointments_view.dart';

final TextEditingController doctorNameController = TextEditingController();
final TextEditingController descriptionFieldController =
    TextEditingController();

class NewAppointment extends StatefulWidget {
  final String time;
  final String date;
  final String cameraId;
  final VoidCallback refreshLocalList;
  final void Function(String msg) showInSnackBar;
  const NewAppointment(
      {Key key,
      this.time,
      this.date,
      this.cameraId,
      this.refreshLocalList,
      this.showInSnackBar})
      : super(key: key);
  @override
  _NewAppointmentState createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {
  Doctor doctor = Doctor();
  _NewAppointmentState();
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOSAIC',
      home: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(58, 66, 86, 1.0),
          Color.fromRGBO(30, 38, 58, 15.0)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Scaffold(
          appBar: AppBar(
            title: Text('New Appointment',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 25.0,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.topLeft,
                                  child: Text("Doctor name ",
                                      style:
                                          MyFontStyles.headlinesGreyFontStyle(
                                              context))),
                              Container(
                                alignment: Alignment.topLeft,
                                // gesture detector instead of icon button because it has padding
                                child: GestureDetector(
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                  onTap: () {
                                    showSearch(
                                        context: context,
                                        delegate:
                                            DataSearch(doctorNameController));
                                  },
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            alignment: Alignment.topLeft,
                            child: Text(doctorNameController.text,
                                style:
                                    MyFontStyles.titlesWhiteFontStyle(context)),
                          )
                        ],
                      ),
                      // SizedBox(width: screenAwareSize(10, context)),
//                          SizedBox(
//                            width: screenAwareSize(30, context),
//                          ),
                      SizedBox(height: MediaQuery.of(context).size.height / 30),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                alignment: Alignment.topLeft,
                                child: Text("Date",
                                    style: MyFontStyles.headlinesGreyFontStyle(
                                        context))),
                            Container(
                                alignment: Alignment.topLeft,
                                child: Text(widget.date ?? "N/A",
                                    style: MyFontStyles.titlesWhiteFontStyle(
                                        context)))
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 30),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                                child: Text("Time",
                                    style: MyFontStyles.headlinesGreyFontStyle(
                                        context))),
                            Container(

                                // alignment: Alignment.topRight,
                                child: Text(widget.time ?? "N/A",
                                    style: MyFontStyles.titlesWhiteFontStyle(
                                        context)))
                          ]),
                      Divider(height: 50, color: Colors.white),
                      Row(
                        children: <Widget>[
                          Container(
                              child: Text("Description",
                                  style: MyFontStyles.headlinesGreyFontStyle(
                                      context))),
                        ],
                      ),
                      SizedBox(
                        height: screenAwareSize(5, context),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: Flexible(
                                child: TextField(
                                    controller: descriptionFieldController,
                                    style: MyFontStyles.titlesWhiteFontStyle(
                                        context),
                                    decoration: new InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey, width: 2.0),
                                      ),
                                      hintText: 'Enter Description',
                                      hintStyle: MyFontStyles
                                          .textFieldsInsideHintsStyle(context),
                                      border: new OutlineInputBorder(),
                                    ))),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          ButtonTheme(
                            minWidth: 200.0,
                            height: 40.0,
                            child: RaisedButton(
                                textColor: Color.fromRGBO(58, 66, 86, 1.0),
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white)),
                                child: Text(
                                  "Submit",
                                ),
                                onPressed: () async {
                                  //
                                  Appointment newAppointmet = Appointment(
                                      doctor_id:
                                          DoctorsController.getDoctorIdByName(
                                              doctorNameController.text),
                                      date: widget.date,
                                      time: widget.time,
                                      description:
                                          descriptionFieldController.text,
                                      camera_id: widget.cameraId);
                                  AppointmentsController.addToLocalList(
                                      newAppointmet);

                                  Navigator.of(context).pop();
                                  widget.refreshLocalList();
                                  String response = await Queries.createAppointment(
                                      doctorNameController.text,
                                      widget.date,
                                      widget.time,
                                      descriptionFieldController.text,
                                      widget.cameraId);
                                  response == "success" ?
                                  widget.showInSnackBar("Appointment created successfully"):
                                  widget.showInSnackBar("Appointment creation failed, restart application");
                                }),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void initState() {
    super.initState();
  }
}
