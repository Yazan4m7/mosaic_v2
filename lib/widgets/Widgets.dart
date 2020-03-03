import 'package:flutter/material.dart';
import 'package:mosaic/business/Logger.dart';
import 'package:mosaic/models/Case.dart';
import 'package:mosaic/screens/previewCase.dart';
import 'package:mosaic/screens/viewSingleCase.dart';
class Widgets{

 static Drawer mosaicDrawer() {
   return Drawer(

     child:new ListView(
       children: <Widget>[
         Container(
           height: 150.0,
           child: DrawerHeader(
             child: Padding(
               padding: const EdgeInsets.fromLTRB(0,60,0.0,0),
               child: Text('Nothing is here yet.', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.white)),
             ),
             decoration: BoxDecoration(
                 color: Colors.black87
             ),

           ),
         ),

         new ListTile(
             title: Text("Logs"),
             trailing: Icon(Icons.folder),
             onTap:(){ WriteToFile.openLogs();}
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

 static ListTile makeListTile(Case caseItem){
  return ListTile(
     contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
     title: Row(
       children: <Widget>[
         Container(
           width: 150,
           child: Text(
             caseItem.patient_name,
             style:
             TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
           ),
         ),
         Container(
           width: 90,
           child: Text(
             " | " + caseItem.doctor_id.toString(),
             style:
             TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
           ),
         ),
       ],
     ),
     subtitle: Row(
       children: <Widget>[
         Expanded(
             child: Text(caseItem.stage.toUpperCase(),
                 style: TextStyle(color: Colors.grey))),
       ],
     ),
     onTap: () {},
   );
 }

 static FadeTransition makeCard(Case caseItem, Animation animation){
   return FadeTransition(
     opacity: animation,
     child: new SizeTransition(
       sizeFactor: animation,
       child: InkWell(
         child: new Card(
           elevation: 8.0,
           margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
           child: Container(
             decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
               child: makeListTile(caseItem),
           ),
         ),
         onTap:(){
           Navigator.of(context).push(MaterialPageRoute(builder: (context) => PreviewCase(caseItem: caseItem,)));

       ),
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
}