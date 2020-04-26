import 'dart:collection';
import 'package:mosaic/appointment/appointments_controller.dart';
import 'package:mosaic/business/Logger.dart';
import 'package:mosaic/appointment/appointment_model.dart';
import 'package:mosaic/doctor/doctor.dart';
import 'package:mosaic/doctor/doctors_controller.dart';
import 'package:mosaic/widgets/Widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mosaic/Utils/themes_constans.dart';
import 'package:mosaic/widgets/decorated_tab_bar.dart';
void main() => runApp(new AppointmentsMainView());


class AppointmentsMainView extends StatelessWidget {

  AppointmentsMainView({Key key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MOSAIC',
      theme: new ThemeData(

        fontFamily: 'VIP-Hakm-Regular-2016.ttf'),
      home: new AppointmentListPage(title: 'Appointments',key: key),
    );
  }
}

final key = new GlobalKey<AppointmentListPageState>();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
void showInSnackBar(String value) {
  _scaffoldKey.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}
class AppointmentListPage extends StatefulWidget {
  AppointmentListPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  AppointmentListPageState createState() => AppointmentListPageState();
}

class AppointmentListPageState extends State<AppointmentListPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  static Future<List<Appointment>>  appointmentList;
  static TabController _tabController;

  SharedPreferences prefs;
  static HashMap<String,Doctor> doctors = HashMap<String,Doctor>();

  void initDataFetching() async {
    prefs = await SharedPreferences.getInstance();
  }

  static setDoctorsList(HashMap<String,Doctor> doctorsList) async {
    doctors = doctorsList;
  }
  initializeSharedPreferences()async{prefs = await SharedPreferences.getInstance();}
  void initState() {
    super.initState();
    refreshLocalList();
    appointmentList=AppointmentsController.getAppointments();
    final key = new GlobalKey<AppointmentListPageState>();
    initializeSharedPreferences();
    _tabController = new TabController(length: 2, vsync: this);
  }
  refreshLocalList() async {

    setState(() {appointmentList=AppointmentsController.getLocalList();});
  }
  refreshListFromDB() async {

    setState(() {appointmentList=AppointmentsController.getAppointments();});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      floatingActionButton: FloatingActionButton(
          child:Icon(Icons.add),
          foregroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          backgroundColor: Colors.white,
          onPressed: () {
            // Add your onPressed code here!
          }),
      backgroundColor: ThemeConstants.mainBackground,
      appBar: AppBar(

        bottom: DecoratedTabBar(

          tabBar: TabBar(
            indicatorColor:  ThemeConstants.unselectedTabTextColor,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 5,
            controller: _tabController,
            tabs: [new Tab(

                  child: Text('ACTIVE',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,))),
            new Tab(
              child: Text('WAITING',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,)),
            ),
            ],
          ),

          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: ThemeConstants.selectedTabTextColor,
                width: 5.0,
              ),
            ),

          ),

        ),

        bottomOpacity: 1,
        automaticallyImplyLeading: false,
        elevation: 0.1,
        backgroundColor: ThemeConstants.topAppBarColor,
        title: Text("Appointments",style: TextStyle(color: ThemeConstants.titleColor),),

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
              future: appointmentList,
              builder: (context, appointmentList) {
                if (appointmentList.connectionState == ConnectionState.none ||
                    appointmentList.data == null) {

                  return Container();
                }
                print("appointments list length${appointmentList.data.length}");
                return AnimatedList(
                    scrollDirection: Axis.vertical,
                    initialItemCount: appointmentList.data.length,
                    //key: _listKey,
                    itemBuilder: (context, index, animation) {
                      Appointment appointment = appointmentList.data[index];
                      String userId = prefs.getString('userId');
                      if (appointment.taken_by == userId.toString() && appointment.status != '2') {
                        return Widgets.makeCard(appointment,
                            DoctorsController.getDoctorById(int.parse(appointment.doctor_id)),
                            animation, context,()=>refreshLocalList(),showInSnackBar);
                      }else{return SizedBox(width: 0,height: 0);}
                    });
              }),
          FutureBuilder(
              future: appointmentList,
              builder: (context, appointmentList) {
                if (appointmentList.connectionState == ConnectionState.none ||
                    appointmentList.data == null) {

                  return Container(child: Text('null'),);
                }
                print("appointments list length${appointmentList.data.length}");
                return AnimatedList(
                    scrollDirection: Axis.vertical,
                    initialItemCount: appointmentList.data.length,
                    //key: _listKey,
                    itemBuilder: (context, index, animation) {
                      Appointment appointment = appointmentList.data[index];
                      if (appointment.taken_by == "N/A") {
                        return Widgets.makeCard(appointment,
                            DoctorsController.getDoctorById(int.parse(appointment.doctor_id)),
                             animation, context,()=>refreshLocalList(),showInSnackBar);
                      }else{return SizedBox(width: 0,height: 0);}
                    });
              }),



        ],
      ),
    );
  }
  bool isActive(Appointment appointment){
    Logger.log('app status ${appointment.status}');
    if(appointment.status !='1' && appointment.status!='2' )return true;
    return false;
  }
}
