import 'package:mosaic/appointment/calender_view.dart';
import 'package:mosaic/appointment/new_appintment_view.dart';
import 'package:mosaic/doctor/doctor.dart';
import 'package:mosaic/doctor/doctors_controller.dart';
import 'package:flutter/material.dart';
import 'package:mosaic/appointment/appointment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'business/Logger.dart';
import 'cases/new_case.dart';

 main() async {
   WidgetsFlutterBinding.ensureInitialized();
   SharedPreferences prefs = await SharedPreferences.getInstance();


   String userId = prefs.get('userId');


   var caseId = DateTime.now();
   var orderIdDateFormatter = new DateFormat('yyyyMMdd');
   var deliveryDateFormatter = new DateFormat('yyyy-MM-dd H:mm:ss');
   String patientName="patient naame";


   String orderId = "${userId}_${orderIdDateFormatter.format(DateTime.now())}_";

   String deliveryDate = "${deliveryDateFormatter.format(DateTime.now())}";

   Logger.log("case creation id $deliveryDate");


   String createAppointmentQuery =
       "INSERT INTO `orders` ('order_id`, `patient_name`, `deliver_date`, `milled`, `current_status`, `total_status`, `hidden`, `doctor_id`, `service_id`, `created_at`, `updated_at`) "+
           "VALUES ('$orderId', '$patientName', '$deliveryDate' , 0,0,0,0,'12','1,'9')";

 }