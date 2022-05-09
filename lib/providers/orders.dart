import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    this.id,
    this.amount,
    this.products,
    this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://shop-app-b8310-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(url);
    print(json.decode(response.body));
    List<OrderItem> loadedProducts = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    } 
    extractedData.forEach((orderId, orderItems) {
      loadedProducts.add(
        OrderItem(  
          amount: orderItems['amount'],
          dateTime: DateTime.parse(
            orderItems['dateTime'],
          ),
          id: orderId,
          products: (orderItems['cartProducts'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ))
              .toList(),
        ),
      );
    });
    _orders = loadedProducts.reversed;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final dateStamp = DateTime.now();
    final url = Uri.parse(
        'https://shop-app-b8310-default-rtdb.firebaseio.com/orders.json');
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': dateStamp.toIso8601String(),
          'cartProducts': cartProducts
              .map((cartproduct) => {
                    'id': cartproduct.id,
                    'title': cartproduct.title,
                    'quantity': cartproduct.quantity,
                    'price': cartproduct.price,
                  })
              .toList(),
        }));

    _orders.insert(
      0,
      OrderItem(
          amount: total,
          dateTime: dateStamp,
          id: json.decode(response.body)['name'],
          products: cartProducts),
    );
    notifyListeners();
  }
}
