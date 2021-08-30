import 'package:bask_app/providers/donate.dart';
import 'package:bask_app/screen/donate_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditDonateItemScreen extends StatefulWidget {
  static const routeName = '/edit-donation';
  @override
  _EditDonateItemScreenState createState() => _EditDonateItemScreenState();
}

class _EditDonateItemScreenState extends State<EditDonateItemScreen> {
//variables to focus a particular field
  final _quantityFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedItem = DonateItem(
    id: null.toString(),
    title: '',
    address: '',
    imageUrl: '',
    quantity: 0,
  );

  var _isLoading = false;

  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

// dispose method use to delete the focusnode after use
  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageUrl);
    _quantityFocusNode.dispose();
    _addressFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isVaild = _form.currentState!.validate();
    if (!isVaild) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    Provider.of<Donate>(context, listen: false)
        .addItem(_editedItem)
        .catchError((error) {
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occured!'),
                content: Text('Something went wrong'),
                actions: [
                  FlatButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, child: Text('Okay'),)
                ],
              ));
    }).then((_) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    });
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
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_quantityFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Provide a value.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedItem = DonateItem(
                            title: value.toString(),
                            address: _editedItem.address,
                            quantity: _editedItem.quantity,
                            imageUrl: _editedItem.imageUrl,
                            id: null.toString(),
                          );
                        },
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Quantity Per Person'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _quantityFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_addressFocusNode);
                        },
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
                        onSaved: (value) {
                          _editedItem = DonateItem(
                            title: _editedItem.title,
                            address: _editedItem.address,
                            quantity: int.parse(value.toString()),
                            imageUrl: _editedItem.imageUrl,
                            id: null.toString(),
                          );
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Address'),
                        maxLines: 2,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        focusNode: _addressFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_imageFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Provide a Address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedItem = DonateItem(
                            title: _editedItem.title,
                            address: value.toString(),
                            quantity: _editedItem.quantity,
                            imageUrl: _editedItem.imageUrl,
                            id: null.toString(),
                          );
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
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Provide a Image Url.';
                                }
                                //Here adding something later.....................
                                return null;
                              },
                              onSaved: (value) {
                                _editedItem = DonateItem(
                                  title: _editedItem.title,
                                  address: _editedItem.address,
                                  quantity: _editedItem.quantity,
                                  imageUrl: value.toString(),
                                  id: null.toString(),
                                );
                              },
                            ),
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
