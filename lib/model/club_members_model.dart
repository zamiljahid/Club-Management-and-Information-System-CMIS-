class ClubMembersModel {
  final String? id;
  final String? memberName;
  final String? position;
  final String? contact;
  final String? email;
  final int? electionParticipation;
  final int? eventParticipation;
  final int? messageParticipation;

  ClubMembersModel({
    this.id,
    this.memberName,
    this.position,
    this.contact,
    this.email,
    this.electionParticipation,
    this.eventParticipation,
    this.messageParticipation,
  });

  factory ClubMembersModel.fromJson(Map<String, dynamic> json) {
    return ClubMembersModel(
      id: json['id'] as String?,
      memberName: json['memberName'] as String?,
      position: json['position'] as String?,
      contact: json['contact'] as String?,
      email: json['email'] as String?,
      electionParticipation: json['electionParticipation'] as int?,
      eventParticipation: json['eventParticipation'] as int?,
      messageParticipation: json['messageParticipation'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberName': memberName,
      'position': position,
      'contact': contact,
      'email': email,
      'electionParticipation': electionParticipation,
      'eventParticipation': eventParticipation,
      'messageParticipation': messageParticipation,
    };
  }
}
