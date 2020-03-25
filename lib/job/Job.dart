class Job {
  String unitNum;
  String type;
  String color;
  String style;
  String materialId;
  String orderId;

  Job({this.unitNum, this.type, this.color, this.style,this.materialId,this.orderId});

  factory Job.fromJson(Map<String, dynamic> json) {
    Job job = Job(
      unitNum: json['unit_num'],
      type: json['type'],
      color: json['color'],
      style: json['style'],
      materialId: json['material_id'],
      orderId: json['order_id'],
    );
    return job;
  }
}
