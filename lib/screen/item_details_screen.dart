import 'package:bask_app/model/donation.dart';
import 'package:flutter/material.dart';

class ItemDetailsScreen extends StatelessWidget {
  static const outeName = '/Item-Details';

  final Donation item;

  const ItemDetailsScreen({Key? key, required this.item}) : super(key: key);

  //Widget to create deatils about food
  Widget buildFoodDetails(String title, String details) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        Text(
          details,
          style: TextStyle(
              fontSize: 20.0, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  //Widget to create deatils about donor
  Widget buildDonorDeatils(String title, String details) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: Text(
                details,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Food Deatils',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 28.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.blue],
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_basket_sharp,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {},
        child: Container(
          height: 60,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 32.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.blue],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28.0),
              topRight: Radius.circular(28.0),
            ),
          ),
          child: Text(
            'Book Now',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            top: 64.0,
            left: 28.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item.foodName,
                style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.only(
                  right: 30,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Image.network(
                    item.foodImage,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //First column
                    Column(
                      children: [
                        buildFoodDetails(
                            'Quantity', item.remainingQuantity.toString()),
                        SizedBox(height: 20),
                        buildFoodDetails('Food Type', item.foodType),
                      ],
                    ),
                    // 2nd column
                    Column(
                      children: [
                        buildFoodDetails('Upload Time', 'null'),
                        SizedBox(height: 20),
                      ],
                    ),
                    //3rd column
                    Column(
                      children: [
                        buildFoodDetails('Time left', item.timeLeft),
                        SizedBox(height: 20),
                        buildFoodDetails('Status', item.status),
                      ],
                    ),
                  ],
                ),
              ),
              //donor details
              SizedBox(
                height: 20,
              ),
              Text(
                'Donor Details',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 20, top: 10),
                child: Card(
                  elevation: 30,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        buildDonorDeatils('Name :', item.donorName),
                        buildDonorDeatils('Contact :', item.donorContact),
                        buildDonorDeatils('Address :',
                            '${item.address.addressDetails} , ${item.address.area} , ${item.address.city}'),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.0)
            ],
          ),
        ),
      ),
    );
  }
}
