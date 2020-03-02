import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mosaic/business/CasesController.dart';
import 'package:mosaic/business/Logger.dart';
import 'package:mosaic/models/Case.dart';
import 'package:mosaic/screens/casesUiWidgets/list_model.dart';
import 'package:mosaic/screens/viewSingleCase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lesson.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
          primaryColor: Color.fromRGBO(58, 66, 86, 1.0), fontFamily: 'Raleway'),
      home: new ListPage(title: 'Cases'),
      // home: DetailPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);
  final double dotSize = 20.0;
  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Animation<double> animation;

  List lessons;
  static Future casesList;

  final GlobalKey<AnimatedListState> _listKey =
  new GlobalKey<AnimatedListState>();

  static GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  ListModel listModel;
  bool showOnlyCompleted = false;
  SharedPreferences prefs;

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    casesList = _getCases();
    initSharedPrefs();
  }

  _getCases() async {
    return CasesController.getCases();
  }

  ListTile makeListTile(Case caseItem) =>
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),

        title: Row(
          children: <Widget>[
            Container(
              width: 150,
              child: Text(
                caseItem.patient_name ,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ), Container(
              width: 90,
              child: Text(
                " | " + caseItem.doctor_id.toString(),
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

          ],
        ),

        subtitle: Row(
          children: <Widget>[
            Expanded(
                  child: Text(caseItem.stage.toUpperCase(), style: TextStyle(color: Colors.grey))),
          ],
        ),

        onTap: () {},
      );

  FadeTransition makeCard(Case caseItem, Animation animation) {
    return FadeTransition(
        opacity: animation,
        child: new SizeTransition(
          sizeFactor: animation,
          child: new Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
              child: Slidable(
                  actionPane: SlidableStrechActionPane(),
                  actionExtentRatio: 0.25,

                  child: makeListTile(caseItem),
                secondaryActions: <Widget>[
              IconSlideAction(
              caption: 'Start',
                color: Colors.blue,
                icon: Icons.play_arrow,
                onTap: () => CasesController.updateCaseStatue(caseItem),
              ),
                IconSlideAction(
                  caption: 'View',
                  color: Colors.indigo,
                  icon: Icons.insert_drive_file,
                  onTap: () => ViewCase(caseItem: caseItem),
                ),
                ],
            ),

            ),
          ),
        ),



    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      key:_drawerKey,

        drawer:new Drawer(

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
        ),
      body: FutureBuilder(
          future: casesList,
          builder: (context, casesList) {
            if (casesList.connectionState == ConnectionState.none ||
                casesList.data == null) {
              print('snapshot data is: ${casesList
                  .data} and connecting is ${casesList.connectionState}');
              return Container();
            }
            print(casesList.data.length);
            return AnimatedList(
                scrollDirection: Axis.vertical,
                initialItemCount: casesList.data.length,
                key: _listKey,
                itemBuilder: (context, index, animation) {
                  print("inital item count ${casesList.data.length}");
                  print("index $index");
                  return makeCard(casesList.data[index], animation);
                });
          }),


      bottomNavigationBar: makeBottom,);
  }
  final topAppBar = AppBar(
    automaticallyImplyLeading: false,
    elevation: 0.1,
    backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
    title: Text("Cases"),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.list),
        onPressed: () {_drawerKey.currentState.openDrawer();},
      )
    ],
  );
}
final makeBottom = Container(
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
  ),
);



//
//
//bottomNavigationBar: makeBottom,
