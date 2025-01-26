class TopClubModel {
  int? clubId;
  String? clubName;
  int? totalElectionParticipation;
  int? totalEventParticipation;
  int? totalMessageParticipation;
  int? totalMembers;
  int? totalPresidents;

  TopClubModel({
    this.clubId,
    this.clubName,
    this.totalElectionParticipation,
    this.totalEventParticipation,
    this.totalMessageParticipation,
    this.totalMembers,
    this.totalPresidents,
  });

  factory TopClubModel.fromJson(Map<String, dynamic> json) {
    return TopClubModel(
      clubId: json['clubId'],
      clubName: json['clubName'],
      totalElectionParticipation: json['totalElectionParticipation'],
      totalEventParticipation: json['totalEventParticipation'],
      totalMessageParticipation: json['totalMessageParticipation'],
      totalMembers: json['totalMembers'],
      totalPresidents: json['totalPresidents'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clubId': clubId,
      'clubName': clubName,
      'totalElectionParticipation': totalElectionParticipation,
      'totalEventParticipation': totalEventParticipation,
      'totalMessageParticipation': totalMessageParticipation,
      'totalMembers': totalMembers,
      'totalPresidents': totalPresidents,
    };
  }
}
