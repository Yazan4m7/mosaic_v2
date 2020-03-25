import 'package:mosaic/business/Logger.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Constants.dart';

class Queries {
  static const ROOT = Constants.ROOT;

  static finishCase(String caseID, String currentStatus,String userId) async {
    var map = Map<String, dynamic>();
    String finishQuery = "UPDATE orders SET current_status ='${int.parse(currentStatus) + 1}', made_by = NULL WHERE id = $caseID";

    String registerEmployeeQuery =
        "INSERT INTO order_logs (user_id, order_id, current_status) VALUES (${userId.toString()}, $caseID, $currentStatus);";

    Logger.log("finish query is : $finishQuery");
    Logger.log("register emp query is : $registerEmployeeQuery");

    map['action'] = "POST";

    map['query'] = finishQuery;
    final finishCaseResponse = await http.post(ROOT, body: map);
    Logger.log('finish case reponse body: ${finishCaseResponse.body}');

    map['query'] = registerEmployeeQuery;
    final response = await http.post(ROOT, body: map);
    Logger.log('register emp finishing response : ${response.body}');

  }

  static startCase(String caseID, String currentStatus, String userId) async {
    var map = Map<String, dynamic>();
    map['action'] = "POST";
    String updateCaseQuery = "UPDATE orders SET made_by = ${userId.toString()} WHERE id = ${caseID.toString()}";
    map['query'] = updateCaseQuery;
    final updateToActiveResponse = await http.post(ROOT, body: map);
    Logger.log(updateToActiveResponse.body);

  }

  static assignAppointment(String appointmentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var map = Map<String, dynamic>();
    String assignQuery = "UPDATE appointments SET taken_by ='${prefs.getString('userId')}' WHERE id = $appointmentId";

//    String registerEmployeeQuery =
//        "INSERT INTO order_logs (user_id, order_id, current_status) VALUES (${userId.toString()}, $caseID, $currentStatus);";

    Logger.log("assign app query is : $assignQuery");
//    Logger.log("register emp query is : $registerEmployeeQuery");

    map['action'] = "POST";

    map['query'] = assignQuery;
    final assignAppointmentResponse = await http.post(ROOT, body: map);
    Logger.log('assing apppintment: ${assignAppointmentResponse.body}');

//    map['query'] = registerEmployeeQuery;
//    final response = await http.post(ROOT, body: map);
//    Logger.log('register emp finishing response : ${response.body}');

  }
  static startAppointment(String appointmentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var map = Map<String, dynamic>();
    String startQuery = "UPDATE appointments SET status = 1 WHERE id = $appointmentId";

//    String registerEmployeeQuery =
//        "INSERT INTO order_logs (user_id, order_id, current_status) VALUES (${userId.toString()}, $caseID, $currentStatus);";

    Logger.log("start app query is : $startQuery");
//    Logger.log("register emp query is : $registerEmployeeQuery");

    map['action'] = "POST";

    map['query'] = startQuery;
    final startAppointmentResponse = await http.post(ROOT, body: map);
    Logger.log('assing apppintment: ${startAppointmentResponse.body}');

//    map['query'] = registerEmployeeQuery;
//    final response = await http.post(ROOT, body: map);
//    Logger.log('register emp finishing response : ${response.body}');

  }
  static finishAppointment(String appointmentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var map = Map<String, dynamic>();
    String finishQuery = "UPDATE appointments SET status = 2 WHERE id = $appointmentId";

//    String registerEmployeeQuery =
//        "INSERT INTO order_logs (user_id, order_id, current_status) VALUES (${userId.toString()}, $caseID, $currentStatus);";

    Logger.log("finish app query is : $finishQuery");
//    Logger.log("register emp query is : $registerEmployeeQuery");

    map['action'] = "POST";

    map['query'] = finishQuery;
    final finishppointmentResponse = await http.post(ROOT, body: map);
    Logger.log('assing apppintment: ${finishppointmentResponse.body}');

//    map['query'] = registerEmployeeQuery;
//    final response = await http.post(ROOT, body: map);
//    Logger.log('register emp finishing response : ${response.body}');

  }

}
