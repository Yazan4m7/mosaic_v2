import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mosaic/Utils/font_style.dart';
import 'package:mosaic/Utils/dataSearch.dart';
import 'package:mosaic/Utils/utils.dart';
import 'package:mosaic/appointment/appointments_controller.dart';
import 'package:mosaic/appointment/appointments_view.dart';
import 'package:mosaic/business/Queries.dart';
import 'package:mosaic/doctor/doctor.dart';
import 'package:mosaic/doctor/doctors_controller.dart';

void main() => runApp(NewCase());

final TextEditingController patientNameFieldController =
TextEditingController();
final TextEditingController notesFieldController =
TextEditingController();

class NewCase extends StatefulWidget {
  final Doctor doctor;
  final VoidCallback refreshLocalList;
  final void Function(String msg) showInSnackBar;
  const NewCase(
      {Key key,
        this.doctor,
        this.refreshLocalList,
        this.showInSnackBar})
      : super(key: key);
  @override
  _NewCaseState createState() => _NewCaseState();
}

class _NewCaseState extends State<NewCase> {
  _NewCaseState();
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
            title: Text('New Case',
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
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.topLeft,
                            child: Text("Doctor name ",
                                style:
                                MyFontStyles.headlinesGreyFontStyle(
                                    context))),
                        SizedBox(height: MediaQuery.of(context).size.height / 90),
                        Container(

                          alignment: Alignment.topLeft,
                          child: Text(widget.doctor==null ? "N/A": widget.doctor.name,
                              style:
                              MyFontStyles.titlesWhiteFontStyle(context)),
                        ),
                        // SizedBox(width: screenAwareSize(10, context)),
//                          SizedBox(
//                            width: screenAwareSize(30, context),
//                          ),
                        SizedBox(height: MediaQuery.of(context).size.height / 30),
                        Container(
                            alignment: Alignment.topLeft,
                            child: Text("Patient name",
                                style: MyFontStyles.headlinesGreyFontStyle(
                                    context))),
                        SizedBox(height: MediaQuery.of(context).size.height / 90),
                        Container(
                          child: Flexible(
                              child: TextField(
                                  controller: patientNameFieldController,
                                  style: MyFontStyles.titlesWhiteFontStyle(
                                      context),
                                  decoration: new InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    hintText: 'Enter Patient name',
                                    hintStyle: MyFontStyles
                                        .textFieldsInsideHintsStyle(context),
                                    border: new OutlineInputBorder(),
                                  ))),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 30),
                        Container(
                            alignment: Alignment.topLeft,
                            child: Text("Notes",
                                style: MyFontStyles.headlinesGreyFontStyle(
                                    context))),
                        SizedBox(height: MediaQuery.of(context).size.height / 90),
                        Container(
                          child: Flexible(
                              child: TextField(
                                  controller: notesFieldController,
                                  style: MyFontStyles.titlesWhiteFontStyle(
                                      context),
                                  decoration: new InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    hintText: 'Enter notes',
                                    hintStyle: MyFontStyles
                                        .textFieldsInsideHintsStyle(context),
                                    border: new OutlineInputBorder(),
                                  ))),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 30),
                        Divider(height: 50, color: Colors.white),

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
 String response = await Queries.createCase(widget.doctor, patientNameFieldController.text,notesFieldController.text);
    Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => AppointmentsMainView()));

    response == "success" ?
 widget.showInSnackBar("Case created successfully"):
 widget.showInSnackBar("Case creation failed, restart application");
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
      ),
    );
  }

  void initState() {
    super.initState();
  }
}
