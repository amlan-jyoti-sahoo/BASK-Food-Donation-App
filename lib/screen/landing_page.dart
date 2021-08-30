import 'package:bask_app/screen/bask_home_screen.dart';
import 'package:bask_app/screen/log_in_screen.dart';
import 'package:bask_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

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
              String provider = user.providerData[0].providerId;

              if (provider == 'google.com' || provider == 'facebook.com') {
                if (user.displayName != "BASK USER") {
                  return BaskHomeScreen(isNewUser: true);
                } else {
                  return BaskHomeScreen(
                    isNewUser: false,
                  );
                }
              } else {
                return BaskHomeScreen(
                  isNewUser: false,
                );
              }
            }
          }
          return loadingWidget();
        });
  }
}
