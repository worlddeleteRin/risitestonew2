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

import 'package:Shrine/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import 'colors.dart';
import 'expanding_bottom_sheet.dart';
import 'model/app_state_model.dart';
import 'model/product.dart';
import 'shopping_form2.dart';
import 'shopping_form3.dart';
import 'mail_shopping.dart';
import 'package:stepper_touch/stepper_touch.dart';

const _leftColumnWidth = 60.0;

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {


  List<Widget> _createShoppingCartRows(AppStateModel model) {
    return model.productsInCart.keys
        .map(
          (id) => ShoppingCartRow(
                product: model.getProductById(id),
                quantity: model.productsInCart[id],
                onPressed: () {
                  model.removeItemFromCart(id);
                },
                addquantity: () {
                 model.addProductToCart(id);
                },
                removequantity: () {
                  model.removeItemFromCart(id);
                },
                removeitems: () {
                  model.removeItemsFromCart(id);
                },
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final localTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              return Stack(
                children: [
                  ListView(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: _leftColumnWidth,
                            child: IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down),
                                onPressed: () =>
                                    ExpandingBottomSheet.of(context).close()),
                          ),
                          Text(
                            'Корзина',
                            style: localTheme.textTheme.subhead
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 16.0),
                          Text('Товаров: ${model.totalCartQuantity}'),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Column(
                        children: _createShoppingCartRows(model),
                      ),
                      ShoppingCartSummary(model: model),
                      const SizedBox(height: 100.0),
                    ],
                  ),
                  Positioned(
                    bottom: 15.0,
                    left: 16.0,
                    right: 16.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => MyShopping()),
                        );
                        //model.clearCart();
                        //ExpandingBottomSheet.of(context).close();
                          },
                          height: 50,
                          minWidth: 200,
                          elevation: 10,
                          color: Colors.green,
                          shape: new RoundedRectangleBorder(
         borderRadius: new BorderRadius.circular(15.0)),
                          child: Text('Оформить заказ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          )
                          )
                        ),
                      ],
                    )
                  )
                  /*
                  Positioned(
                    bottom: 60.0,
                    left: 16.0,
                    right: 16.0,
                    child: RaisedButton(
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
                      color: Colors.green,
                      splashColor: kShrineBrown600,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('Оформить заказ'),
                      ),
                      onPressed: () {
                        //mailIt(model);
                        Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => MyCustomForm()),
                        );
                        //model.clearCart();
                        //ExpandingBottomSheet.of(context).close();
                      },
                    ),
                  ),
                  
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: RaisedButton(
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
                      color: Colors.red,
                      splashColor: kShrineBrown600,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('Очистить карту'),
                      ),
                      onPressed: () {
                        model.clearCart();
                        ExpandingBottomSheet.of(context).close();
                      },
                    ),
                  ),
                  */
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ShoppingCartSummary extends StatelessWidget {
  ShoppingCartSummary({this.model});

  final AppStateModel model;

  @override
  Widget build(BuildContext context) {
    final smallAmountStyle =
        Theme.of(context).textTheme.body1.copyWith(color: kShrineBrown600);
    final largeAmountStyle = Theme.of(context).textTheme.display1;
    final formatter = NumberFormat.simpleCurrency(
        decimalDigits: 2, locale: Localizations.localeOf(context).toString());

    return Row(
      children: [
        SizedBox(width: _leftColumnWidth),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        model.clearCart();
                        ExpandingBottomSheet.of(context).close();
                      },
                      color: Colors.red,
                      shape: new RoundedRectangleBorder(
         borderRadius: new BorderRadius.circular(30.0)),
                      child: Text('Очистить карту',
                      style: TextStyle(
                        color: Colors.white,
                      )
                      )
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Text('СУММА ЗАКАЗА:'),
                    ),
                    Text(
                      '${model.subtotalCost} руб.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),/*
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Subtotal:'),
                    ),
                    Text(
                      formatter.format(model.subtotalCost),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Shipping:'),
                    ),
                    Text(
                      formatter.format(model.shippingCost),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Tax:'),
                    ),
                    Text(
                      formatter.format(model.tax),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),*/
      ],
    ),
          ),
        ),
      ],
    );
  }
}

class ShoppingCartRow extends StatelessWidget {
  ShoppingCartRow(
      {@required this.product, @required this.quantity, this.onPressed, this.addquantity, this.removequantity, this.removeitems,});

  final Product product;
  int quantity;
  final VoidCallback onPressed;
  final VoidCallback addquantity;
  final VoidCallback removequantity;
  final VoidCallback removeitems;

  @override
  Widget build(BuildContext context) {

    AppStateModel model;
    final formatter = NumberFormat.simpleCurrency(
        decimalDigits: 0, locale: Localizations.localeOf(context).toString());
    final localTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        key: ValueKey(product.id),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _leftColumnWidth,
            child: IconButton(
              color: Colors.red,
              iconSize: 35,
              icon: const Icon(Icons.remove_shopping_cart),
              onPressed: () {
                removeitems();
              }
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        product.assetName,
                        //package: product.assetPackage,
                        fit: BoxFit.cover,
                        width: 75.0,
                        height: 75.0,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: localTheme.textTheme.subhead
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: FlatButton(
                                    onPressed: () {
                                      removequantity();
                                    },
                                    child: Icon(Icons.keyboard_arrow_left,
                                    size: 40,
                                    color: Colors.red,
                                    ),
                                  ),
                                  //child: Text('Количество: $quantity'),
                                  
                                ),
                                
                                Container(
                                  child: Text('$quantity',
                                  style: TextStyle(
                                    fontSize: 22,
                                  )
                                  ),
                                ),
                                Expanded(
                                  child: FlatButton(
                                    onPressed: () {
                                      addquantity();
                                      print('$quantity');
                                    },
                                    child: Icon(Icons.keyboard_arrow_right,
                                    size: 40,
                                    color: Colors.green,
                                    ),
                                  ),
                                ),
                                Text('x ${product.price} руб.'),
                              ],
                            ),
                            
                            
                            
                          ],
                        ),
                      ),
                        
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(
                    color: Colors.red,
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


