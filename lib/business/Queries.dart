
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mosaic/business/Logger.dart';
import 'package:http/http.dart' as http;
import 'package:mosaic/cases/case_model.dart';
import 'package:mosaic/cases/invoice_model.dart';
import 'package:mosaic/doctor/doctor.dart';
import 'package:mosaic/doctor/doctors_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Constants.dart';
import 'package:intl/intl.dart';

class Queries {
  static const ROOT = Constants.ROOT;

  static finishCase(Case caseItem, String currentStatus, String userId) async {
    var map = Map<String, dynamic>();
    String finishQuery =
        "UPDATE orders SET current_status ='${int.parse(currentStatus) + 1}', made_by = NULL WHERE order_id = '${caseItem.orderId}'";

    String registerEmployeeQuery =
        "INSERT INTO order_logs (user_id, order_id, current_status) VALUES (${userId.toString()}, ${caseItem.orderId}, $currentStatus);";

    Logger.log("finish query is : $finishQuery");
    Logger.log("register emp query is : $registerEmployeeQuery");

    map['action'] = "POST";
    String responseText = "N/A";
    map['query'] = finishQuery;
    await http.post(ROOT, body: map).then((value) => responseText=value.body);
    Logger.log('finish case reponse body: $responseText');

//    map['query'] = registerEmployeeQuery;
//    final response = await http.post(ROOT, body: map);
//    Logger.log('register emp finishing response : ${response.body}');
    Logger.log("CASE CURRENT STATUS IS ${caseItem.currentStatus}");
    if(caseItem.currentStatus =='6')
      {Logger.log("adding invoice");addInvoiceValueToDoctorBalance(caseItem,userId);}

    return responseText;
  }

  static addInvoiceValueToDoctorBalance(Case caseItem, String userId) async {
    var map = Map<String, dynamic>();


    // get invoice
    String getInvoiceValue = "SELECT * FROM `invoices` WHERE order_id = '${caseItem.id}'";
    map['action'] = "GET";
    map['query'] = getInvoiceValue;
    final response = await http.post(ROOT, body: map);
    if(response.body.isEmpty){Logger.log('No invoice found ');return;}
    var parsed = json.decode(response.body);
    Invoice invoice = Invoice.fromJson(parsed[0]);


    // get doctor previous balance
      int doctorBalance = int.parse(DoctorsController.getDoctorById(int.parse(caseItem.doctorId)).balance);
    Logger.log("doc previouse balance : $doctorBalance");
      doctorBalance = doctorBalance + int.parse(invoice.amount);

      String updateBalanceQuery = "UPDATE doctors SET balance = $doctorBalance WHERE id = ${caseItem.doctorId}";
    map['action'] = "POST";
    map['query'] = updateBalanceQuery;
    Logger.log("update balance query : $updateBalanceQuery");
    String responseText ="N/A";
    await http.post(ROOT, body: map).then((value) => responseText=value.body);
    Logger.log("update balance response : $responseText");

  }

  static startCase(String caseID, String currentStatus, String userId) async {
    var map = Map<String, dynamic>();
    map['action'] = "POST";
    String updateCaseQuery =
        "UPDATE orders SET made_by = ${userId.toString()} WHERE id = ${caseID.toString()}";
    map['query'] = updateCaseQuery;
    String responseText="N/A";
     await http.post(ROOT, body: map).then((value) => responseText=value.body);
    Logger.log(responseText);
    return responseText;
  }


  static assignAppointment(String appointmentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var map = Map<String, dynamic>();
    String assignQuery =
        "UPDATE appointments SET taken_by ='${prefs.getString('userId')}' WHERE id = $appointmentId";

//    String registerEmployeeQuery =
//        "INSERT INTO order_logs (user_id, order_id, current_status) VALUES (${userId.toString()}, $caseID, $currentStatus);";

    Logger.log("assign app query is : $assignQuery");
    String responseText;

    map['action'] = "POST";

    map['query'] = assignQuery;
    await http.post(ROOT, body: map).then((value) => responseText=value.body);
    Logger.log('assing apppintment: $responseText');
return responseText;
//    map['query'] = registerEmployeeQuery;
//    final response = await http.post(ROOT, body: map);
//    Logger.log('register emp finishing response : ${response.body}');
  }

  static startAppointment(String appointmentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var map = Map<String, dynamic>();
    String startQuery =
        "UPDATE appointments SET status = 1 WHERE id = $appointmentId";

//    String registerEmployeeQuery =
//        "INSERT INTO order_logs (user_id, order_id, current_status) VALUES (${userId.toString()}, $caseID, $currentStatus);";

    Logger.log("start app query is : $startQuery");
//    Logger.log("register emp query is : $registerEmployeeQuery");

    map['action'] = "POST";
    String responseText="N/A";
    map['query'] = startQuery;
    await http.post(ROOT, body: map).then((value) => responseText=value.body);
    return responseText;
//    map['query'] = registerEmployeeQuery;
//    final response = await http.post(ROOT, body: map);
//    Logger.log('register emp finishing response : ${response.body}');
  }

  static finishAppointment(String appointmentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var map = Map<String, dynamic>();
    String finishQuery =
        "UPDATE appointments SET status = 2 WHERE id = $appointmentId";

//    String registerEmployeeQuery =
//        "INSERT INTO order_logs (user_id, order_id, current_status) VALUES (${userId.toString()}, $caseID, $currentStatus);";

    Logger.log("finish app query is : $finishQuery");
//    Logger.log("register emp query is : $registerEmployeeQuery");

    map['action'] = "POST";
    String responseText= "N/A";
    map['query'] = finishQuery;
    await http.post(ROOT, body: map).then((value) => responseText=value.body);
    return responseText;

//    map['query'] = registerEmployeeQuery;
//    final response = await http.post(ROOT, body: map);
//    Logger.log('register emp finishing response : ${response.body}');
  }

  static createAppointment(
      String doctorName, String date, String time, String description,String cameraId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var map = Map<String, dynamic>();
    String createAppointmentQuery =
        "INSERT INTO `appointments` (`id`, `description`, `date`, `time`, `doctor_id`, `camera_id`, `created_by`, `taken_by`, `status`, `created_at`, `updated_at`) "+
            "VALUES (NULL, '$description', '$date', '$time', '${DoctorsController.getDoctorIdByName(doctorName)}', '$cameraId', '${prefs.getString('userId')}', NULL, '0', NULL, NULL)";

    map['query'] = createAppointmentQuery;
    map['action'] = "POST";
    String responseText;
    map['query'] = createAppointmentQuery;
    await http.post(ROOT, body: map).then((value) => responseText=value.body);
    Logger.log('create apppintment query: $createAppointmentQuery');
    Logger.log("Create appointment post response : ${responseText}");
    return responseText;

  }

  static createCase(
      Doctor doctor, String patientName,String notes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var map = Map<String, dynamic>();
    String userId = prefs.get('userId');
    var caseId = DateTime.now();
    var orderIdDateFormatter = new DateFormat('yyyyMMdd');
    var deliveryDateFormatter = new DateFormat('yyyy-MM-dd H:mm:ss');


    String orderId = "${userId}_${orderIdDateFormatter.format(DateTime.now())}_";

    String dateOfNow = "${deliveryDateFormatter.format(DateTime.now())}";
//
//    Logger.log("case creation id $id");
    String createCaseQuery ="INSERT INTO `orders` (`order_id`, `patient_name`, `deliver_date`, `doctor_id`,`service_id`,`note`,`created_at`)"
        " VALUES ('$orderId', '$patientName', '$dateOfNow','${doctor.id}', '1','$notes','$dateOfNow')";
    Logger.log(createCaseQuery);

    map['query'] = createCaseQuery;
    map['action'] = "POST";
    String responseText;
    await http.post(ROOT, body: map).then((value) => responseText=value.body);
    Logger.log("Create appointment post response : ${responseText}");
    return responseText;
  }
// unused
static createInvoice(
    Doctor doctor, String patientName,String notes) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var map = Map<String, dynamic>();
  String userId = prefs.get('userId');
  var caseId = DateTime.now();
  var orderIdDateFormatter = new DateFormat('yyyyMMdd');
  var deliveryDateFormatter = new DateFormat('yyyy-MM-dd H:mm:ss');


  String orderId = "${userId}_${orderIdDateFormatter.format(DateTime.now())}_";

  String dateOfNow = "${deliveryDateFormatter.format(DateTime.now())}";
  String createCaseQuery ="INSERT INTO `orders` (`order_id`, `patient_name`, `deliver_date`, `doctor_id`,`service_id`,`note`,`created_at`)"
      " VALUES ('$orderId', '$patientName', '$dateOfNow','${doctor.id}', '1','$notes','$dateOfNow')";
  Logger.log(createCaseQuery);

  map['query'] = createCaseQuery;
  map['action'] = "POST";
  String responseText;
  await http.post(ROOT, body: map).then((value) => responseText=value.body);
  Logger.log("Create appointment post response : ${responseText}");
  return responseText;

}
}
