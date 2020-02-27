import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mosaic/business/CasesController.dart';
import 'package:mosaic/models/Case.dart';
import 'package:mosaic/screens/casesUiWidgets/list_model.dart';
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
  List<Case> casesList = [];
  final GlobalKey<AnimatedListState> _listKey =
      new GlobalKey<AnimatedListState>();

  ListModel listModel;
  bool showOnlyCompleted = false;
  SharedPreferences prefs;

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
  }

  _getCases() async {
    casesList = await CasesController.getCases();
    return casesList;
  }

  ListTile makeListTile(Case caseItem) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.autorenew, color: Colors.white),
        ),
        title: Text(
          caseItem.patient_name,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  // tag: 'hero',
                  child: LinearProgressIndicator(
                      backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                      value: 5,
                      valueColor: AlwaysStoppedAnimation(Colors.green)),
                )),
            Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("3", style: TextStyle(color: Colors.white))),
            )
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () {},
      );

  Slidable makeCard(Case caseItem) {
    return Slidable(
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      child: FadeTransition(
      opacity: animation,
    child: new SizeTransition(
    sizeFactor: animation,
    child: new Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: makeListTile(caseItem),
        ),
      ),
    ),),);
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: FutureBuilder(
        builder: (context, casesList) {
          if (casesList.connectionState == ConnectionState.none ||
              casesList.data == null) {
            print('snapshot data is: ${casesList.data}');
            return Container();
          }
          return AnimatedList(
            initialItemCount: casesList.data.length,
            key: _listKey,
            itemBuilder: (context, index, animation) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                child: Container(
                  // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: casesList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return makeCard(casesList.data[index]);
                    },
                  ),
                ),
              );
            },
          );
        },
        future: _getCases(),
      ),
      bottomNavigationBar: makeBottom,
    );
  }
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
final topAppBar = AppBar(
  elevation: 0.1,
  backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
  title: Text("Cases"),
  actions: <Widget>[
    IconButton(
      icon: Icon(Icons.list),
      onPressed: () {},
    )
  ],
);
//
//
//bottomNavigationBar: makeBottom,
