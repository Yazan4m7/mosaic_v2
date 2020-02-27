//import 'package:flutter/material.dart';
//
//class Drawer extends StatefulWidget {
//  @override
//  _DrawerState createState() => _DrawerState();
//}
//
//class _DrawerState extends State<Drawer> {
//  List drawerItems = [
//    {
//      "icon": Icons.add,
//      "name": "New Post",
//    },
//    {
//      "icon": Icons.delete,
//      "name": "Delete Post",
//    },
//  ];
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      drawer: Drawer(
//        child: ListView(
//          children: <Widget>[
//            DrawerHeader(
//              child: Text(
//                "DRAWER HEADER..",
//                style: TextStyle(color: Colors.white),
//              ),
//              decoration: BoxDecoration(
//                color: Theme.of(context).primaryColor,
//              ),
//            ),
//            ListView.builder(
//              physics: NeverScrollableScrollPhysics(),
//              shrinkWrap: true,
//              itemCount: drawerItems.length,
//              itemBuilder: (BuildContext context, int index) {
//                Map item = drawerItems[index];
//                return ListTile(
//                  leading: Icon(
//                    item['icon'],
//                  ),
//                  title: Text(
//                    item['name'],
//                    style: TextStyle(),
//                  ),
//                  onTap: () {
//                    Navigator.pop(context);
//                  },
//                );
//              },
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
