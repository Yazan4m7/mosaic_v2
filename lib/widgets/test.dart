import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mosaic/doctor/doctor.dart';
import 'package:mosaic/doctor/doctors_controller.dart';

void main()async {
  await DoctorsController.fetchAllDoctors();
  HashMap<String,Doctor> doctors  = DoctorsController.doctors;
  List<Doctor> list = List();
  //doctors.forEach((k, v) => list.add(k,v));
  list.addAll(doctors.values);
  print(list.length);
}

class stless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        height: 300,
        width: 300,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        //physics: const NeverScrollableScrollPhysics(), // new
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              child: Text(
                            'm',
                          ));
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
