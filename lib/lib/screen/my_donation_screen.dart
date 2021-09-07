import 'package:bask_app/model/donation.dart';
import 'package:bask_app/services/auth.dart';
import 'package:bask_app/services/firestoreApi.dart';
import 'package:bask_app/widget/donate_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class MyDonationScreen extends StatefulWidget {
  const MyDonationScreen({Key? key}) : super(key: key);

  @override
  _MyDonationScreenState createState() => _MyDonationScreenState();
}

class _MyDonationScreenState extends State<MyDonationScreen> {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreApi>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My cart'),
      ),
      body: StreamBuilder<List<Donation>>(
        stream: database.getMyDonation(uid: auth.currentuser!.uid),
        builder: (context, snapshot) {
          final myDonations = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: SpinKitFadingFour(
                  color: Colors.greenAccent,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                if (myDonations!.length == 0) {
                  return Center(
                    child: Text('Your haven\'t doneted any thing yet'),
                  );
                } else {
                  return builDonationList(myDonations);
                }
              }
          }
        },
      ),
    );
  }

  Widget builDonationList(List<Donation> myDonations) {
    return ListView.builder(
      itemCount: myDonations.length,
      itemBuilder: (context, index) =>
          DonateProductItem(donation: myDonations[index]),
    );
  }
}
