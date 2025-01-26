class ElectionResultsModel {
  int? candidateId;
  String? candidateName;
  String? candidateUserId;
  String? candidateProfilePic;
  String? clubName;
  int? clubId;
  int? totalVotes;
  double? votePercentage; // This can now accept both int and double
  int? electionId;

  ElectionResultsModel({
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

  factory ElectionResultsModel.fromJson(Map<String, dynamic> json) {
    return ElectionResultsModel(
      candidateId: json['candidateId'],
      candidateName: json['candidateName'],
      candidateUserId: json['candidateUserId'],
      candidateProfilePic: json['candidateProfilePic'],
      clubName: json['clubName'],
      clubId: json['clubId'],
      totalVotes: json['totalVotes'],
      // Ensure votePercentage is always treated as a double
      votePercentage: (json['votePercentage'] is int)
          ? (json['votePercentage'] as int).toDouble()
          : json['votePercentage']?.toDouble(),
      electionId: json['electionId'],
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
