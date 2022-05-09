import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './screens/orders_screen.dart';
import './screens/products_edit_screen.dart';
import './screens/user_products.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './screens/products_overview_screen.dart';
import './screens/product_details_screen.dart';
import './providers/products.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(auth.token,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          home: ProductsOverviewScreen(),
          routes: {
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            ProductsOverviewScreen.routename: (ctx) => ProductsOverviewScreen(),
            UserProducts.routeName: (ctx) => UserProducts(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
