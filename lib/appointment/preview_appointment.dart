import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mosaic/appointment/appointments_controller.dart';
import 'package:mosaic/business/Queries.dart';
import 'package:mosaic/cases/new_case.dart';
import 'appointment_model.dart';
import 'package:mosaic/Utils/utils.dart';
import 'package:mosaic/doctor/doctor.dart';
import 'package:mosaic/Utils/font_style.dart';
import 'appointments_view.dart';

void main() => runApp(new PreviewAppointment());

class PreviewAppointment extends StatefulWidget {
  final Appointment appointmentItem;
  final Doctor doctor;
  final VoidCallback refreshFromLocalList;
  final Function(String msg) showInSnackBar;
  const PreviewAppointment(
      {Key key,
      this.appointmentItem,
      this.doctor,
      this.refreshFromLocalList,
      this.showInSnackBar})
      : super(key: key);
  @override
  _PreviewAppointmentState createState() =>
      _PreviewAppointmentState(this.refreshFromLocalList);
}

class _PreviewAppointmentState extends State<PreviewAppointment> {
  VoidCallback refreshFromLocalList;
  _PreviewAppointmentState(this.refreshFromLocalList);
  Future jobs;
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOSAIC',
      theme: new ThemeData(
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
      ),
      home: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(58, 66, 86, 1.0),
          Color.fromRGBO(30, 38, 58, 15.0)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Case info',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: screenAwareSize(20, context))),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: screenAwareSize(25.0, context),
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    child: Text("Doctor Name",
                                        style:
                                            MyFontStyles.headlinesGreyFontStyle(
                                                context))),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    alignment: Alignment.topLeft,
                                    child: Text(widget.doctor.name ?? "N/A",
                                        style:
                                            MyFontStyles.titlesWhiteFontStyle(
                                                context))),
                              ],
                            ),
                            // SizedBox(width: screenAwareSize(10, context)),
//                          SizedBox(
//                            width: screenAwareSize(30, context),
//                          ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.topLeft,
                                      child: Text("Date",
                                          style: MyFontStyles
                                              .headlinesGreyFontStyle(
                                                  context))),
                                  Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          widget.doctor == null
                                              ? "NA"
                                              : widget.appointmentItem.date,
                                          style:
                                              MyFontStyles.titlesWhiteFontStyle(
                                                  context)))
                                ],
                              ),
                            )
                          ]),
                      SizedBox(height: screenAwareSize(10, context)),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                                child: Text("Time",
                                    style: MyFontStyles.headlinesGreyFontStyle(
                                        context))),
                            Container(

                                // alignment: Alignment.topRight,
                                child: Text(widget.appointmentItem.time,
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
                      Row(
                        children: <Widget>[
                          Container(
                            child: Flexible(
                                child: Text(
                                    widget.appointmentItem.description ??
                                        'None',
                                    style: MyFontStyles.titlesWhiteFontStyle(
                                        context))),
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
                                  widget.appointmentItem.taken_by == 'N/A'
                                      ? 'Assign to me'
                                      : widget.appointmentItem.status == '0'
                                          ? 'Start'
                                          : 'Finish',
                                  style: MyFontStyles.buttonsFont(context),
                                ),
                                onPressed: () async {
                                  String appointmentId =
                                      widget.appointmentItem.id;
                                  String responseText = "N/A";
                                  if (widget.appointmentItem.taken_by ==
                                      'N/A') {
                                    AppointmentsController
                                        .assignAppointmentInLocalList(
                                            appointmentId);
                                    refreshFromLocalList();
                                    Navigator.of(context).pop();
                                    responseText =
                                        await Queries.assignAppointment(
                                            widget.appointmentItem.id);
                                    responseText == "success"
                                        ? showInSnackBar(
                                            "Appointment assigned successfully")
                                        : showInSnackBar(
                                            "Appointment assigning failed, restart application");
                                  } else if (widget.appointmentItem.status ==
                                      '0') {
                                    AppointmentsController
                                        .startAppointmentInLocalList(
                                            appointmentId);
                                    refreshFromLocalList();
                                    Navigator.of(context).pop();
                                    responseText =
                                        await Queries.startAppointment(
                                            widget.appointmentItem.id);
                                    responseText == "success"
                                        ? showInSnackBar(
                                            "Appointment started successfully")
                                        : showInSnackBar(
                                            "Appointment starting failed, restart application");
                                  } else {
                                    AppointmentsController
                                        .finishAppointmentInLocalList(
                                            appointmentId);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => NewCase(
                                                  doctor: widget.doctor,
                                                  refreshLocalList:
                                                      refreshFromLocalList,
                                                  showInSnackBar:
                                                      showInSnackBar,
                                                )));
                                    responseText =
                                        await Queries.finishAppointment(
                                            widget.appointmentItem.id);
                                    responseText == "success"
                                        ? showInSnackBar(
                                            "Appointment finished successfully")
                                        : showInSnackBar(
                                            "Appointment finishing failed, restart application");
                                  }
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
}
