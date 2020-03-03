import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mosaic/business/CasesController.dart';
import 'package:mosaic/business/Logger.dart';
import 'package:mosaic/models/Case.dart';
import 'package:mosaic/screens/casesUiWidgets/list_model.dart';
import 'package:mosaic/screens/viewSingleCase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mosaic/widgets/Widgets.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MOSAIC',
      theme: new ThemeData(
          primaryColor: Color.fromRGBO(58, 66, 86, 1.0), fontFamily: 'Raleway'),
      home: new ListPage(title: 'Cases'),
      // home: DetailPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  static Future casesList;
  static TabController _tabController;
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  ListModel listModel;
  SharedPreferences prefs;

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    casesList = CasesController.casesGetter();
    initSharedPrefs();
    _tabController = new TabController(length: 2, vsync: this);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: [
            new Tab(
                child: Text('Active',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white))),
            new Tab(
              child: Text('Waiting',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white)),
            ),
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
        automaticallyImplyLeading: false,
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text("Cases"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              _drawerKey.currentState.openDrawer();
            },
          )
        ],
      ),
      key: _drawerKey,
      drawer: Widgets.mosaicDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder(
              future: casesList,
              builder: (context, casesList) {
                if (casesList.connectionState == ConnectionState.none ||
                    casesList.data == null) {
                  print(
                      'snapshot data is: ${casesList.data} and connecting is ${casesList.connectionState}');
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
                      return Widgets.makeCard(casesList.data[index], animation);
                    });
              }),
          FutureBuilder(
              future: casesList,
              builder: (context, casesList) {
                if (casesList.connectionState == ConnectionState.none ||
                    casesList.data == null) {
                  print(
                      'snapshot data is: ${casesList.data} and connecting is ${casesList.connectionState}');
                  return Container();
                }
                print(casesList.data.length);
                return AnimatedList(
                    scrollDirection: Axis.vertical,
                    initialItemCount: casesList.data.length,
                    //key: _listKey,
                    itemBuilder: (context, index, animation) {
                      //if Waiting
                      return Widgets.makeCard(casesList.data[index], animation);
                    });
              })
        ],
      ),
      bottomNavigationBar: Widgets.mainViewBottomBar(),
    );
  }
}
