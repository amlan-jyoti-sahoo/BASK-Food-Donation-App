import 'package:bask_app/screen/sign_up_and_user_detail_screen.dart';
import 'package:bask_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class BaskHomeScreen extends StatefulWidget {
  const BaskHomeScreen({Key? key, required this.isNewUser}) : super(key: key);

  @override
  _BaskHomeScreenState createState() => _BaskHomeScreenState();

  final bool isNewUser;
}

class _BaskHomeScreenState extends State<BaskHomeScreen> {
  int currentIndex = 0;
  final screens = [
    HomeScreen(),
    Container(
      child: Center(
        child: Text('cart'),
      ),
    ),
    Container(
      child: Center(
        child: Text('new donation'),
      ),
    ),
    Container(
      child: Center(
        child: Text('my donation'),
      ),
    ),
    Container(
      child: Center(
        child: Text('profile'),
      ),
    ),
  ];

  void _logout() async {
    final auth = Provider.of<Auth>(context, listen: false);
    await auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.isNewUser) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) {
            return SignUpScreen(isThirdpartySignup: true);
          },
        ));
      }
    });
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
          TextButton(
              onPressed: _logout,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.lightGreen,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedFontSize: 16,
        showUnselectedLabels: false,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            label: 'Cart',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
              size: 30,
            ),
            label: 'donate',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'donation',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            backgroundColor: Colors.blue,
          )
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
    );
  }
}
