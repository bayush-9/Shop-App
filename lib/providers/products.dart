import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouritesItem {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(id) {
    return _items.firstWhere((element) => element.id == id);
  }

  String token;
  Products(this.token, this._items);
  Future<void> addAndFetchProducts() async {
    final url = Uri.parse(
        'https://shop-app-b8310-default-rtdb.firebaseio.com/products.json?auth=$token');
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final gotProducts = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadeddPRoducts = [];
      gotProducts.forEach((key, value) {
        loadeddPRoducts.add(Product(
          description: value['description'],
          id: key,
          imageUrl: value['imageUrl'],
          price: value['price'],
          title: value['title'],
          isFavourite: value['isFavourite'],
        ));
      });
      _items = loadeddPRoducts;
      notifyListeners();
    } catch (error) {
      // print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product _newProduct) async {
    final url = Uri.parse(
        'https://shop-app-b8310-default-rtdb.firebaseio.com/products.json?auth=$token');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': _newProduct.title,
          'description': _newProduct.description,
          'imageUrl': _newProduct.imageUrl,
          'price': _newProduct.price,
          'isFavourite': _newProduct.isFavourite
        }),
      );
      final Product addedProduct = Product(
        id: json.decode(response.body)['name'],
        title: _newProduct.title,
        description: _newProduct.description,
        price: _newProduct.price,
        imageUrl: _newProduct.imageUrl,
      );
      _items.add(addedProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shop-app-b8310-default-rtdb.firebaseio.com/products/$id.json?auth=$token');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> markAsFav(String id, bool currentStatus) async {
    final url = Uri.parse(
        'https://shop-app-b8310-default-rtdb.firebaseio.com/products/$id.json?auth=$token');
    await http.patch(
      url,
      body: json.encode(
        {
          'isFavourite': !currentStatus,
        },
      ),
    );
    final toggleProductIndex = _items.indexWhere((element) => element.id == id);
    _items[toggleProductIndex].isFavourite = !currentStatus;
    notifyListeners();
  }

  void removeProducts(String id) {
    final url = Uri.parse(
        'https://shop-app-b8310-default-rtdb.firebaseio.com/products/$id.json?auth=$token');
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items.firstWhere((element) => element.id == id);
    http
        .delete(url)
        .then((value) => existingProduct = null)
        .catchError((onError) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    });

    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}

// Product(
//   id: 'p1',
//   title: 'Red Shirt',
//   description: 'A red shirt - it is pretty red!',
//   price: 29.99,
//   imageUrl:
//       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
// ),
// Product(
//   id: 'p2',
//   title: 'Trousers',
//   description: 'A nice pair of trousers.',
//   price: 59.99,
//   imageUrl:
//       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
// ),
// Product(
//   id: 'p3',
//   title: 'Yellow Scarf',
//   description: 'Warm and cozy - exactly what you need for the winter.',
//   price: 19.99,
//   imageUrl:
//       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
// ),
// Product(
//   id: 'p4',
//   title: 'A Pan',
//   description: 'Prepare any meal you want.',
//   price: 49.99,
//   imageUrl:
//       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
// ),

// var _showFavouritesOnly = false;
// void showFavouritesOnly() {
//   _showFavouritesOnly = true;
//   notifyListeners();
// }

// void showAll() {
//   _showFavouritesOnly = false;
//   notifyListeners();
// }
