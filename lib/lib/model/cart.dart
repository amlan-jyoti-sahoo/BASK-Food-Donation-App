import 'package:bask_app/model/donation.dart';

class Cart {
  Cart({
    this.cartItemId,
    required this.count,
    required this.item,
    this.donatonid,
  });

  String? cartItemId;
  int count;
  String? donatonid;
  Donation item;

  static Cart fromJson(json, id) {
    return Cart(
      cartItemId: id,
      count: json['count'],
      item: Donation.fromJson(json['item'], json['donatonId']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['item'] = this.item.toJson();
    data['donationId'] = this.donatonid;
    return data;
  }
}
