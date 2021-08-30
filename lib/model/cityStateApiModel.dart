class StateModel {
  String stateId;
  String stateName;

  StateModel({required this.stateId, required this.stateName});

  static StateModel fromJson(json) {
    return StateModel(
      stateId: json['iso2'],
      stateName: json['name'],
    );
  }
}

class CityModel {
  int cityId;
  String cityName;

  CityModel({required this.cityId, required this.cityName});

  static CityModel fromJson(json) {
    return CityModel(
      cityId: json['id'],
      cityName: json['name'],
    );
  }
}
