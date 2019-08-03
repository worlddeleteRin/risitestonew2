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

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/app_state_model.dart';
import '../model/product.dart';





class ProductCard extends StatelessWidget {
  ProductCard({this.imageAspectRatio = 50 / 50, this.product})
      : assert(imageAspectRatio == null || imageAspectRatio > 0);

  final double imageAspectRatio;
  final Product product;

  //static final kTextBoxHeight = 150.0;

  @override 
  Widget _shoppingButton(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.padded,
        elevation: 10,
        splashColor: Colors.green,
        shape: new RoundedRectangleBorder(
         borderRadius: new BorderRadius.circular(30.0)),
        color: Colors.orange,
        onPressed: () {
          model.addProductToCart(product.id);
          /*Flushbar(
            aroundPadding: EdgeInsets.all(10),
            borderRadius: 10,
            flushbarPosition: FlushbarPosition.TOP,
            message: "Продукт добавлен в корзину",
            icon: Icon(
              Icons.shopping_cart,
              size: 28.0,
              color: Colors.black,
              ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.orange,
          )..show(context);*/
        },
        child: Text(
          "Заказать!",
          style: TextStyle(
            color: Colors.white,
          )
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.currency(
        decimalDigits: 0, locale: "ru_RU", symbol: "руб." );
    final ThemeData theme = Theme.of(context);



    final priceWidget = Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
              child: new Container(
          width: 60.0,
          height:60.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
          child: new Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
          Text(
                      product == null ? '' : product.stockprice == null ? '${product.price}' : '${product.stockprice}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        fontFamily: "arial",
                        color: Colors.white,
                      )
          ),
          Text(
            product == null ? '' : 'руб.',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        fontFamily: "arial",
                        color: Colors.white,
                      )
          ),
          ],
          ),
          ),
          ),
            );
      final stockpriceWidget = Padding(
            padding: const EdgeInsets.symmetric(vertical: 35),
              child: new Container(
          width: 70.0,
          height:70.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.redAccent,
          ),
          child: new Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
          Text(
                      product == null ? '' : '${product.price} руб.',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        fontFamily: "arial",
                        color: Colors.black,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.black,
                      ),
          ),
          /*Text(
            product == null ? '' : 'руб.',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 8,
                        fontFamily: "arial",
                        color: Colors.black,
                      )
          ),*/
          Text(
                      product == null ? '' : product.stockprice == null ? '${product.price}' : '${product.stockprice}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        fontFamily: "arial",
                        color: Colors.white,
                      )
          ),
          Text(
            product == null ? '' : 'руб.',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        fontFamily: "arial",
                        color: Colors.white,
                      )
          ),
          ],
          ),
          ),
          ),
            );
    final imageWidget = Image.asset(
      product.assetName,
      //package: product.assetPackage,
      fit: BoxFit.cover,
    );

    /*return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => GestureDetector(
            onTap: () {
              model.addProductToCart(product.id);
              // TODO: Add Snackbar
            },
            child: child,
          ),
      child: */
      return Card(
            borderOnForeground: true,
            elevation: 20,
            semanticContainer: true,
            shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row( 
            //mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Stack(
              children: <Widget>[  
              //Padding(
              //padding: EdgeInsets.symmetric(vertical: 11)
              //),
          
              Center(
              child:SizedBox(
                width: 130,
                height: 130,
              child: imageWidget,
              /*child: AspectRatio(
                aspectRatio: imageAspectRatio,
                child: imageWidget,
              ),
              */
          ),
              ),

              Positioned(
              child: product.stockprice == null ? priceWidget : stockpriceWidget, 
            top: -35,
            right: 0,
          ),
              
            ],),
            Column(mainAxisSize: MainAxisSize.min,children: <Widget>[
          
              SizedBox(
                //height:  .28 * MediaQuery.of(context).size.height,
                width: .62 * MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      product == null ? '' : product.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        fontFamily: "slabo"
                      ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                    Text(
                      product == null ? '' : product.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'slabo'
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,

                      
                    ),
                    SizedBox(height: 5.0),
                    /*Text(
                      product == null ? '' : formatter.format(product.price),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        fontFamily: "arial"
                      )
                    ),*/
                  Center(
                child:_shoppingButton(context),
                ),
                  ],
                ),
              ),
              
              /*Text(
                      product == null ? '' : formatter.format(product.price),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        fontFamily: "arial"
                      )
                    ),*/
                
              ],),
          /*  
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[ 
              Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
              child: new Container(
          width: 70.0,
          height:70.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
          child: new Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
          Text(
                      product == null ? '' : '${product.price}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        fontFamily: "arial",
                        color: Colors.white,
                      )
          ),
          Text(
            product == null ? '' : 'руб.',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        fontFamily: "arial",
                        color: Colors.white,
                      )
          ),
          ],
          ),
          ),
          ),
            ),
            
            ],
            
          ),*/
    ],
            ),  
              ],
            ),
      );
  }

}




