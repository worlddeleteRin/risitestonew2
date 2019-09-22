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
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/app_state_model.dart';
import '../model/product.dart';
import 'dart:convert';
// import 'package:woocommerce_api/woocommerce_api.dart';
import '../woocommerce_api.dart';

import 'dart:async';






class ProductCard extends StatelessWidget {

  ProductCard(this.product);
  
  List product;
  //List productsInCart = [];

  //static final kTextBoxHeight = 150.0;

  @override 
  Widget _shoppingButton(BuildContext context, index) {
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        
        return Row(children: <Widget>[

      Container( 
      padding: EdgeInsets.only(left: 40, right: 140, bottom: 10),
      child: Row(children: <Widget>[

      Text(
        '${this.product[index]['price']}',
        style: TextStyle(
          fontSize: 25
        )
      ),
      Text(
        ' руб.',
        style: TextStyle(
          fontSize: 11,
        ),
      ),
      ],)
      
      ),  

      MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.padded,
        elevation: 10,
        splashColor: Colors.green,
        shape: new RoundedRectangleBorder(
         borderRadius: new BorderRadius.circular(30.0)),
        color: Colors.orange,
        onPressed: () {
          //productsInCart.add(product[index]);
          //print(productsInCart);
          model.addProductToCart(this.product[index]['id']);
          Scaffold.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              elevation: 1,
              content: Text('${this.product[index]['name']} добавлен(а) в корзину'),
              duration: Duration(seconds: 1),
            )
          );
          //print(this.product[index]);
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
        
      ),
      ],);
      }
    );
  }


  @override
  Widget build(BuildContext context) {

    String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
  }



    final NumberFormat formatter = NumberFormat.currency(
        decimalDigits: 0, locale: "ru_RU", symbol: "руб." );
    final ThemeData theme = Theme.of(context);

    //final imageWidget = Image.network(product.data[index]["images"][0]["src"]);

    /*return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => GestureDetector(
            onTap: () {
              model.addProductToCart(product.id);
              // TODO: Add Snackbar
            },
            child: child,
          ),
      child: */

  
      return Scaffold(
      body: ListView.builder(
            itemCount: product.length,
            itemBuilder: (BuildContext context,index){
              
            //print(product.data[index]["categories"][0]["slug"]);


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
                      product == null ? '' : '${product[index]["regular_price"]} руб.',
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
                      product == null ? '' : product[index]["sale_price"] == null ? '${product[index]["regular_price"]}' : '${product[index]["sale_price"]}',
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
            final priceWidget = Padding(
            padding: const EdgeInsets.only(top: 40),
              child: new Container(
          width: 50.0,
          height:50.0,
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
                      product == null ? '' : product[index]["regular_price"] == null ? '${product[index]["sale_price"]}' : '${product[index]["regular_price"]}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        fontFamily: "arial",
                        color: Colors.white,
                      ),
          ),
          Text(
            product == null ? '' : 'руб.',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                        fontFamily: "arial",
                        color: Colors.white,
                      )
          ),
          ],
          ),
          ),
          ),
            );

      return Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderOnForeground: true,
            elevation: 20,
            semanticContainer: true,
            shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column( 
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
          
              Container(
                padding: EdgeInsets.only(top: 1),
                width: 200,
                height: 200,
              child: CachedNetworkImage(
                    imageUrl: product[index]["images"][0]["src"],
                    placeholder: (context, url) => new CircularProgressIndicator(
                      backgroundColor: Colors.green,
                      strokeWidth: 3,
                    ),
                    ),
              /*child: AspectRatio(
                aspectRatio: imageAspectRatio,
                child: imageWidget,
              ),
              */
          ),


          //     Positioned(
          //     child: product[index]["sale_price"].isEmpty == true ? priceWidget : stockpriceWidget, 
          //   top: -35,
          //   right: 0,
          // ),
              
            ],),
            Column(mainAxisSize: MainAxisSize.min,children: <Widget>[
          
              SizedBox(
                //height:  .28 * MediaQuery.of(context).size.height,
                // width: .62 * MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(padding: EdgeInsets.only(top: 10)),
                    Text(
                      product == null ? '' : product[index]["name"],
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
                    Container(padding: EdgeInsets.only(top: 5)),
                    Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      product == null ? '' : removeAllHtmlTags(product[index]["description"]),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'slabo'
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
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
                child:_shoppingButton(context, index),
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
      ),
      );
  }

}




