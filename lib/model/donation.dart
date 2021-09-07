import 'dart:async';
import 'package:bask_app/model/address.dart';
import 'package:flutter/cupertino.dart';
//import 'package:intl/intl.dart';

class Donation with ChangeNotifier {
  String? donationId;
  String donorId;
  String foodName;
  String foodImage;
  String foodType;
  int donationQuantity;
  int remainingQuantity;
  DateTime donatedTime;
  DateTime expiredTime;
  String donorName;
  String donorContact;
  String status;
  Address address;

  Donation({
    this.donationId,
    required this.donorId,
    required this.foodName,
    required this.foodImage,
    required this.foodType,
    required this.remainingQuantity,
    required this.donationQuantity,
    required this.donatedTime,
    required this.expiredTime,
    required this.donorName,
    required this.donorContact,
    required this.status,
    required this.address,
  }) {
    timeLeft = calculateTimeLeft();
  }

  static Donation fromJson(json, documentId) {
    return Donation(
      donationId: documentId,
      donorId: json['donor id'],
      foodName: json['food name'],
      foodImage: json['food image'],
      foodType: json['food type'],
      donationQuantity: json['donation quantity'],
      remainingQuantity: json['remaining quantity'],
      donatedTime: json['donated time'].toDate(),
      expiredTime: json['expired time'].toDate(),
      donorName: json['donor name'],
      donorContact: json['donor contact'],
      status: json['status'],
      address: Address.fromJson(json['address']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['donor id'] = this.donorId;
    data['food name'] = this.foodName;
    data['food image'] = this.foodImage;
    data['food type'] = this.foodType;
    data['donation quantity'] = this.donationQuantity;
    data['remaining quantity'] = this.remainingQuantity;
    data['donated time'] = this.donatedTime;
    data['expired time'] = this.expiredTime;
    data['donor name'] = this.donorName;
    data['donor contact'] = this.donorContact;
    data['status'] = this.status;
    data['address'] = this.address.toJson();
    return data;
  }

  String timeLeft = "00 hr 00 min left";
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  void startTimer() {
    Timer.periodic(Duration(minutes: 1), (_) {
      timeLeft = calculateTimeLeft();
      //notifyListeners();
    });
  }

  String calculateTimeLeft() {
    DateTime dtNow = DateTime.now();
    Duration diff = expiredTime.difference(dtNow);
    int diffSec = diff.inSeconds;
    int diffMin = diff.inMinutes.remainder(60);
    int diffHour = diff.inHours;

    if (diffSec >= 0) {
      return '${twoDigits(diffHour)} hr ${twoDigits(diffMin)} min left';
    } else {
      return '00 hr 00 min left';
    }
  }
}
