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
                        height: findCardHeight(context) * 0.55),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 10,
                      ),
                      child: CircleAvatar(
                        radius: (findCardHeight(context) * 0.55 - 15) / 2,
                        backgroundImage: NetworkImage(
                          item.foodImage,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        size: findCardHeight(context) * 0.15,
                      )),
                ],
              ),
              Card(
                margin: EdgeInsets.all(5),
                elevation: 10,
                child: SizedBox(
                  height: findCardHeight(context) * 0.3,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.foodName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.green,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                  '${item.donor.area}, ${item.donor.district.districtName}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.brown)),
                            ],
                          ),
                          Consumer<FoodTranscation>(
                            builder: (ctx, item, child) => Text(
                              '${item.timeLeft} left',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.blue,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double findCardHeight(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWith = (screenWidth - 35) / 2;
    double cardHeight = cardWith / 1.1;
    return cardHeight;
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, 0);
    path.quadraticBezierTo(width / 2, height, width, 0);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
