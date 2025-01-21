class LoginModelClass {
  String? token;
  DateTime? issueDate;
  DateTime? expiryDate;

  LoginModelClass({this.token, this.issueDate, this.expiryDate});

  factory LoginModelClass.fromJson(Map<String, dynamic> json) {
    return LoginModelClass(
      token: json['token'] as String?,
      issueDate: json['issueDate'] != null
          ? DateTime.parse(json['issueDate'] as String)
          : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'issueDate': issueDate?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
    };
  }
}
