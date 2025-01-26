class RegisterMemberMessageModel {
  String? message;

  RegisterMemberMessageModel({this.message});

  factory RegisterMemberMessageModel.fromJson(Map<String, dynamic> json) {
    return RegisterMemberMessageModel(
      message: json['message'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
