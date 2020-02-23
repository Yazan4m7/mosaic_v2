import 'package:mosaic/business/CasesController.dart';
import 'package:mosaic/models/Case.dart';
import 'animated_fab.dart';
import 'diagonal_clipper.dart';
import 'list_model.dart';
import 'case_row.dart';
import 'package:flutter/material.dart';

void main() => runApp(new CasesUi());

class CasesUi extends StatelessWidget {


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
    initState2();


  }
  void initState2() async{
    await _getCases();
    print("inside initState : ${casesList[0].patient_name}");
    listModel = new ListModel(_listKey, casesList);

print("length ${listModel.length}");
  }
    _getCases() async {
    await CasesController.getCases().then((cases) {
      setState(() {
        casesList = cases;

      });

    });
    print("inside _getCases : ${casesList[0].patient_name}");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          _buildTimeline(),

          _buildTopHeader(),
          _buildProfileRow(),
          _buildBottomPart(),
          _buildFab(),
        ],
      ),
    );
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

  Widget _buildImage() {
    return new Positioned.fill(
      bottom: null,
      child: new ClipPath(
        clipper: new DialogonalClipper(),
        child: new Image.asset(
          'images/birds.jpg',
          fit: BoxFit.cover,
          height: _imageHeight,
          colorBlendMode: BlendMode.srcOver,
          color: new Color.fromARGB(120, 20, 10, 40),
        ),
      ),
    );
  }

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
            child: Row (children: <Widget>[Column(
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

              SizedBox(width: 30,),
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
          )],
      ),
    );
  }

  Widget _buildBottomPart() {
    return new Padding(
      padding: new EdgeInsets.only(top: _imageHeight),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMyTasksHeader(),
          _buildTasksList(),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    return new Expanded(
      child: new AnimatedList(
        initialItemCount: casesList.length,
        key: _listKey,
        itemBuilder: (context, index, animation) {
          return new CaseRow(
            caseItem: listModel[index],
            animation: animation,
          );
        },
      ),
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
    return new Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 32.0,
      child: new Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }
}
