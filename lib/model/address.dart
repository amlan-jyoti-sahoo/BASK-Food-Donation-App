class Address {
  Address({
    required this.addressDetails,
    required this.area,
    required this.pinCode,
    required this.city,
    required this.state,
  });
  final addressDetails;
  final area;
  final pinCode;
  final city;
  final state;

  static Address fromJson(json) {
    return Address(
      addressDetails: json['address details'],
      area: json['area'],
      pinCode: json['pin code'],
      city: json['city'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address details'] = this.addressDetails;
    data['area'] = this.area;
    data['pin code'] = this.pinCode;
    data['city'] = this.city;
    data['state'] = this.state;
    return data;
  }
}
