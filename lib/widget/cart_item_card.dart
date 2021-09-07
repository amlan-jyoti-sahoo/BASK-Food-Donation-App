import 'package:bask_app/model/cart.dart';
import 'package:bask_app/services/auth.dart';
import 'package:bask_app/services/firestoreApi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatelessWidget {
  final Cart cart;
  CartItemCard({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cart.cartItemId),
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item form the cart?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        final db = Provider.of<FirestoreApi>(context, listen: false);
        final auth = Provider.of<Auth>(context, listen: false);
        await db.removeCartItem(cart, auth.currentuser!.uid, context);
      },
      child: Card(
        elevation: 10,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(2),
          child: ListTile(
            leading: Container(
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  cart.item.foodImage,
                ),
              ),
            ),
            title: Text(
              cart.item.foodName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            subtitle:
                Text('${cart.item.address.area},${cart.item.address.city}'),
            trailing: Text('${cart.count} x'),
          ),
        ),
      ),
    );
  }
}
