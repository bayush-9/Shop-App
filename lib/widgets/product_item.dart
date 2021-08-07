import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  // final String title;
  // final String imageUrl;
  // final String id;
  // ProductItem({
  //   this.id,
  //   this.imageUrl,
  //   this.title,
  // });
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                icon: Icon(product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () async {
                  await Provider.of<Products>(context, listen: false)
                      .markAsFav(product.id, product.isFavourite);
                },
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_bag_outlined),
              onPressed: () {
                cart.addProduct(product.id, product.title, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeOneItem(product.id);
                      },
                    ),
                    content: Text('Item added to cart!'),
                  ),
                );
              },
            ),
            title: Text(product.title, textAlign: TextAlign.center),
            backgroundColor: Colors.black54),
      ),
    );
  }
}
