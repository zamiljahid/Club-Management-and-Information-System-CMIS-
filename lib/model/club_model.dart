class ClubModel {
  int? clubId;
  String? clubName;
  String? clubDescription;
  String? clubLogoUrl;
  List<EventModel>? events;

  ClubModel({
    this.clubId,
    this.clubName,
    this.clubDescription,
    this.clubLogoUrl,
    this.events,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return ClubModel(
      clubId: json['clubId'],
      clubName: json['clubName'],
      clubDescription: json['clubDescription'],
      clubLogoUrl: json['clubLogoUrl'],
      events: (json['events'] as List?)
          ?.map((e) => EventModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clubId': clubId,
      'clubName': clubName,
      'clubDescription': clubDescription,
      'clubLogoUrl': clubLogoUrl,
      'events': events?.map((e) => e.toJson()).toList(),
    };
  }
}

class EventModel {
  int? eventId;
  String? eventName;
  String? eventDescription;
  String? startDate;
  String? endDate;
  String? picUrl;
  String? status;
  int? clubId;
  String? clubName;

  EventModel({
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

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['eventId'],
      eventName: json['eventName'],
      eventDescription: json['eventDescription'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      picUrl: json['picUrl'],
      status: json['status'],
      clubId: json['clubId'],
      clubName: json['clubName'],
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
