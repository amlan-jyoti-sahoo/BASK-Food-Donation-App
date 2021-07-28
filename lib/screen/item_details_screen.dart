import 'package:bask_app/model/food_transaction.dart';
import 'package:flutter/material.dart';

class Item_Details_Screen extends StatelessWidget {
  static const outeName = '/Item-Details';

  
 final FoodTranscation item;

  const Item_Details_Screen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                width: double.infinity,
                padding: EdgeInsets.all(30),
                child: Image.network(item.foodImage,fit: BoxFit.fill,),
                
              ),
              Text('Food Name: ${item.foodName}'),
              Text('Quantity: ${item.foodQuantity}'),
              Text('Upload time: ${item.createdTime}'),
              Text('Time left: ${null}'),
              Text('Food type: ${item.foodType}'),
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
              Text('Donor name: ${item.donor.name}'),
              Text('contact: ${item.donor.phoneNumber}'),
              Text('Pickup Address: ${item.donor.addressDetails}'),
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
      ),
    );
  }
}
