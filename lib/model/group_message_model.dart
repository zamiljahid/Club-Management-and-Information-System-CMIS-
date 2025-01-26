class GroupMessageModel {
  int? messageId;
  String? userId;
  int? clubId;
  String? messageText;
  DateTime? timestamp;

  GroupMessageModel({
    this.messageId,
    this.userId,
    this.clubId,
    this.messageText,
    this.timestamp,
  });

  factory GroupMessageModel.fromJson(Map<String, dynamic> json) {
    return GroupMessageModel(
      messageId: json['messageId'] as int?,
      userId: json['userId'] as String?,
      clubId: json['clubId'] as int?,
      messageText: json['messageText'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'userId': userId,
      'clubId': clubId,
      'messageText': messageText,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
