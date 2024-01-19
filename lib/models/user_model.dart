class Users {
  String uid = "";
  late String fullName;
  late String email;
  late String password;
  String? imageUrl;

  Users({required this.fullName, required this.email, required this.password});

  Users.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    fullName = json["fullName"];
    email = json["email"];
    password = json["password"];
    imageUrl = json["imageUrl"];
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "fullName": fullName,
    "email": email,
    "password": password,
    "imageUrl": imageUrl,
  };

  @override
  bool operator ==(Object other) {
    return other is Users && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}