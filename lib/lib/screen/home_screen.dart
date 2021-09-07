import 'package:bask_app/model/user.dart';
import 'package:bask_app/services/auth.dart';
import 'package:bask_app/widget/badge.dart';
import 'package:bask_app/widget/item_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.moveToCartScreen})
      : super(key: key);

  final VoidCallback moveToCartScreen;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _logout(BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    await auth.signOut();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BASK'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          Consumer<User?>(
            builder: (ctx, user, child) => Badge(
              value: user!.cartItemCount.toString(),
              color: Colors.blue,
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: widget.moveToCartScreen,
              ),
            ),
          ),
          TextButton(
              onPressed: () => _logout(context),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ))
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.blue],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'foods near me',
                  style: TextStyle(
                    fontSize: 23,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(child: ItemGrid())
        ],
      ),
    );
  }
}
