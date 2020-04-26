class Invoice {
  String id;
  String status;
  String amount;

  @override
  String toString() {
    return 'Invoice{id: $id, status: $status, amount: $amount, orderId: $orderId, doctorId: $doctorId}';
  }

  String orderId;
  String doctorId;


  Invoice({this.id, this.status, this.amount, this.orderId, this.doctorId});


  factory Invoice.fromJson(Map<String, dynamic> json) {

    return Invoice(
      id : json['id'],
      orderId : json['order_id'],
      status : json['status'],
      amount : json['amount'],
      doctorId : json['doctor_id'],);
  }


//  String toString() {
//    // TODO: implement toString
//    return this.patientName + this.doctorId;
//  }
}