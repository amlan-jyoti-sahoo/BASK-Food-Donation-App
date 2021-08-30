import 'package:bask_app/providers/cart.dart' show Cart;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bask_app/widget/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your cart'),
      ),
      body: ListView.builder(
        itemCount: cart.itemCount,
        itemBuilder: (context, index) => CartItemCard(
          cart.items.values.toList()[index].id,
          cart.items.values.toList()[index].title,
          cart.items.values.toList()[index].quantity,
          cart.items.values.toList()[index].address,
          cart.items.values.toList()[index].image,
          cart.items.keys.toList()[index],
        ),
      ),
    );
  }
}
