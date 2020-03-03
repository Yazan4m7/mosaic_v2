import 'package:flutter/material.dart';
import 'package:mosaic/models/Case.dart';

class PreviewCase extends StatefulWidget {
  final Case caseItem;
  const PreviewCase({Key key, this.caseItem}) : super(key: key);
  @override
  _PreviewCaseState createState() => _PreviewCaseState();
}

class _PreviewCaseState extends State<PreviewCase> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MOSAIC',
        theme: new ThemeData(
            primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
            fontFamily: 'Raleway'),
        home: Scaffold(
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          body: Column(
            children: <Widget>[
              Text(widget.caseItem.patient_name),
              Text(widget.caseItem.doctor_id.toString()),

            ],
          ),
        ));
  }
}
