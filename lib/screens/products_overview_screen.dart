import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/cart.dart';
import 'cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOption {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routename = '/products-overview';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _selectedfavourites = false;
  var _isinit = true;
  bool _isloading;
  // @override
  // void initState() {
  //   Provider.of<Products>(context, listen: false).addAndFetchProducts();
  //   super.initState();
  // }
  @override
  void didChangeDependencies() {
    if (_isinit == true) {
      setState(() {
        _isloading = true;
      });
      Provider.of<Products>(context, listen: false)
          .addAndFetchProducts()
          .then((value) {
        setState(() {
          _isloading = false;
        });
      });
    }
    _isinit = false; // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Shop app'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOption value) {
              setState(() {
                if (value == FilterOption.Favourites) {
                  _selectedfavourites = true;
                } else {
                  _selectedfavourites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOption.Favourites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOption.All,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemcount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_bag_outlined),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: _isloading
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Hang on...loading products",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ))
          : ProductsGrid(_selectedfavourites),
    );
  }
}
