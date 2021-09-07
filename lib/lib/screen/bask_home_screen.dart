import 'package:bask_app/model/user.dart';
import 'package:bask_app/screen/add_edit_donation.dart';
import 'package:bask_app/screen/cart_screen.dart';
import 'package:bask_app/screen/my_donation_screen.dart';
import 'package:bask_app/screen/sign_up_and_user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class BaskHomeScreen extends StatefulWidget {
  BaskHomeScreen({Key? key, required this.isNewUser}) : super(key: key);

  @override
  _BaskHomeScreenState createState() => _BaskHomeScreenState();

  final bool isNewUser;
}

class _BaskHomeScreenState extends State<BaskHomeScreen> {
  int currenttab = 0;
  @override
  void initState() {
    super.initState();
    if (widget.isNewUser) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) {
            return SignUpScreen(isThirdpartySignup: true);
          },
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isNewUser
        ? Container(
            //  loading widget
            color: Colors.white70,
            child: Center(
              child: SpinKitSquareCircle(color: Colors.greenAccent),
            ),
          )
        : Scaffold(
            body: IndexedStack(
              index: currenttab,
              children: <Widget>[
                HomeScreen(moveToCartScreen: () {
                  setState(() {
                    currenttab = 1;
                  });
                }),
                CartScreen(),
                MyDonationScreen(),
                Center(child: Text('this is profile screen')),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) {
                    final user = Provider.of<User?>(context, listen: false);
                    return AddEditDonation(
                      currentUser: user,
                    );
                  }),
                );
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
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
                              currenttab = 0;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.home,
                                color:
                                    currenttab == 0 ? Colors.blue : Colors.grey,
                              ),
                              Text(
                                'Home',
                                style: TextStyle(
                                  color: currenttab == 0
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              currenttab = 1;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart,
                                color:
                                    currenttab == 1 ? Colors.blue : Colors.grey,
                              ),
                              Text(
                                'Cart',
                                style: TextStyle(
                                  color: currenttab == 1
                                      ? Colors.blue
                                      : Colors.grey,
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
                              currenttab = 2;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.food_bank,
                                color:
                                    currenttab == 2 ? Colors.blue : Colors.grey,
                              ),
                              Text(
                                'Donation',
                                style: TextStyle(
                                  color: currenttab == 2
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              currenttab = 3;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_circle,
                                color:
                                    currenttab == 3 ? Colors.blue : Colors.grey,
                              ),
                              Text(
                                'Profile',
                                style: TextStyle(
                                  color: currenttab == 3
                                      ? Colors.blue
                                      : Colors.grey,
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
