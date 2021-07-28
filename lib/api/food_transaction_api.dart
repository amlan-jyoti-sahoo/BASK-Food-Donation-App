import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bask_app/model/food_transaction.dart';

class FoodTranscationApi {
  static Future<List<FoodTranscation>> getAvailableItem() async {
    var uri = Uri.parse(
        'http://baskapi.somee.com/api/FoodTransactions/itembystatus?status=available');
    final response = await http.get(uri);
    final body = json.decode(response.body);

    return body.map<FoodTranscation>(FoodTranscation.fromJson).toList();
  }
}
