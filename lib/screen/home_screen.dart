import 'package:bask_app/widget/item_grid.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'foods near me',
                style: TextStyle(
                  fontSize: 23,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.filter_list,
                  size: 30,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Expanded(child: ItemGrid())
      ],
    );
  }
}
