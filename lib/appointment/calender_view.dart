
import 'package:flutter/rendering.dart';
import 'package:mosaic/Utils/font_style.dart';
import 'package:mosaic/Utils/utils.dart';
import 'package:mosaic/appointment/appointments_controller.dart';
import 'package:mosaic/appointment/new_appintment_view.dart';
import 'package:mosaic/business/Logger.dart';
import 'package:mosaic/appointment/appointment_model.dart';
import 'package:mosaic/doctor/doctor.dart';
import 'package:mosaic/widgets/animator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mosaic/widgets/Widgets.dart';
import 'package:mosaic/doctor/doctors_controller.dart';
import 'package:intl/intl.dart';

import 'camera.dart';

class Calender extends StatefulWidget {
  @override
  _CalenderState createState() => _CalenderState();
}

void main() => runApp(Calender());
Future<List<Camera>> camerasList;
Future<List<Appointment>> appointmentsList;
bool isLoadingBarOnScreen = false;
double camerasDialogHeight = 120;
String calenderPageTitle = 'Calender - Camera: ';
int cameraId = 1;
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
final key = new GlobalKey<_CalenderState>();

class _CalenderState extends State<Calender> {
  @override
  void initState() {
    appointmentsList = AppointmentsController.getAppointments();
    camerasList = AppointmentsController.getCameras().then((List<Camera> list) {
      setState(() {
        calenderPageTitle = calenderPageTitle + list[0].name;
      });
      return list;
    });

    // TODO: implement initState
    super.initState();
  }

  refreshLocalList() async {

    setState(() {
      appointmentsList = AppointmentsController.getLocalList();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
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
          key: _scaffoldKey,
          appBar: AppBar(
            titleSpacing: 0,
            leading: Icon(Icons.calendar_today),
            title: Text(calenderPageTitle),
            elevation: 5,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => cameraChangeDialog(),
                    ).then((_) => setState(() {}));
                  })
            ],
          ),
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          body: FutureBuilder(
            future: appointmentsList,
            builder: (context, appointmentsFutureList) {
              if (appointmentsFutureList.connectionState ==
                      ConnectionState.none ||
                  appointmentsFutureList.data == null) {
                print(
                    'snapshot data is: ${appointmentsFutureList.data} and connecting is ${appointmentsFutureList.connectionState}');
                return Center(child: CircularProgressIndicator());
              }
              List<Appointment> appointmentsList = appointmentsFutureList.data;
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(), // new
                shrinkWrap: true,
                itemCount: 7,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  DateTime date = DateTime.now().add(Duration(days: index));
                  String dateString = DateFormat('yyyy-MM-dd').format(date);
                  return appointmentsOfSingleDayCopied(dateString,
                      DateFormat('EEEE').format(date), appointmentsList);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget appointmentsOfSingleDayCopied(
      String date, String dayName, List<Appointment> appointmentsList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: WidgetANimator(
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Text(date + "   " + dayName,
              style: MyFontStyles.titlesWhiteFontStyle(context)),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: screenAwareSize(50, context),
                width: MediaQuery.of(context).size.width - 20,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    // new
                    shrinkWrap: true,
                    itemCount: times9to2.length,
                    itemBuilder: (BuildContext context, int index) {
                      Color backgroundColor = Colors.green;
                      if (appointmentsList
                          .where((item) =>
                              item.camera_id == cameraId.toString() &&
                              item.time == times9to2[index] &&
                              item.date == date)
                          .isNotEmpty) {
                        backgroundColor = Colors.red;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 2),
                        child: InkWell(
                          child: Container(
                              width: MediaQuery.of(context).size.width / 5 - 6,
                              child: Center(
                                child: Text(times9to2[index].substring(0, 4),
                                    style: TextStyle(
                                        fontSize: 18,
                                        backgroundColor: Colors.transparent,
                                        color: Colors.white)),
                              ),
                              decoration: new BoxDecoration(
                                color: backgroundColor,
                                border: new Border.all(
                                    color: Colors.white,
                                    width: 3.0,
                                    style: BorderStyle.solid),
                                borderRadius: new BorderRadius.circular(0.0),
                              )),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NewAppointment(
                                      time: times9to2[index],
                                      date: date,
                                      cameraId: cameraId.toString(),
                                      refreshLocalList: refreshLocalList,
                                      showInSnackBar: showInSnackBar,
                                    )));
                          },
                        ),
                      );
                    }),
              ),
            ],
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: screenAwareSize(50, context),
                width: MediaQuery.of(context).size.width - 20,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    //physics: const NeverScrollableScrollPhysics(),
                    // new
                    shrinkWrap: true,
                    itemCount: times2to7.length,
                    itemBuilder: (BuildContext context, int index) {
                      Color backgroundColor = Colors.green;
                      if (appointmentsList
                          .where((item) =>
                              item.time == times2to7[index] &&
                              item.date == date)
                          .isNotEmpty) {
                        backgroundColor = Colors.red;
                        print("changing colors");
                      }
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1, vertical: 2),
                          child: InkWell(
                            child: Container(
                                width:
                                    MediaQuery.of(context).size.width / 5 - 6,
                                child: Center(
                                  child: Text(times2to7[index].substring(0, 4),
                                      style: TextStyle(
                                          fontSize: 18,
                                          backgroundColor: Colors.transparent,
                                          color: Colors.white)),
                                ),
                                decoration: new BoxDecoration(
                                  color: backgroundColor,
                                  border: new Border.all(
                                      color: Colors.white,
                                      width: 3.0,
                                      style: BorderStyle.solid),
                                  borderRadius: new BorderRadius.circular(0.0),
                                )),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NewAppointment(
                                        time: times2to7[index],
                                        date: date,
                                        cameraId: cameraId.toString(),
                                        refreshLocalList: refreshLocalList,
                                        showInSnackBar: showInSnackBar,
                                      )));
                            },
                          ));
                    }),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  void changeCamera(Camera cam) {
    print('camera ${cam.name} pressed');
  }

  List<Camera> cameras = <Camera>[
    Camera(id: '1', name: "first"),
    Camera(id: '2', name: "second"),
    Camera(id: '3', name: "third"),
    Camera(id: '4', name: "fourth"),
  ];

  cameraChangeDialog() {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text("Choose Camera"),
        actions: <Widget>[
          Container(
              width: double.maxFinite,
              height: camerasDialogHeight,
              child: FutureBuilder(
                  future: camerasList,
                  builder: (context, camerasList) {
                    if (camerasList.connectionState == ConnectionState.none ||
                        camerasList.data == null) {
                      print(
                          'camerasList data is: ${camerasList.data} and connecting is ${camerasList.connectionState}');
                      return Container();
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        camerasDialogHeight =
                            camerasList.data.length * 50.toDouble();
                      });
                    });

                    return AnimatedList(
                        scrollDirection: Axis.vertical,
                        initialItemCount: camerasList.data.length,
                        itemBuilder: (context, index, animation) {
                          Camera cam = camerasList.data[index];
                          return RaisedButton(
                            child: Text(cam.name),
                            onPressed: () {
                              calenderPageTitle =
                                  'Calender - Camera: ' + cam.name;

                              setState(() {
                                cameraId = int.parse(cam.id);
                              });
                              Navigator.of(context).pop();
                            },
                          );
                        });
                  })),
        ],
      );
    });
  }
}
