import 'package:bask_app/model/address.dart';
import 'package:bask_app/model/donation.dart';
import 'package:bask_app/model/user.dart';
import 'package:bask_app/services/auth.dart';
import 'package:bask_app/services/firestoreApi.dart';
import 'package:bask_app/widget/alret_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AddEditDonation extends StatefulWidget {
  const AddEditDonation(
      {Key? key, this.currentUser, this.isEditMode = false, this.donation})
      : super(key: key);

  final User? currentUser;
  final bool? isEditMode;
  final Donation? donation;

  @override
  _AddEditDonationState createState() => _AddEditDonationState();
}

class _AddEditDonationState extends State<AddEditDonation> {
  final _form = GlobalKey<FormState>();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode!) {
      _foodnameController.text = widget.donation!.foodName;
      _foodQuantityContoller.text =
          widget.donation!.donationQuantity.toString();
      _foodTypeConntroller.text = widget.donation!.foodType;
      _imageUrlController.text = widget.donation!.foodImage;
    }
  }

  final _foodnameController = TextEditingController();
  final _foodQuantityContoller = TextEditingController();
  final _foodTypeConntroller = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    final isVaild = _form.currentState!.validate();
    if (!isVaild) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final db = Provider.of<FirestoreApi>(context, listen: false);

      Address defaultAddress = await db.getUserDefaultAddress(
          widget.currentUser!.defaultAddressId, auth.currentuser!.uid);

      Donation newDonation = Donation(
        donorId: auth.currentuser!.uid,
        foodName: _foodnameController.text,
        foodImage: _imageUrlController.text,
        foodType: _foodTypeConntroller.text,
        remainingQuantity: int.parse(_foodQuantityContoller.text),
        donationQuantity: int.parse(_foodQuantityContoller.text),
        donatedTime: DateTime.now(),
        expiredTime: DateTime.now().add(Duration(hours: 25)),
        donorName:
            '${widget.currentUser!.firstName} ${widget.currentUser!.lastName}',
        donorContact: widget.currentUser!.phoneNumber,
        status: 'available',
        address: defaultAddress,
      );
      if (widget.isEditMode == true) {
        await db.editDonation(newDonation, widget.donation!.donationId!);
      } else {
        await db.postDonation(newDonation);
      }
      setState(() {
        _isLoading = false;
      });
      await showNormalAlretDialog(
        context,
        title: 'Success',
        message: widget.isEditMode!
            ? 'your donation updated succesfully'
            : 'your donation updated succesfully',
      );
      Navigator.of(context).pop();
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
      });
      showExceptionAlertDialog(
        context,
        title: 'Donation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add & Edit Donation'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: SpinKitFadingFour(
                color: Colors.greenAccent,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _foodnameController,
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Provide a food name.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _foodQuantityContoller,
                        decoration: InputDecoration(
                          labelText: 'Quantity Per Person',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter a Quantity.';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a vaild number.';
                          }
                          if (int.parse(value) <= 0) {
                            return 'Please enter a number greater than zero.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _foodTypeConntroller,
                        decoration: InputDecoration(
                            labelText: 'Food type', hintText: 'veg or nonveg'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Provide food type';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                onChanged: (_) {
                                  setState(() {});
                                },
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Provide a Image Url.';
                                  }
                                  return null;
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
