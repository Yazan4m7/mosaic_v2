class Employee {
  String id;
  String firstName;
  String lastName;
  String permissionIds;
  Employee({this.id, this.firstName, this.lastName, this.permissionIds});

  factory Employee.fromJson(Map<String, dynamic> json) {
    Employee emp = Employee(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      permissionIds: json['permissions_ids'],
    );
    return emp;
  }
}
