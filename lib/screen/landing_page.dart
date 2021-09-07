import 'package:bask_app/screen/loading_user_data.dart';
import 'package:bask_app/screen/log_in_screen.dart';
import 'package:bask_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Widget loadingWidget() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user == null) {
              return LogInPage();
            } else {
              return LoadUserData();
            }
          }
          return loadingWidget();
        });
  }
}
