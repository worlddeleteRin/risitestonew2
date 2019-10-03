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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
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

import 'package:rflutter_alert/rflutter_alert.dart';



const _leftColumnWidth = 60.0;

class ShoppingCartPage extends StatefulWidget {

  ShoppingCartPage({this.mainDrawer});

  Widget mainDrawer;

  List allproducts;
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {


  List<Widget> _createShoppingCartRows(AppStateModel model) {
    return model.productsInCart.keys
        .map(
          (id) => 

          ShoppingCartRow(
            id,
            widget.allproducts,
            quantity: model.productsInCart[widget.allproducts.firstWhere((p) => p['id'] == id)['id']],
            removeitems: () {
                model.removeItemsFromCart(widget.allproducts.firstWhere((p) => p['id'] == id)['id']);
            },
            addquantity: () {
              model.addProductToCart(widget.allproducts.firstWhere((p) => p['id'] == id)['id']);
            },
            removequantity: () {
              model.removeItemFromCart(widget.allproducts.firstWhere((p) => p['id'] == id)['id']);
            },
          )
          // ShoppingRow(
          //   id,
          //   widget.allproducts,
          //   onDelete: () {
          //     setState(() {
          //       model.removeProductsInCart(widget.allproducts.firstWhere((p) => p['id'] == id)['id']);
          //     });
          //   },
          // )
          // Row(
          //   children: <Widget>[
          //     Text('${widget.allproducts.firstWhere((p) => p['id'] == id)['name']}'),
          //     RaisedButton(
          //       child: Text('Удалить'),
          //       onPressed: () {
          //         model.removeProductsInCart(widget.allproducts.firstWhere(((p) => p['id'] == id))['id']);
          //       },
          //     )
          //   ],
          // ),
          
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final localTheme = Theme.of(context);

    return Scaffold(
      drawer: widget.mainDrawer,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Корзина'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              widget.allproducts = model.availableProducts;
              return Stack(
                children: [
                  ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 30, bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            'Ваши покупки',
                            style: localTheme.textTheme.subhead
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 16.0),
                          Text('Товаров: ${model.totalCartQuantity}'),
                        ],
                      ),
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
                            //showAlertDialog();
                            if(model.totalCartQuantity == 0) {
                              print('в коризне нет товара');
                              return showDialog<void>(
                              context: context,
                              barrierDismissible: false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Корзина пуста'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text('Ваша корзина пуста.'),
                                        Text('Добавьте товар, чтобы сделать заказ!'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      // color: Colors.orange,
                                      child: Text('Продолжить',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                              );
                            } else {
                            Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => MyShopping(widget.allproducts)),
                        );
                            }
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
                          ),
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

  showAlertDialog() {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "RFLUTTER ALERT",
      desc: "Flutter is more awesome with RFlutter Alert.",
      buttons: [
        DialogButton(
          child: Text(
            "FLAT",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "GRADIENT",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
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
                        //ExpandingBottomSheet.of(context).close();
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
  ShoppingCartRow(this.id, this.allproducts,
      {@required this.quantity, this.onPressed, this.addquantity, this.removequantity, this.removeitems,});

  int id;
  List allproducts;
  int quantity;
  final VoidCallback onPressed;
  final VoidCallback addquantity;
  final VoidCallback removequantity;
  final VoidCallback removeitems;

  @override
  Widget build(BuildContext context) {

    var currentProduct = allproducts.firstWhere((p) => p['id'] == id);

    AppStateModel model;
    final localTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
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
                      Container(
                    height: 75.0,
                    width: 75.0,
                    child: CachedNetworkImage(
                    imageUrl: currentProduct["images"][0]["src"],
                    placeholder: (context, url) => new CircularProgressIndicator(),
                    ),
                  ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                             '${currentProduct['name']}',
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
                                    },
                                    child: Icon(Icons.keyboard_arrow_right,
                                    size: 40,
                                    color: Colors.green,
                                    ),
                                  ),
                                ),
                                Text(
                                  //'product price',
                                  currentProduct['price'] == null? 'x ${currentProduct['price']} руб.': 'x ${currentProduct['price']}',
                                  ),
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
