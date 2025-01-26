class ElectedPresidentModel {
  int? candidateId;
  String? candidateName;
  String? candidateUserId;
  String? candidateProfilePic;
  String? clubName;
  int? clubId;
  int? totalVotes;
  double? votePercentage;
  int? electionId;

  ElectedPresidentModel({
    this.candidateId,
    this.candidateName,
    this.candidateUserId,
    this.candidateProfilePic,
    this.clubName,
    this.clubId,
    this.totalVotes,
    this.votePercentage,
    this.electionId,
  });

  factory ElectedPresidentModel.fromJson(Map<String, dynamic> json) {
    return ElectedPresidentModel(
      candidateId: json['candidateId'] as int?,
      candidateName: json['candidateName'] as String?,
      candidateUserId: json['candidateUserId'] as String?,
      candidateProfilePic: json['candidateProfilePic'] as String?,
      clubName: json['clubName'] as String?,
      clubId: json['clubId'] as int?,
      totalVotes: json['totalVotes'] as int?,
      votePercentage: json['votePercentage'] != null
          ? (json['votePercentage'] as num).toDouble()
          : null,
      electionId: json['electionId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'candidateId': candidateId,
      'candidateName': candidateName,
      'candidateUserId': candidateUserId,
      'candidateProfilePic': candidateProfilePic,
      'clubName': clubName,
      'clubId': clubId,
      'totalVotes': totalVotes,
      'votePercentage': votePercentage,
      'electionId': electionId,
    };
  }
}
