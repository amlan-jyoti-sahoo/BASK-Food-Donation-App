import 'package:bask_app/model/District.dart';

class User {
  String uid;
  String name;
  String roleId;
  String phoneNumber;
  String districtId;
  String area;
  String addressDetails;
  String email;
  District district;

  User({
    required this.uid,
    required this.name,
    required this.roleId,
    required this.phoneNumber,
    required this.districtId,
    required this.area,
    required this.addressDetails,
    required this.email,
    required this.district,
  });

  static User fromJson(json) {
    return User(
      uid: json['uid'],
      name: json['name'],
      roleId: json['roleId'],
      phoneNumber: json['phoneNumber'],
      districtId: json['districtId'],
      area: json['area'],
      addressDetails: json['addressDetails'],
      email: json['email'],
      district: District.fromJson(json['district']),
    );
  }
}
