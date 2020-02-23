import 'package:flutter/material.dart';
import 'package:mosaic/models/Case.dart';

class CaseRow extends StatelessWidget {
  final Case caseItem;
  final double dotSize = 12.0;
  final Animation<double> animation;

  const CaseRow({Key key, this.caseItem, this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new FadeTransition(
      opacity: animation,
      child: new SizeTransition(
        sizeFactor: animation,
        child: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: new Row(
            children: <Widget>[
              new Padding(
                padding:
                    new EdgeInsets.symmetric(horizontal: 32.0 - dotSize / 2),
                child: new Container(
                  height: dotSize,
                  width: dotSize,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle, color: Colors.red),
                ),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      caseItem.doctor_id.toString(),
                      style: new TextStyle(fontSize: 18.0),
                    ),
                    new Text(
                      caseItem.patient_name,
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                    )
                  ],
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: new Text(
                  caseItem.deliver_date.toString(),
                  style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
