class Case {
  int id;
  int order_id;
  String patient_name;
  DateTime deliver_date;
  String milled;
  String milled_by;
  String current_status;
  String total_status;
  String hidden;
  int made_by;
  String note;
  int doctor_id;
  int lab_id;
  int service_id;
  int app_id;
  String created_by;
  String deleted_at;
  String created_at;
  String updated_at;

  Case({this.id,
    this.order_id,
    this.patient_name,
    this.deliver_date,
    this.milled,
    this.milled_by,
    this.current_status,
    this.total_status,
    this.hidden,
    this.made_by,
    this.note,
    this.doctor_id,
    this.lab_id,
    this.service_id,
    this.app_id,
    this.created_by,
    this.deleted_at,
    this.created_at,
    this.updated_at});

  factory Case.fromJson(Map<String, dynamic> json) {
    print("from json" + json['id']);
    Case caseItem = Case();
    caseItem.id=json['id'];
//        order_id: int.parse(json['order_id']),
//        patient_name: json['patient_name'] as String,
//        deliver_date: DateTime.parse(json['deliver_date']),
//        milled: json['milled'],
//        milled_by: json['milled_by'] as String,
//        current_status: json['current_status'] as String,
//        total_status: json['total_status'] as String,
//        hidden: json['hidden'],
//        made_by: int.parse(json['made_by']),
//        note: json['note'],
//        doctor_id: int.parse(json['doctor_id']),
//        lab_id: int.parse(json['lab_id']),
//        service_id: int.parse(json['service_id']),
//        app_id: int.parse(json['app_id']),
//        created_at: json['created_at'],
//        deleted_at: json['deleted_at'],
//        created_by: json['created_by'],
//        updated_at: json['updated_at']);
  print("return from fromJson");
    return caseItem;
  }
}