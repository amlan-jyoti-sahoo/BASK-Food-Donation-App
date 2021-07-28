import 'package:bask_app/api/food_transaction_api.dart';
import 'package:bask_app/model/food_transaction.dart';
import 'package:flutter/material.dart';

class ItemGrid extends StatelessWidget {
  const ItemGrid({Key? key}) : super(key: key);

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

//   Widget buildUsers(List<FoodTranscation> items) => ListView.builder(
//         physics: BouncingScrollPhysics(),
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           final item = items[index];

//           return ListTile(
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(item.foodImage),
//             ),
//             title: Text(item.foodName),
//             subtitle: Text(item.foodType),
//           );
//         },
//       );
// }

  Widget buildItemGrid(List<FoodTranscation> items) {
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
        ),
        itemBuilder: (context, index) {
          return GridTile(
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
          );
        });
  }
}
