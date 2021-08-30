import 'package:bask_app/providers/cart.dart';
import 'package:bask_app/providers/donate.dart';
import 'package:bask_app/screen/cart_screen.dart';
import 'package:bask_app/screen/donate_item_screen.dart';
import 'package:bask_app/screen/edit_donate_item_screen.dart';
import 'package:bask_app/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//my name is santanu kumar
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Donate(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bask',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SpalshScreen(),
        // BaskHomeScreen(),
        routes: {
            CartScreen.routeName: (ctx) =>  CartScreen(),
            DonateItemScreen.routeName: (ctx) => DonateItemScreen(),
            EditDonateItemScreen.routeName: (ctx) => EditDonateItemScreen(),
        },
      ),
    );
  }
}
