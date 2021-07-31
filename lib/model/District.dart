class District {
  String districtId;
  String districtName;

  District({required this.districtId, required this.districtName});

  static District fromJson(json) {
    return District(
      districtId: json['districtId'],
      districtName: json['districtName'],
    );
  }
}
