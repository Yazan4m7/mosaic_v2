class Case {
  String id;
  String orderId;
  String patientName;
  String note;
  String deliverDate;
  String milled;
  String milledBy;
  String currentStatus;
  String totalStatus;
  String hidden;
  String madeBy;
  String doctorId;
  String labId;
  String serviceId;
  String appId;
  String createdBy;
  String deletedAt;
  String createdAt;
  String updatedAt;

  Case(
      {this.id,
        this.orderId,
        this.patientName,
        this.note,
        this.deliverDate,
        this.milled,
        this.milledBy,
        this.currentStatus,
        this.totalStatus,
        this.hidden,
        this.madeBy,
        this.doctorId,
        this.labId,
        this.serviceId,
        this.appId,
        this.createdBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  factory Case.fromJson(Map<String, dynamic> json) {

    return Case(
    id : json['id'],
    orderId : json['order_id'],
    patientName : json['patient_name'],
    note : json['note'],
    deliverDate : json['deliver_date'],
    milled : json['milled'],
    milledBy : json['milled_by'],
    currentStatus : json['current_status'],
    totalStatus : json['total_status'],
    hidden : json['hidden'],
    madeBy : json['made_by'],
    doctorId : json['doctor_id'],
    labId : json['lab_id'],
    serviceId : json['service_id'],
    appId : json['app_id'],
    createdBy : json['created_by'],
    deletedAt : json['deleted_at'],
    createdAt : json['created_at'],
    updatedAt :json['updated_at'],);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['patient_name'] = this.patientName;
    data['note'] = this.note;
    data['deliver_date'] = this.deliverDate;
    data['milled'] = this.milled;
    data['milled_by'] = this.milledBy;
    data['current_status'] = this.currentStatus;
    data['total_status'] = this.totalStatus;
    data['hidden'] = this.hidden;
    data['made_by'] = this.madeBy;
    data['doctor_id'] = this.doctorId;
    data['lab_id'] = this.labId;
    data['service_id'] = this.serviceId;
    data['app_id'] = this.appId;
    data['created_by'] = this.createdBy;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

//  String toString() {
//    // TODO: implement toString
//    return this.patientName + this.doctorId;
//  }
}