import 'package:bask_app/model/food_transaction.dart';
import 'package:bask_app/screen/item_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({Key? key}) : super(key: key);
  void selectItem(BuildContext context, FoodTranscation item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return ItemDetailsScreen(
            item: item,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var item = Provider.of<FoodTranscation>(context, listen: false);
    item.startTimer();
    return InkWell(
      onTap: () => selectItem(context, item),
      splashColor: Colors.blue,
      borderRadius: BorderRadius.circular(15),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Card(
          elevation: 10,
          child: Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: CustomShape(),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green, Colors.blue],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                      height: 100,
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 10,
                      ),
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundImage: NetworkImage(
                          item.foodImage,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.shopping_cart_outlined),
                  ),
                ],
              ),
              Card(
                margin: EdgeInsets.all(5),
                elevation: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.foodName,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),
                    ),
                    Text(
                      '${item.donor.area}, ${item.donor.district.districtName}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Consumer<FoodTranscation>(
                      builder: (ctx, item, child) => Text(
                        'Time left: ${item.timeLeft}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          
        ),
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  final height = 100;
  final width = 200;
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
