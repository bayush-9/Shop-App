import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/user_products_item.dart';
import '../screens/products_edit_screen.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final itemdata = Provider.of<Products>(context);
    Future<void> _refreshPage(context) async {
      await Provider.of<Products>(context, listen: false).addAndFetchProducts();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshPage(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemBuilder: (context, index) => UserProductItem(
                itemdata.items[index].id,
                itemdata.items[index].title,
                itemdata.items[index].imageUrl),
            itemCount: itemdata.items.length,
          ),
        ),
      ),
    );
  }
}
