import 'package:bask_app/providers/donate.dart';
import 'package:bask_app/widget/donate_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonateItemScreen extends StatefulWidget {
  static const routeName = '/donate_item_screen';

  @override
  _DonateItemScreenState createState() => _DonateItemScreenState();
}

class _DonateItemScreenState extends State<DonateItemScreen> {
  var _isInit = true;
  var _isLoading = false;

  Future<void> _refreshItems(BuildContext context) async {
   await Provider.of<Donate>(context, listen: false).fetchAndSetDonateItems();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Donate>(context).fetchAndSetDonateItems().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final donateItemData = Provider.of<Donate>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Donations'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
            onRefresh: () => _refreshItems(context),
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView.builder(
                    itemCount: donateItemData.items.length,
                    itemBuilder: (_, i) => Column(
                      children: [
                        DonateProductItem(
                          donateItemData.items[i].id,
                          donateItemData.items[i].title,
                          donateItemData.items[i].imageUrl,
                          donateItemData.items[i].address,
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ),
              ),
          ),
    );
  }
}
