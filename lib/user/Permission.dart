class Permission {
  Permission({ this.permissionId});
  int permissionId;
  factory Permission.fromJson(Map<String, dynamic> json) {

    return Permission(
        permissionId: int.parse(json['permission_id']));

  }
  String toString() {
    return permissionId.toString();
}
}