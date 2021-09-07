import 'package:bask_app/model/donation.dart';
import 'package:bask_app/services/firestoreApi.dart';
import 'package:bask_app/widget/item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreApi>(context, listen: false);
    return Scaffold(
      body: StreamBuilder<List<Donation>>(
        stream: database.getDonationStream(),
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

  Widget buildItemGrid(List<Donation> items) {
    return Container(
      child: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
        ),
        itemBuilder: (context, index) => ChangeNotifierProvider<Donation>.value(
            value: items[index], child: ItemCard()),
      ),
    );
  }
}
