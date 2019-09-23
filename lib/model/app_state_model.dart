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
import 'package:shared_preferences/shared_preferences.dart';



double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7.0;

class AppStateModel extends Model {
  // All the available products.


  List _customer_orders = [];
  get customer_orders => _customer_orders;
  List _products_categories = [];
  List get products_categories => _products_categories;
  var _current_user_id;
  get current_user_id => _current_user_id;
  var _current_user_email;
  get current_user_email => _current_user_email;

  List _allproducts = [];

  

  List get allproducts => _allproducts;

  int _userId;

  int get userId => _userId;

  List _customersList = [];
  List get customersList => _customersList;


  List _availableProducts = [];

  List _productsInCartwc = [];

  List get availableProducts => _availableProducts;
  List get productsInCartwc => _productsInCartwc;
  // The currently selected category of products.

  // The IDs and quantities of products currently in the cart.
  Map<int, int> _productsInCart = {};
  Map<int, int> get productsInCart => Map.from(_productsInCart);

  void getprefs() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     _current_user_id = prefs.getInt('id');
     if (_current_user_id != null) {
       _current_user_email = _customersList.firstWhere((user) => user['id'] == _current_user_id)['email'];
       WooCommerceAPI wc_api = new WooCommerceAPI(
        "http://worlddelete.ru/risitesto",
        "ck_07a643e5cb2fe5088d880bc6aba20db513cae159",
        "cs_e84f4bb389cccf2260b0f864fdda145606c3c0f4"
    );
     _customer_orders = await wc_api.getAsync("orders?customer=$_current_user_id");
     }
     
    
  }

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


    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // _prefs_local = prefs;

    /// Initialize the API
    WooCommerceAPI wc_api = new WooCommerceAPI(
        "http://worlddelete.ru/risitesto",
        "ck_07a643e5cb2fe5088d880bc6aba20db513cae159",
        "cs_e84f4bb389cccf2260b0f864fdda145606c3c0f4"
    );
    
    /// Get data using the endpoint
  
    
    var customers_page = 1;

        while (customers_page != null) {
        List customers = await wc_api.getAsync("customers?per_page=100&page=${customers_page}");
        if (customers.length > 0) {
            _customersList += customers;
            customers_page++;
        } else {
            customers_page = null; // last page
        }
    }


    var cat_page = 1;

        while (cat_page != null) {
        List products_cat = await wc_api.getAsync("products/categories?per_page=100&page=${cat_page}");
        if (products_cat.length > 0) {
            _products_categories += products_cat;
            cat_page++;
        } else {
            cat_page = null; // last page
        }
    }

    // make another conclusion
     var products_page = 1;

        while (products_page != null) {
        List products = await wc_api.getAsync("products?per_page=100&page=${products_page}");
        if (products.length > 0) {
            _availableProducts += products;
            products_page++;
        } else {
            products_page = null; // last page
        }
    }

    
    return _availableProducts;
    
  }

  Future getCustomerOrders() async {

  }


}


