// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:scoped_model/scoped_model.dart';

import 'product.dart';
import 'products_repository.dart';
// import 'package:woocommerce_api/woocommerce_api.dart';
import '../woocommerce_api.dart';

import 'dart:async';
import 'dart:convert';


double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7.0;

class AppStateModel extends Model {
  // All the available products.

  int _userId;

  int get userId => _userId;


  List _availableProducts;

  List _productsInCartwc = [];

  List get availableProducts => _availableProducts;
  List get productsInCartwc => _productsInCartwc;
  // The currently selected category of products.

  // The IDs and quantities of products currently in the cart.
  Map<int, int> _productsInCart = {};
  Map<int, int> get productsInCart => Map.from(_productsInCart);

  loadProductswc(List products) {
    _availableProducts = products;
    //print(_availableProducts.length);
  }

  setuserId(int id) {
    _userId = id;
  }

  void addProductsInCart(int productId) {
    /*
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId]++;
    }
    */
    _productsInCartwc.add(productId);
    notifyListeners();
    print(_productsInCartwc);
  }

  void removeProductsInCart(int productId) {
    _productsInCartwc.remove(productId);
    print(_productsInCartwc);
  }

  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId]++;
    }
    print(_productsInCart);
    notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId]--;
      }
    }

    notifyListeners();
  }




  get totalProductsInCartName => _productsInCart.keys
      .map((id) => _availableProducts[id].name);

  get totalProductsInCartQuantity => _productsInCart.keys
      .map((id) => _productsInCart[id]);

  // Total number of items in the cart.
  int get totalCartQuantity => _productsInCart.values.fold(0, (v, e) => v + e);


  // Totaled prices of the items in the cart.
  double get subtotalCost => _productsInCart.keys
      .map((id) { 
        
        int stockproductprice = int.parse(_availableProducts.firstWhere((p) => p['id'] == id)['price']);
        if (stockproductprice != null) {
        return stockproductprice * _productsInCart[id];
        }
        else {
          return stockproductprice * _productsInCart[id];
        }
      })
      .fold(0.0, (sum, e) => sum + e);

  // Total shipping cost for the items in the cart.
  double get shippingCost =>
      _shippingCostPerItem *
      _productsInCart.values.fold(0.0, (sum, e) => sum + e);

  // Sales tax for the items in the cart
  double get tax => subtotalCost * _salesTaxRate;

  // Total cost to order everything in the cart.
  double get totalCost => subtotalCost + shippingCost + tax;

  // Returns a copy of the list of available products, filtered by category.

  List<Product> getProducts() {
    if (_availableProducts == null) return List<Product>();

  
      return _availableProducts.toList();
  }
  //
   
  // Adds a product to the cart.
  

  void setItemQuantity(int productId, value) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId] = value;
      }
    }

    notifyListeners();
  }


  void removeItemsFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
        _productsInCart.remove(productId);
    }
    notifyListeners();
  }
  // Returns the Product instance matching the provided id.
  List getProductById(int id) {
    return _availableProducts.firstWhere((p) => p['id'] == id);
  }

  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  // Loads the list of available products from the repo.
  void loadProducts() {
    _availableProducts = ProductsRepository.loadProducts(Category.all);
    notifyListeners();
  }

  void setCategory(Category newCategory) {
    //_selectedCategory = newCategory;
    notifyListeners();
  }

  Future getProductswc() async {

    /// Initialize the API
    WooCommerceAPI wc_api = new WooCommerceAPI(
        "http://worlddelete.ru/risitesto",
        "ck_07a643e5cb2fe5088d880bc6aba20db513cae159",
        "cs_e84f4bb389cccf2260b0f864fdda145606c3c0f4"
    );
    
    /// Get data using the endpoint
    var p = await wc_api.getAsync("products");
    return p;
  }


}


