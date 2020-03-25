class Appointment {
  String id;
  String description;
  String date;
  String time;
  String doctor_id;
  String created_by;
  String taken_by;
  String status;
  String created_at;
  String day;

  Appointment({this.id, this.description, this.date, this.time, this.doctor_id,
      this.created_by, this.taken_by, this.status,this.day});


  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
       id : json['id']==null? "N/A":json['id'],
      description: json['description'] == null ? "N/A" : json['description'],
      date: json['date'] == null ? "N/A" : json['date'],
      time: json['time'] == null ? "N/A" : json['time'],
      doctor_id: json['doctor_id'] == null ? "N/A" : json['doctor_id'],
      created_by: json['created_by'] == null ? "N/A" : json['created_by'],
      taken_by: json['taken_by'] == null ? "N/A" : json['taken_by'],
      status : json['status']==null? "N/A":json['status'],
      day: json['day']??"N/A"
    );
  }
  @override
  String toString() {
    // TODO: implement toString
    return ("$id $description $date $time $taken_by $status");
  }
}

