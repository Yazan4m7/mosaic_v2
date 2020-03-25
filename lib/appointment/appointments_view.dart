import 'dart:collection';
import 'package:mosaic/appointment/appointments_controller.dart';
import 'package:mosaic/business/Logger.dart';
import 'package:mosaic/appointment/appointment_model.dart';
import 'package:mosaic/doctor/doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mosaic/widgets/Widgets.dart';
import 'package:mosaic/doctor/doctors_controller.dart';
void main() => runApp(new AppointmentsMainView());


class AppointmentsMainView extends StatelessWidget {
  AppointmentsMainView({Key key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MOSAIC',
      theme: new ThemeData(

          primaryColor: Color.fromRGBO(58, 66, 86, 1.0), fontFamily: 'VIP-Hakm-Regular-2016.ttf'),
      home: new AppointmentListPage(title: 'Appointments',key: key),
    );
  }
}

final key = new GlobalKey<AppointmentListPageState>();
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
//   GlobalKey<AnimatedListState> _listKey =
//      new GlobalKey<AnimatedListState>();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
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
    Logger.log("Refrishing list");
    setState(() {appointmentList=AppointmentsController.getAppointments();});
  }
  refreshListFromDB() async {
    Logger.log("Refrishing list");
    setState(() {appointmentList=AppointmentsController.getAppointments();});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child:Icon(Icons.add),
          foregroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          backgroundColor: Colors.white,
          onPressed: () {
            // Add your onPressed code here!
          }),
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
        title: Text("Appointments"),
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
              _drawerKey.currentState.openDrawer();
            },
          ),
        ],
      ),
      key: _drawerKey,
      drawer: Widgets.mosaicDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder(
              future: appointmentList,
              builder: (context, appointmentList) {
                if (appointmentList.connectionState == ConnectionState.none ||
                    appointmentList.data == null) {
                  print(
                      'snapshot data is: ${appointmentList.data} and connecting is ${appointmentList.connectionState}');
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
                            animation, context,()=>refreshLocalList(),);
                      }else{return SizedBox(width: 0,height: 0);}
                    });
              }),
          FutureBuilder(
              future: appointmentList,
              builder: (context, appointmentList) {
                if (appointmentList.connectionState == ConnectionState.none ||
                    appointmentList.data == null) {
                  print(
                      'snapshot data is: ${appointmentList.data} and connecting is ${appointmentList.connectionState}');
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
                             animation, context,()=>refreshLocalList(),);
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
