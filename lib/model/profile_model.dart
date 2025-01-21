class UserModel {
  String? userID;
  String? name;
  String? email;
  String? role;
  String? roleId;
  String? contact;
  String? profilePicUrl;
  int? clubId;
  String? clubName;

  UserModel({
    this.userID,
    this.name,
    this.email,
    this.role,
    this.roleId,
    this.contact,
    this.profilePicUrl,
    this.clubId,
    this.clubName,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userID: json['userID'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      roleId: json['roleId'],
      contact: json['contact'],
      profilePicUrl: json['profilePicUrl'],
      clubId: json['clubId'],
      clubName: json['clubName'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'name': name,
      'email': email,
      'role': role,
      'roleId': roleId,
      'contact': contact,
      'profilePicUrl': profilePicUrl,
      'clubId': clubId,
      'clubName': clubName,
    };
  }
}
