class CandidateModel {
  final int? candidateId;
  final String? candidateName;
  final String? candidateUserId;
  final String? candidateProfilePic;
  final String? clubName;
  final int? clubId;
  final int? electionId;

  CandidateModel({
    this.candidateId,
    this.candidateName,
    this.candidateUserId,
    this.candidateProfilePic,
    this.clubName,
    this.clubId,
    this.electionId,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
      candidateId: json['candidateId'] as int?,
      candidateName: json['candidateName'] as String?,
      candidateUserId: json['candidateUserId'] as String?,
      candidateProfilePic: json['candidateProfilePic'] as String?,
      clubName: json['clubName'] as String?,
      clubId: json['clubId'] as int?,
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
      'electionId': electionId,
    };
  }
}
