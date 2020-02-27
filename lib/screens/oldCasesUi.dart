import 'package:mosaic/business/CasesController.dart';
import 'package:mosaic/models/Case.dart';
import 'casesUiWidgets/animated_fab.dart';
import 'casesUiWidgets/list_model.dart';
import 'casesUiWidgets/case_row.dart';
import 'package:flutter/material.dart';

void main() => runApp(new OldCasesUi());

class OldCasesUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Case> casesList = [];
  final GlobalKey<AnimatedListState> _listKey =
      new GlobalKey<AnimatedListState>();
  final double _imageHeight = 256.0;
  ListModel listModel;
  bool showOnlyCompleted = false;

  @override
  void initState() {
    super.initState();
    _getCases();
    listModel = new ListModel(_listKey, casesList);
  }

  _getCases() async {
    await CasesController.getCases().then((cases) {
      setState(() {
        casesList = cases;
      });
    });
    return casesList;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
          _buildTimeline(),
      _buildTasksList2(),
      _buildTopHeader(),
      _buildProfileRow(),
      _buildBottomPart(),
      _buildFab(),
    ]);
  }

  Widget _buildFab() {
    return new Positioned(
        top: _imageHeight - 100.0,
        right: -40.0,
        child: new AnimatedFab(
            //onClick: _changeFilterState,
            ));
  }

//  void _changeFilterState() {
//    showOnlyCompleted = !showOnlyCompleted;
//    cases.where((caseItem) => caseItem.stage=8).forEach((caseItem) {
//      if (showOnlyCompleted) {
//        listModel.removeAt(listModel.indexOf(caseItem));
//      } else {
//        listModel.insert(cases.indexOf(caseItem), caseItem);
//      }
//    });
//  }

  Widget _buildTopHeader() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.menu, size: 32.0, color: Colors.white),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Text(
                "Timeline",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          new Icon(Icons.linear_scale, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildProfileRow() {
    return new Padding(
      padding: new EdgeInsets.only(left: 16.0, top: 85),
      child: new Row(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      'Completed:',
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300),
                    ),
                    new Text(
                      '24',
                      style: new TextStyle(
                          fontSize: 30.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      'Waiting:',
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300),
                    ),
                    new Text(
                      '37',
                      style: new TextStyle(
                          fontSize: 30.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      'Active:',
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300),
                    ),
                    new Text(
                      '5',
                      style: new TextStyle(
                          fontSize: 30.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomPart() {
    return new Padding(
      padding: new EdgeInsets.only(top: _imageHeight),
      child: Column(
        children: <Widget>[
          Expanded(
                child: _buildMyTasksHeader(),
                //_buildTasksList(),

          ),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    return Expanded(
      child: Column(
        children: <Widget>[
          AnimatedList(
            initialItemCount: listModel.length,
            key: _listKey,
            itemBuilder: (context, index, animation) {
              return new CaseRow(
                caseItem: listModel[index],
                animation: animation,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList2() {
    return Column(
      children: <Widget>[
        new Expanded(
            child: FutureBuilder(
          builder: (context, Case) {
            if (Case.connectionState == ConnectionState.none || Case.data == null) {
              print('project snapshot data is: ${Case.data}');
              return Container();
            }
            return AnimatedList(
              initialItemCount: Case.data.length,
              key: _listKey,
              itemBuilder: (context, index, animation) {
                return new CaseRow(
                  caseItem: Case.data[index],
                  animation: animation,
                );
              },
            );
          },
          future: _getCases(),
        )),
      ],
    );
  }

  Widget _buildMyTasksHeader() {
    return new Padding(
      padding: new EdgeInsets.only(left: 64.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            'My Tasks',
            style: new TextStyle(fontSize: 34.0),
          ),
          new Text(
            'FEBRUARY 8, 2015',
            style: new TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Positioned(
        top: 0.0,
        bottom: 0.0,
        left: 32.0,
        child: new Container(
          width: 1.0,
          color: Colors.grey[300],
        ),
      );
  }
//  Widget _buildTimeline() {
//    return
//      new Container(
//        top: 0.0,
//        bottom: 0.0,
//        left: 32.0,
//        child: new Container(
//          width: 1.0,
//          color: Colors.grey[300],
//        ),
//      );
//  }
}
