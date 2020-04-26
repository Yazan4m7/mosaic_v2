import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mosaic/Utils/themes_constans.dart';
import 'package:mosaic/appointment/appointment_model.dart';
import 'package:mosaic/Utils/utils.dart';
import 'package:mosaic/business/Logger.dart';
import 'package:mosaic/business/Services.dart';
import 'package:mosaic/appointment/preview_appointment.dart';
import 'package:mosaic/cases/case_model.dart';
import 'package:mosaic/doctor/doctor.dart';
import 'package:mosaic/cases/preview_case.dart';
import 'package:mosaic/widgets/animator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Widgets{
  static String drawerTitle = "Nothing is here yet :)";

  static setUsername()async {
    SharedPreferences prefs = await Services.getSharedPreferencesInstance();
    if (prefs.get('name')!=null)
      drawerTitle = prefs.get('name');
  }

 static Drawer mosaicDrawer() {
   setUsername();
   return Drawer(

     child:new ListView(
       children: <Widget>[
         Container(
           height: 150.0,
           child: DrawerHeader(
             child: Padding(
               padding: const EdgeInsets.fromLTRB(0,60,0.0,0),
               child: Text(drawerTitle, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.white)),
             ),
             decoration: BoxDecoration(
                 color: Colors.black87
             ),

           ),
         ),

         new ListTile(
             title: Text("Logs"),
             trailing: Icon(Icons.folder),
             onTap:(){ Logger.openLogs();}
         )
       ],
     ),
   );
}

 static Container mainViewBottomBar(){return Container(
   height: 55.0,

   child: BottomAppBar(
     color: Color.fromRGBO(58, 66, 86, 1.0),
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: <Widget>[
         IconButton(
           icon: Icon(Icons.home, color: Colors.white),
           onPressed: () {},
         ),
         IconButton(
           icon: Icon(Icons.blur_on, color: Colors.white),
           onPressed: () {},
         ),
         IconButton(
           icon: Icon(Icons.hotel, color: Colors.white),
           onPressed: () {},
         ),
         IconButton(
           icon: Icon(Icons.account_box, color: Colors.white),
           onPressed: () {},
         )
       ],
     ),
   ));}

 static ListTile makeCaseListTile(Case caseItem,Doctor doctor,BuildContext context, VoidCallback refreshLocalList,Function(String msg) showInSnackBar){
   String phase='';


     switch(caseItem.currentStatus){
       case '0' : phase = 'Desgin'; break;
       case '1' : phase = 'Milling'; break;
       case '2' : phase = 'Furnace/ Sintering'; break;
       case '3' : phase = 'Finishing/ Build up'; break;
       case '4' : phase = 'QA'; break;
       case '5' : phase = 'Delivery'; break;
   }

  return ListTile(
     contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
     title: Row(
       children: <Widget>[
         Container(
           width: screenAwareSize(150, context),
           child: Text(caseItem.patientName==null? "N/A":
             caseItem.patientName,
             style:
             TextStyle(color: ThemeConstants.listTileTextColor, fontWeight: FontWeight.bold),textAlign: TextAlign.right
           ),
         ),Container(
           width: 10,
           child: Text(
               ' | ',
               style:
               TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.right
           ),
         ),
         Container(
           width: screenAwareSize(150, context),
           child: Text(doctor==null? "NA" :
              doctor.name,
             style:
             TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.right
           ),
         ),
       ],
     ),
     subtitle: Row(
       children: <Widget>[
            Expanded(
               child: Padding(
                 padding: const EdgeInsets.only(top:4.0),
                 child: Text(phase,
                     style: TextStyle(color: Colors.grey)),
               )),

       ],
     ),
     onTap: () {Navigator.of(context).push(MaterialPageRoute(
         builder: (context) => PreviewCase(caseItem: caseItem,doctor: doctor,refreshLocalList: refreshLocalList,showInSnackBar: showInSnackBar,)));},
   );
 }

  static ListTile makeAppointmentListTile(Appointment appointmentItem,Doctor doctor,BuildContext context,VoidCallback refreshLocalList,Function(String msg) showInSnackBar){
    String phase='';
    String date = appointmentItem.date==null ? "NA":appointmentItem.date;
    String time =appointmentItem.time == null ? "NA" : appointmentItem.time.substring(0,4);
    String doctorName= doctor==null ? "N/A":doctor.name;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),

         title: Row(
           children: <Widget>[
             Flexible(

                child:Text( time+ " - ",
                    style:
                    TextStyle(color: ThemeConstants.listTileTextColor ,fontWeight: FontWeight.bold),
                ),
              ),
             Flexible(

               child:Text(doctorName,
                 style:
                 TextStyle(color: ThemeConstants.listTileTextColor, fontWeight: FontWeight.bold),
               ),
             ),
           ],
         ),

      subtitle: Row(
        children: <Widget>[
          Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top:4.0),
                child: Text(date,
                    style: TextStyle(color: Colors.grey)),
              )),

        ],
      ),
      onTap: () {Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PreviewAppointment(appointmentItem: appointmentItem,doctor: doctor,refreshFromLocalList: refreshLocalList,showInSnackBar: showInSnackBar,)));},
    );
  }

 static FadeTransition makeCard(dynamic object,Doctor doctor, Animation animation,BuildContext context, VoidCallback refreshLocalList,Function(String msg) showInSnackBar){

   return FadeTransition(
     opacity: animation,
     child: new SizeTransition(
       sizeFactor: animation,
       child: InkWell(
         child: Container(

           child: WidgetANimator(
             Column(

               children: <Widget>[
                 new Card(

                   elevation: 0.0,

                   margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                   child: Container(
                     decoration: BoxDecoration(color: ThemeConstants.mainBackground,
                       border: Border.all(
                         color: ThemeConstants.mainBackground,
                         width: 0,
                       ),
                     ),
                       child: object is Case ? makeCaseListTile(object,doctor,context,refreshLocalList,showInSnackBar):makeAppointmentListTile(object,doctor,context,refreshLocalList,showInSnackBar),
                   ),
                 ),   Container(width: MediaQuery.of(context).size.width-80,

                   height: 0.4,
                   color: Colors.grey,
                 ),
               ],
             ),
           ),
         ),
         onTap:() {
         }),
     ),
   );
 }

// FadeTransition makeCard(Case caseItem, Animation animation) {
//   return FadeTransition(
//     opacity: animation,
//     child: new SizeTransition(
//       sizeFactor: animation,
//       child: new Card(
//         elevation: 8.0,
//         margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//         child: Container(
//           decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
//           child: Slidable(
//             actionPane: SlidableStrechActionPane(),
//             actionExtentRatio: 0.25,
//             child: makeListTile(caseItem),
//             secondaryActions: <Widget>[
//               IconSlideAction(
//                 caption: 'Start',
//                 color: Colors.blue,
//                 icon: Icons.play_arrow,
//                 onTap: () => CasesController.updateCaseStatue(caseItem),
//               ),
//               IconSlideAction(
//                 caption: 'View',
//                 color: Colors.indigo,
//                 icon: Icons.insert_drive_file,
//                 onTap: () => ViewCase(caseItem: caseItem),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

//bottomNavigationBar: makeBottom,
  static  loadingCircle(String label){
    return Center(
      child: Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: <Widget>[

          CircularProgressIndicator (valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white)),SizedBox(height: 8),
          Text(label,style: TextStyle(color: Colors.white),)],
      ),
    );
  }
}