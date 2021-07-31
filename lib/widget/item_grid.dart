import 'package:bask_app/api/food_transaction_api.dart';
import 'package:bask_app/model/food_transaction.dart';
import 'package:bask_app/widget/item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemGrid extends StatelessWidget {
  List<FoodTranscation> loadedFood = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<FoodTranscation>>(
        future: FoodTranscationApi.getAvailableItem(),
        builder: (context, snapshot) {
          final items = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                return buildItemGrid(items!);
              }
          }
        },
      ),
    );
  }

  Widget buildItemGrid(List<FoodTranscation> items) {
    return Container(
      child: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.09,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
        ),
        itemBuilder: (context, index) =>
            ChangeNotifierProvider<FoodTranscation>.value(
                value: items[index], child: ItemCard()),
      ),
    );
  }
}
