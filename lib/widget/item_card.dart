import 'package:bask_app/model/food_transaction.dart';
import 'package:bask_app/screen/item_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({Key? key}) : super(key: key);
  void selectItem(BuildContext context, FoodTranscation item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return ItemDetailsScreen(
            item: item,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var item = Provider.of<FoodTranscation>(context, listen: false);
    item.startTimer();
    return InkWell(
      onTap: () => selectItem(context, item),
      splashColor: Colors.blue,
      borderRadius: BorderRadius.circular(15),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: GridTile(
            child: Image.network(
              item.foodImage,
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: Icon(Icons.timer),
              title: Consumer<FoodTranscation>(
                builder: (ctx, item, child) => Text(
                  item.timeLeft,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
