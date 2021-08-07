import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartListItem extends StatelessWidget {
  final double price;
  final String productId;
  final String id;
  final String title;
  final int quantity;

  CartListItem(
      {this.price, this.productId, this.id, this.title, this.quantity});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
                title: Text('Are you sure?'),
                content: Text(
                  'Are you sure you want to remove the item?',
                ),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text('Yes'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No'),
                  ),
                ]);
          }),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeProduct(productId);
      },
      background: Container(
        padding: EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      key: ValueKey(id),
      child: Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Text(
                  price.toString(),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text(
              'Total: Rs.' + (price * quantity).toString(),
            ),
            trailing: Text(
              'x' + quantity.toString(),
              style: TextStyle(fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }
}
