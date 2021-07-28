import 'package:bask_app/model/food_transaction.dart';
import 'package:flutter/material.dart';

class Item_Details_Screen extends StatelessWidget {
  static const outeName = '/Item-Details';

  

  // final String foodName;
  // final String quantity;
  // final String uploadTime;
  // final String timeLeft;
  // final String foodType;
  // final String donorName;
  // final String contact;
  // final String pickupAddress;

  // Item_Details_Screen(
  //   this.foodName,
  //   this.quantity,
  //   this.uploadTime,
  //   this.timeLeft,
  //   this.foodType,
  //   this.donorName,
  //   this.contact,
  //   this.pickupAddress
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Food Details:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Container(
              height: 300,
              padding: EdgeInsets.all(30),
              child: Image.network('null'),
            ),
            Text('Food Name: ${null}'),
            Text('Quantity: ${null}'),
            Text('Upload time: ${null}'),
            Text('Time left: ${null}'),
            Text('Food type: ${null}'),
            SizedBox(
              height: 20,
            ),
            Text(
              'Donor details:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Text('Donor name: ${null}'),
            Text('contact: ${null}'),
            Text('Pickup Address: ${null}'),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: new SizedBox(
                width: double.infinity,
                height: 50.0,
                child: RaisedButton(
                  child: Text('Book Now'),
                  onPressed: () {},
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
