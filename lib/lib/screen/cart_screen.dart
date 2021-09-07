import 'package:bask_app/model/cart.dart';
import 'package:bask_app/services/auth.dart';
import 'package:bask_app/services/firestoreApi.dart';
import 'package:bask_app/widget/cart_item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreApi>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My cart'),
      ),
      body: StreamBuilder<List<Cart>>(
        stream: database.getMyCartItemsStream(userid: auth.currentuser!.uid),
        builder: (context, snapshot) {
          final carts = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                if (carts!.length == 0) {
                  return Center(
                    child: Text('Your cart is currently empty!'),
                  );
                } else {
                  return buildCartList(carts);
                }
              }
          }
        },
      ),
    );
  }

  Widget buildCartList(List<Cart> carts) {
    return ListView.builder(
      itemCount: carts.length,
      itemBuilder: (context, index) => CartItemCard(cart: carts[index]),
    );
  }
}
