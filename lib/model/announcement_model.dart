class AnnouncementModel {
  int? announcementId;
  String? announcementById;
  int? clubId;
  String? userId;
  DateTime? createdAt;
  String? announcementText;
  String? announcementTitle;

  AnnouncementModel({
    this.announcementId,
    this.announcementById,
    this.clubId,
    this.userId,
    this.createdAt,
    this.announcementText,
    this.announcementTitle,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      announcementId: json['announcementId'] as int?,
      announcementById: json['announcementById'] as String?,
      clubId: json['clubId'] as int?,
      userId: json['userId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      announcementText: json['announcementText'] as String?,
      announcementTitle: json['announcementTitle'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'announcementId': announcementId,
      'announcementById': announcementById,
      'clubId': clubId,
      'userId': userId,
      'createdAt': createdAt?.toIso8601String(),
      'announcementText': announcementText,
      'announcementTitle': announcementTitle,
    };
  }
}
