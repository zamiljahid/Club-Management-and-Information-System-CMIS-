class EventsModel {
  int? eventId;
  String? eventName;
  String? eventDescription;
  String? startDate;
  String? endDate;
  String? picUrl;
  String? status;
  int? clubId;
  String? clubName;

  EventsModel({
    this.eventId,
    this.eventName,
    this.eventDescription,
    this.startDate,
    this.endDate,
    this.picUrl,
    this.status,
    this.clubId,
    this.clubName,
  });
  factory EventsModel.fromJson(Map<String, dynamic> json) {
    return EventsModel(
      eventId: json['eventId'] as int?,
      eventName: json['eventName'] as String?,
      eventDescription: json['eventDescription'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      picUrl: json['picUrl'] as String?,
      status: json['status'] as String?,
      clubId: json['clubId'] as int?,
      clubName: json['clubName'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'eventDescription': eventDescription,
      'startDate': startDate,
      'endDate': endDate,
      'picUrl': picUrl,
      'status': status,
      'clubId': clubId,
      'clubName': clubName,
    };
  }
}
