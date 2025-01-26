class IsRegisterModel {
  bool? isRegistered;

  IsRegisterModel({this.isRegistered});
  factory IsRegisterModel.fromJson(Map<String, dynamic> json) {
    return IsRegisterModel(
      isRegistered: json['isRegistered'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'isRegistered': isRegistered,
    };
  }
}
