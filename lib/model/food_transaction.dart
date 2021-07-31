import 'dart:async';

import 'package:bask_app/model/status.dart';
import 'package:bask_app/model/user.dart';
import 'package:flutter/cupertino.dart';

class FoodTranscation with ChangeNotifier {
  int transactionId;
  String foodName;
  String foodImage;
  int foodQuantity;
  DateTime createdTime;
  int availableDuration;
  String foodType;
  int? rating;
  String? receiverReview;
  DateTime? reseivedTime;
  String? securityCode;
  User donor;
  User? receiver;
  Status status;

  FoodTranscation(
      {required this.transactionId,
      required this.foodName,
      required this.foodImage,
      required this.foodQuantity,
      required this.createdTime,
      required this.availableDuration,
      required this.foodType,
      this.rating,
      this.receiverReview,
      this.reseivedTime,
      this.securityCode,
      required this.donor,
      this.receiver,
      required this.status});

  static FoodTranscation fromJson(json) {
    return FoodTranscation(
        transactionId: json['transactionId'],
        foodName: json['foodName'],
        foodImage: json['foodImage'],
        foodQuantity: json['foodQuantity'],
        createdTime: DateTime.parse(json['createdTime']),
        availableDuration: json['availableDuration'],
        foodType: json['foodType'],
        donor: User.fromJson(json['donor']),
        status: Status.fromJson(json['status']),
        rating: json['rating'],
        receiverReview: json['receiverReview'],
        reseivedTime: json['reseivedTime'] != null
            ? DateTime.parse(json['reseivedTime'])
            : null,
        securityCode: json['securityCode'],
        receiver: json['receiver'] != null
            ? User.fromJson(json['reseivedTime'])
            : null);
  }

  String timeLeft = '00:00:00';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (_) {
      DateTime dtNow = DateTime.now();
      DateTime dtExp = createdTime.add(Duration(hours: availableDuration));
      Duration diff = dtExp.difference(dtNow);
      int diffSec = diff.inSeconds.remainder(60);
      int diffMin = diff.inMinutes.remainder(60);
      int diffHour = diff.inHours;

      if (diffSec >= 0) {
        timeLeft =
            '${twoDigits(diffHour)}:${twoDigits(diffMin)}:${twoDigits(diffSec)}';
      } else {
        timeLeft = '00:00:00';
      }
      notifyListeners();
    });
  }
}
