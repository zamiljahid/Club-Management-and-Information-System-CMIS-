class CheckVoterExists {
  final bool? exists;

  CheckVoterExists({this.exists});

  factory CheckVoterExists.fromJson(Map<String, dynamic> json) {
    return CheckVoterExists(
      exists: json['exists'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exists': exists,
    };
  }
}
