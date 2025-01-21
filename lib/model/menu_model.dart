class MenuModelClass {
  int? menuId;
  String? menuName;

  MenuModelClass({this.menuId, this.menuName});
  factory MenuModelClass.fromJson(Map<String, dynamic> json) {
    return MenuModelClass(
      menuId: json['menu_id'],
      menuName: json['menu_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu_id': menuId,
      'menu_name': menuName,
    };
  }
}
