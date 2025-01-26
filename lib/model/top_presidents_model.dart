class TopPresidentsModel {
  String? id;
  String? memberName;
  String? profilePic;
  String? position;
  String? contact;
  String? email;
  int? electionParticipation;
  int? eventParticipation;
  int? messageParticipation;
  String? clubNames;  // Added the clubNames field

  TopPresidentsModel({
    this.id,
    this.memberName,
    this.profilePic,
    this.position,
    this.contact,
    this.email,
    this.electionParticipation,
    this.eventParticipation,
    this.messageParticipation,
    this.clubNames,
  });

  factory TopPresidentsModel.fromJson(Map<String, dynamic> json) {
    return TopPresidentsModel(
      id: json['id'],
      memberName: json['memberName'],
      profilePic: json['profilePic'],
      position: json['position'],
      contact: json['contact'],
      email: json['email'],
      electionParticipation: json['electionParticipation'],
      eventParticipation: json['eventParticipation'],
      messageParticipation: json['messageParticipation'],
      clubNames: json['clubNames'],  // Parse clubNames from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberName': memberName,
      'profilePic': profilePic,
      'position': position,
      'contact': contact,
      'email': email,
      'electionParticipation': electionParticipation,
      'eventParticipation': eventParticipation,
      'messageParticipation': messageParticipation,
      'clubNames': clubNames,  // Include clubNames in the JSON map
    };
  }
}
