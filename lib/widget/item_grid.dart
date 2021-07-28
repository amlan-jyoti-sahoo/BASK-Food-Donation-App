import 'package:bask_app/api/food_transaction_api.dart';
import 'package:bask_app/model/food_transaction.dart';
import 'package:bask_app/screen/item_details_screen.dart';
import 'package:flutter/material.dart';

class ItemGrid extends StatelessWidget {

   List<FoodTranscation> loadedFood = [];

 void selectItem(BuildContext context,FoodTranscation item) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return Item_Details_Screen(item: item,);
          },
        ),
      );
    }
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
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => selectItem(context,items[index]),
            splashColor: Colors.blue,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: GridTile(
                child: Image.network(
                  items[index].foodImage,
                  fit: BoxFit.cover,
                ),
                footer: GridTileBar(
                  backgroundColor: Colors.black87,
                  leading: Icon(Icons.location_on),
                  title: Text(
                    items[index].donor.district.districtName,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
