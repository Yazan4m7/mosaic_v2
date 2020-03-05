class Case {
  String id;
  String order_id;
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

   factory Case.jsonToCase (Map<String, dynamic> json) {
    Case caseItem = Case();

    caseItem.id= json['id'];
    caseItem.order_id= json['order_id'] ;
    caseItem.deliver_date= DateTime.parse(json['deliver_date']);
    caseItem.milled= json['milled'];
    caseItem.milled_by= json['milled_by'] as String;
    caseItem.current_status= json['current_status'] as String;
    caseItem.total_status= json['total_status'] as String;
    caseItem.hidden= json['hidden'];
    caseItem.made_by= json['made_by'];
    caseItem.note= json['note'];
    print('doc id');
    caseItem.doctor_id= int.parse(json['doctor_id']);
    caseItem.lab_id= json['lab_id'];
//        service_id: int.parse(json[13]);
//        app_id: int.parse(json[14]);
//        created_at: json[15];
//        deleted_at: json[16];
//        created_by: json[17];
//        updated_at: json[18;

    return caseItem;
  }
}