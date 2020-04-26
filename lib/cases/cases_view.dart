import 'dart:collection';
import 'package:mosaic/business/Logger.dart';
import 'case_controller.dart';
import 'package:mosaic/cases/case_model.dart';
import 'package:mosaic/doctor/doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mosaic/widgets/Widgets.dart';

import '../doctor/doctors_controller.dart';

void main() => runApp(new CasesMainView());

class CasesMainView extends StatelessWidget {
  CasesMainView({Key key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MOSAIC',
      theme: new ThemeData(

          primaryColor: Color.fromRGBO(33, 44, 22, 1.0), fontFamily: 'VIP-Hakm-Regular-2016.ttf'),
      home: new ListPage(title: 'Appointments',key: key),
    );
  }
}

final key = new GlobalKey<ListPageState>();
class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  ListPageState createState() => ListPageState();
}

class ListPageState extends State<ListPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  static Future<List<Case>>  casesList;
  static TabController _tabController;
//   GlobalKey<AnimatedListState> _listKey =
//      new GlobalKey<AnimatedListState>();

  SharedPreferences prefs;
  static HashMap<String,Doctor> doctors = HashMap<String,Doctor>();

  void initDataFetching() async {
    prefs = await SharedPreferences.getInstance();
  }

  static setDoctorsList(HashMap<String,Doctor> doctorsList) async {
    doctors = doctorsList;
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void initState() {
    super.initState();
    refreshLocalList();
    casesList=CasesController.getCases();
    _tabController = new TabController(length: 2, vsync: this);
  }
   refreshLocalList() async {

     setState(() {casesList=CasesController.getLocalList();});
   }
  refreshListFromDB() async {

    setState(() {casesList=CasesController.getCases();});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
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
            icon: Icon(Icons.refresh),
            onPressed: () {
              refreshListFromDB();
            },
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
        ],
      ),

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
                return AnimatedList(
                    scrollDirection: Axis.vertical,
                    initialItemCount: casesList.data.length,
                    //key: _listKey,
                    itemBuilder: (context, index, animation) {

                      if (isActive(casesList.data[index])) {
                        return Widgets.makeCard(
                            casesList.data[index],
                            DoctorsController.getDoctorById(
                            int.parse(casesList.data[index].doctorId)), animation, context,()=> refreshLocalList(),showInSnackBar);
                      }else{return SizedBox(width: 0,height: 0);}
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
                      print("index ${casesList.data[index].toString()}");
                      if (!isActive(casesList.data[index])) {
                        return Widgets.makeCard(
                            casesList.data[index],
                            DoctorsController.getDoctorById(
                                int.parse(casesList.data[index].doctorId)), animation, context,refreshLocalList,showInSnackBar);
                      }else{return SizedBox(width: 0,height: 0);}
                    });
              })


        ],
      ),
    );
  }
  bool isActive(Case caseItem){

    if(caseItem.madeBy != null )return true;
     return false;
  }
}
