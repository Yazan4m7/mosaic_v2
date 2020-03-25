class Doctor {
  String id;
  String name;
  String balance;

  Doctor(
      {this.id,this.name,this.balance});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id : json['id']==null? "N/A":json['id'],
      name : json['name']==null? "N/A":json['name'],
      balance : json['balance']==null? "N/A":json['balance']);
  }
}