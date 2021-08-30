import 'package:bask_app/providers/cart.dart';
import 'package:bask_app/screen/cart_screen.dart';
import 'package:bask_app/screen/donate_item_screen.dart';
import 'package:bask_app/screen/edit_donate_item_screen.dart';
import 'package:bask_app/widget/badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class BaskHomeScreen extends StatefulWidget {
  @override
  _BaskHomeScreenState createState() => _BaskHomeScreenState();
}

class _BaskHomeScreenState extends State<BaskHomeScreen> {
  int currenttab = 0;
  
  

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('BASK'),
      //   leading: IconButton(
      //     icon: Icon(Icons.menu),
      //     onPressed: () {},
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.notifications_none),
      //       onPressed: () {},
      //     ),
      //     Consumer<Cart>(
      //       builder: (_, cart, ch) => Badge(
      //         value: cart.itemCount.toString(),
      //         color: Colors.blue,
      //         child: IconButton(
      //           icon: Icon(Icons.shopping_cart),
      //           onPressed: () {
      //             Navigator.of(context).pushNamed(CartScreen.routeName);
      //           },
      //         ),
      //       ),
      //     ),
      //   ],
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //         colors: [Colors.green, Colors.blue],
      //         begin: Alignment.topRight,
      //         end: Alignment.bottomLeft,
      //       ),
      //     ),
      //   ),
      // ),

      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(EditDonateItemScreen.routeName);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = HomeScreen();
                        currenttab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: currenttab == 0 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: currenttab == 0 ? Colors.blue : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = CartScreen();
                        currenttab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: currenttab == 1 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Cart',
                          style: TextStyle(
                            color: currenttab == 1 ? Colors.blue : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = DonateItemScreen();
                        currenttab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.food_bank,
                          color: currenttab == 2 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Donation',
                          style: TextStyle(
                            color: currenttab == 2 ? Colors.blue : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Text('4');
                        currenttab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: currenttab == 3 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: currenttab == 3 ? Colors.blue : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}










      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: currentIndex,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.lightGreen,
      //   selectedItemColor: Colors.white,
      //   unselectedItemColor: Colors.white70,
      //   selectedFontSize: 16,
      //   showUnselectedLabels: false,
      //   onTap: (index) => setState(() => currentIndex = index),
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //       backgroundColor: Colors.blue,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.shopping_cart,),
      //       label: 'Cart',
      //       backgroundColor: Colors.blue,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.add_circle_outline,
      //         size: 30,
      //       ),
      //       label: 'donate',
      //       backgroundColor: Colors.blue,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.food_bank,),
      //       label: 'donation',
      //       backgroundColor: Colors.blue,

      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle),
      //       label: 'Profile',
      //       backgroundColor: Colors.blue,
      //     )
      //   ],
      // ),
      // body: IndexedStack(
      //   index: currentIndex,
      //   children: screens,
      // ),

