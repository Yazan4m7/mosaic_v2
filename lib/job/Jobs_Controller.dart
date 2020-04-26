import 'dart:convert';
import 'package:mosaic/business/Constants.dart';
import 'package:mosaic/business/Logger.dart';
import 'file:///D:/officalProject%20-%20Copy/mosaic/lib/job/Job_Type.dart';
import 'package:http/http.dart' as http;
import 'file:///D:/officalProject%20-%20Copy/mosaic/lib/job/Job.dart';

class JobsController {
  
  static const String ROOT = Constants.ROOT;

  static List<Job> jobs = List<Job>();

  static Map<int, JobType> jobTypes = Map<int, JobType>();

  static fetchJobsByCaseId(caseId) async {

    var map = Map<String, dynamic>();
    map['action'] = 'GET';
    map['query'] = "SELECT * from jobs WHERE order_id='$caseId'";

    final getJobsResponse = await http.post(ROOT, body: map);
    try {
      var parsed = json.decode(getJobsResponse.body);
    } catch (e) {
      return null;
    }
    var parsed = json.decode(getJobsResponse.body);
    jobs.clear(); // to ensure previous case's jobs not in the list
    print("parsed jobs is $parsed");
    for (int i = 0; i < parsed.length; i++) {
      Job job = Job.fromJson(parsed[i]);
      if (job.unitNum == null) continue;
      jobs.add(job);
      print('Job added parsing ${job.unitNum}');
    }
    await fetchJobStyles();
    Logger.log("Jobs map size  : ${jobs.length}");
    if (jobs.length == 0) {
      Logger.log("empty jobs map, returning null");
      return null;
    }
    return jobs;
  }

  static fetchJobStyles() async {
    print("fetching job types");
    var map = Map<String, dynamic>();
    map['action'] = 'GET';
    map['query'] = "SELECT * from job_types;";

    final getJobTypesResponse = await http.post(ROOT, body: map);
    var parsed = json.decode(getJobTypesResponse.body);

    for (int i = 0; i < parsed.length; i++) {
      JobType jobType = JobType.fromJson(parsed[i]);
      jobTypes[i] = (jobType);
      print('JobType added');
    }
  }

  static String getJobTypeNameById(int jobId) {
    if (jobTypes[jobId] == null) return "N/A";
    return jobTypes[jobId].name;
  }
}
