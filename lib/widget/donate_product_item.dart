import 'package:bask_app/providers/donate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonateProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageurl;
  final String address;

  const DonateProductItem( this.id ,this.title,  this.imageurl, this.address);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(address),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageurl),
      ),
      trailing:
       Container(
        width: 50,
        child: Row(children: [
          // IconButton(onPressed: () {
          //   Navigator.of(context).pushNamed(EditDonateItemScreen.routeName, arguments: id);
          // }, icon: Icon(Icons.edit),color: Colors.black,),
          IconButton(onPressed: () {
            Provider.of<Donate>(context, listen: false).deleteItem(id);
          }, icon: Icon(Icons.delete),color: Colors.red,),
        ],),
      ),
    );
  }
}
