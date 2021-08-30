class User {
  String firstName;
  String lastName;
  String email;
  String? password;
  String role;
  int ratingCount;
  int avgRating;
  int donationCount;
  String phoneNumber;
  String defaultAddressId;
  DateTime joinedOn;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    required this.role,
    required this.phoneNumber,
    required this.ratingCount,
    required this.avgRating,
    required this.donationCount,
    required this.defaultAddressId,
    required this.joinedOn,
  });

  static User fromJson(json) {
    return User(
        firstName: json['first name'],
        lastName: json['last name'],
        email: json['email'],
        role: json['role'],
        phoneNumber: json['phone'],
        ratingCount: json['rating count'],
        avgRating: json['avg rating'],
        donationCount: json['donation count'],
        defaultAddressId: json['default address id'],
        joinedOn: json['joined on']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first name'] = this.firstName;
    data['last name'] = this.lastName;
    data['email'] = this.email;
    data['role'] = this.role;
    data['phone'] = this.phoneNumber;
    data['rating count'] = this.ratingCount;
    data['avg rating'] = this.avgRating;
    data['avg rating'] = this.avgRating;
    data['donation count'] = this.donationCount;
    data['joined on'] = this.joinedOn;
    return data;
  }
}
