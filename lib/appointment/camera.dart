class Camera{
  String id;

  Camera({this.id, this.name});

  String name;

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
        id : json['id']==null? "N/A":json['id'],
      name: json['name'] == null ? "N/A" : json['name'],

    );
  }
}