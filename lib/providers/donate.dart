import 'dart:convert';
import 'package:bask_app/model/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DonateItem {
  final String id;
  final String title;
  final int quantity;
  final String address;
  final String imageUrl;

  DonateItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.address,
    required this.imageUrl,
  });
}

class Donate with ChangeNotifier {
  List<DonateItem> _items = [];

  List<DonateItem> get items {
    return [..._items];
  }

  DonateItem findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetDonateItems() async {
    final url = Uri.parse(
        'https://bask-server-default-rtdb.firebaseio.com/donates.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<DonateItem> loadedItems = [];
      extractedData.forEach((itemId, itemData) {
        loadedItems.add(DonateItem(
          id: itemId,
          title: itemData['title'],
          quantity: itemData['quantity'],
          address: itemData['address'],
          imageUrl: itemData['imageUrl'],
        ));
      });
      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

//Here we implement Future method. we can also use await & async and try catch  method for error handling
  Future<void> addItem(DonateItem donate) {
    final url = Uri.parse(
        'https://bask-server-default-rtdb.firebaseio.com/donates.json');
    return http
        .post(
      url,
      body: json.encode({
        'title': donate.title,
        'address': donate.address,
        'imageUrl': donate.imageUrl,
        'quantity': donate.quantity,
      }),
    )
        .then((response) {
      final newItem = DonateItem(
        id: json.decode(response.body)['name'],
        title: donate.title,
        quantity: donate.quantity,
        address: donate.address,
        imageUrl: donate.imageUrl,
      );
      _items.add(newItem);
      notifyListeners();
    }).catchError((error) {
      //  print(error);
      throw error;
    });
  }


  void deleteItem(String id) {
    final url = Uri.parse(
        'https://bask-server-default-rtdb.firebaseio.com/donates/$id.json');
       final existingItemIndex = _items.indexWhere((item) => item.id == id);
       var existingItem = _items[existingItemIndex];
    _items.removeAt(existingItemIndex);
    notifyListeners();
    http.delete(url).then((response) {
      if(response.statusCode >=400){
        throw HttpException('Could not delete product. Try again!');
      }
      _items.removeWhere((item) => item.id == id);
    }).catchError((_) {
    _items.insert(existingItemIndex, existingItem);
    notifyListeners();
    });
        
  }

  // void deleteItem(String id) {
  //   final url = Uri.parse(
  //       'https://bask-server-default-rtdb.firebaseio.com/donates/$id.json');
  //   _items.removeWhere((element) => element.id == id);
  //   notifyListeners();
  // }
}
