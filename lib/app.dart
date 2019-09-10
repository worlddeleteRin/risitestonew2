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

import 'package:Shrine/shopping_cart.dart';
import 'package:flutter/material.dart';

import 'backdrop.dart';
import 'colors.dart';
import 'home.dart';
import 'login_page/login_main.dart';
import 'expanding_bottom_sheet.dart';
import 'model/app_state_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/product.dart';
import 'expanding_bottom_sheet.dart';
import 'shopping_form2.dart';
import 'stock.dart';
// import 'package:woocommerce_api/woocommerce_api.dart';
import 'woocommerce_api.dart';
import 'dart:async';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';




class ShrineApp extends StatefulWidget {

  //TODO: add prevent back
  // didPopRoute(){
  //   bool override;
  //   override = false;
  //   return new Future<bool>.value(override);
  // } 
 
  @override
  _ShrineAppState createState() => _ShrineAppState();
}

class _ShrineAppState extends State<ShrineApp>
    with SingleTickerProviderStateMixin {

  

  int currentPage = 1;

  GlobalKey bottomNavigationKey = GlobalKey();

  AsyncSnapshot s;

  List products_pizza = [];
  List products_rolls = [];
  List products_sets = [];
  List products_burgers = [];
  List products_drinks = [];
  List products_supplements = [];
  List products_stocks = [];

  List current_user_email = [];

  List allproducts = [];

  AppStateModel model;
  // Controller to coordinate both the opening/closing of backdrop and sliding
  // of expanding bottom sheet.
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
      value: 1.0,
    );
  }

  Future getProductswc() async {


    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// Initialize the API
    WooCommerceAPI wc_api = new WooCommerceAPI(
        "http://worlddelete.ru/risitesto",
        "ck_07a643e5cb2fe5088d880bc6aba20db513cae159",
        "cs_e84f4bb389cccf2260b0f864fdda145606c3c0f4"
    );
    
    
    /// Get data using the endpoint
    var p = await wc_api.getAsync("products?per_page=100");

    var customers = await wc_api.getAsync("customers?per_page=100");

    List customersList = customers;

    //print(p.length);
    if (current_user_email.isEmpty) {
      int user_id = prefs.getInt('id');
      String current_user = customersList.firstWhere((c) => c['id'] == user_id)['email'];
      current_user_email.add(current_user);
    }

    if (products_pizza.isEmpty) {
    
    for (int i = 0; i < p.length; i++) {

      // allproducts.add(p[i]);
      if (p[i]["categories"][0]["slug"] == "rolls") {
        products_rolls.add(p[i]);
      }
      else if (p[i]["categories"][0]["slug"] == "pizza") {
        products_pizza.add(p[i]);
      }
      else if (p[i]["categories"][0]["slug"] == "sets") {
        products_sets.add(p[i]);
      }
      else if (p[i]["categories"][0]["slug"] == "burgers") {
        products_burgers.add(p[i]);
      }
      else if (p[i]["categories"][0]["slug"] == "drinks") {
        products_drinks.add(p[i]);
      }
      else if (p[i]["categories"][0]["slug"] == "supplements") {
        products_supplements.add(p[i]);
      }
      else if (p[i]["categories"][0]["slug"] == "stocks") {
        products_stocks.add(p[i]);
      }


    }

    }
    return p;
  }


  _getPage(int page) {
    switch (page) {
      case 0: 
      return StockPage(allproducts, products_stocks);
      case 1: 
      return ProductMainPage(allproducts, products_pizza, products_rolls, products_sets, products_drinks, products_burgers, products_supplements, products_stocks, current_user_email);
      case 2:  
      return ShoppingCartPage(allproducts);

        
      
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Рис & Тесто',
      home: Scaffold(
        body: FutureBuilder(
        future: getProductswc(),
        builder: (_, snapshot){

          if(snapshot.data == null){
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitDualRing(
                  color: Colors.black,
                  size: 50.0,
                ),
                Container(padding: EdgeInsets.only(top: 20),),
                  Text(
                    "Загрузка товара...",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    ),
                ],)
              ),
            );
          }
          allproducts = snapshot.data;
          return _getPage(currentPage);
        },
      ),
        
        bottomNavigationBar: FancyBottomNavigation(
          circleColor: Colors.red,
          activeIconColor: Colors.black,
          inactiveIconColor: Colors.white,
          barBackgroundColor: Colors.black87,
          textColor: Colors.white,
    tabs: [
        
        TabData(iconData: Icons.local_offer, title: "Акции",),
        TabData(iconData: Icons.fastfood, title: "Товары",),
        TabData(iconData: Icons.shopping_cart, title: "Корзина",),
        
    ],
    key: bottomNavigationKey,
    initialSelection: 1,
    onTabChangedListener: (position) {
        setState(() {
        currentPage = position;
        });
    },
),
      ),
    );

    

      /*
      home: HomePage(
        backdrop: Backdrop(
          frontLayer: ProductPage(),
          backLayer:
              CategoryMenuPage(onCategoryTap: () => _controller.forward()),
          frontTitle: Text('Рис & Тесто'),
          backTitle: Text('Меню'),
          controller: _controller,
        ),
        expandingBottomSheet: ExpandingBottomSheet(hideController: _controller),
      ),
      */
      //initialRoute: '/',
      //onGenerateRoute: _getRoute;
      //theme: _kShrineTheme,

  }

    }


Widget MainDrawer(List allproducts, List products_stocks, List current_user_email) {

    
    return Builder(builder: (context) =>
  Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Icon(
                    Icons.account_box,
                    size: 100,
                    ),
                    Text(
                      current_user_email == null ? 'Гость' : '${current_user_email[0]}',
                      style: TextStyle(
                        fontSize: 16,
                      )
                    )
                  ],
                )
              )
            ),
            ListTile(
              title: Text(
                'Каталог Товаров',
                ),
                leading: Icon(Icons.local_dining, color: Colors.black),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.red),
              onTap: () {
                //Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShrineApp()));
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Выйти из аккаунта',
                ),
                leading: Icon(Icons.exit_to_app, color: Colors.black),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.red),
              onTap: () {
                //Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LoginPage()));
                //Navigator.pop(context);
              },
            ),
      //       ListTile(
      //         title: Text(
      //           'Акции',
      //           ),
      //           leading: Icon(Icons.local_offer, color: Colors.black),
      //           trailing: Icon(Icons.keyboard_arrow_right, color: Colors.red),
      //         onTap: () {
      //           // Update the state of the app
      //           // ...
      //           // Then close the drawer
      //           Navigator.pop(context);
      //           Navigator.of(context).push(MaterialPageRoute(
      // builder: (context) => StockPage(allproducts, products_stocks)));
                
                
      //         },
      //       ),
      

          ],
        ),
  ),
      );
}


Route<dynamic> _getRoute(RouteSettings settings) {
  

  return MaterialPageRoute<void>(
    settings: settings,
    builder: (BuildContext context) => LoginPage(),
    fullscreenDialog: true,
  );
}

final ThemeData _kShrineTheme = _buildShrineTheme();

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: kShrineBrown900);
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: kShrineColorScheme,
    accentColor: kShrineBrown900,
    primaryColor: kShrinePink100,
    buttonColor: kShrinePink100,
    scaffoldBackgroundColor: kShrineBackgroundWhite,
    cardColor: kShrineBackgroundWhite,
    textSelectionColor: kShrinePink100,
    errorColor: kShrineErrorRed,
    buttonTheme: const ButtonThemeData(
      colorScheme: kShrineColorScheme,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: _customIconTheme(base.iconTheme),
    //inputDecorationTheme:
        //const InputDecorationTheme(border: CutCornersBorder()),
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline: base.headline.copyWith(fontWeight: FontWeight.w500),
        title: base.title.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        body2: base.body2.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
        button: base.button.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: kShrineBrown900,
        bodyColor: kShrineBrown900,
      );
}

const ColorScheme kShrineColorScheme = ColorScheme(
  primary: kShrinePink100,
  primaryVariant: kShrineBrown900,
  secondary: kShrinePink50,
  secondaryVariant: kShrineBrown900,
  surface: kShrineSurfaceWhite,
  background: kShrineBackgroundWhite,
  error: kShrineErrorRed,
  onPrimary: kShrineBrown900,
  onSecondary: kShrineBrown900,
  onSurface: kShrineBrown900,
  onBackground: kShrineBrown900,
  onError: kShrineSurfaceWhite,
  brightness: Brightness.light,
);


class ProductMainPage extends StatefulWidget {

  ProductMainPage(this.allproducts, this.products_pizza, this.products_rolls, this.products_sets, this.products_drinks, this.products_burgers, this.products_supplements, this.products_stocks, this.current_user_email);

  List allproducts;
  AsyncSnapshot s;

  List products_pizza;
  List products_rolls;
  List products_sets;
  List products_burgers;
  List products_drinks;
  List products_supplements;
  List products_stocks;

  List current_user_email;


  AppStateModel model;

  _ProductMainPageState createState() => _ProductMainPageState();
}

class _ProductMainPageState extends State<ProductMainPage> {


@override
Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
   child: Scaffold(
          drawer: MainDrawer(widget.allproducts, widget.products_stocks, widget.current_user_email),
          appBar: AppBar(
            backgroundColor: Colors.black87,
            bottom: TabBar(
              indicatorColor: Colors.green,
              indicatorWeight: 6,
              isScrollable: true,
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.orange,
              labelPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              tabs: [
               
                Text(
                  "Пицца",
                style: TextStyle(
                  fontSize: 20,
                )
                ),
                
                Text("Роллы",
                style: TextStyle(
                  fontSize: 20,
                ),
                ),
                Text("Сеты",
                style: TextStyle(
                  fontSize: 20,
                ),
                ),
                Text("Бургеры",
                style: TextStyle(
                  fontSize: 20,
                ),
                ),
                Text("Напитки",
                style: TextStyle(
                  fontSize: 20,
                ),
                ),
                Text("Добавки",
                style: TextStyle(
                  fontSize: 20,
                ),
                ),
                
               // Tab(icon: Icon(Icons.local_pizza)),
                /*Tab(icon: Icon(Icons.local_pizza)),
                Tab(icon: Icon(Icons.camera_roll)),
                Tab(icon: Icon(Icons.local_drink)),
                Tab(icon: Icon(Icons.opacity)),*/
                
              ],
            ),
            title: Text('Рис & Тесто'),
            centerTitle: true,
          ),
          body: TabBarView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              //roductPage(Category.all),
              ProductPage(widget.products_pizza, widget.allproducts),
              ProductPage(widget.products_rolls, widget.allproducts),
              ProductPage(widget.products_sets, widget.allproducts),
              ProductPage(widget.products_burgers, widget.allproducts),
              ProductPage(widget.products_drinks, widget.allproducts),
              ProductPage(widget.products_supplements, widget.allproducts),
            ],
          ),
   ),
   );

}

Future getProductswc() async {

    /// Initialize the API
    WooCommerceAPI wc_api = new WooCommerceAPI(
        "http://worlddelete.ru/risitesto",
        "ck_07a643e5cb2fe5088d880bc6aba20db513cae159",
        "cs_e84f4bb389cccf2260b0f864fdda145606c3c0f4"
    );
    
    
    /// Get data using the endpoint
    var p = await wc_api.getAsync("products?per_page=1000");

    //print(p.length);
    
    if (widget.products_pizza.isEmpty) {
    
    for (int i = 0; i < p.length; i++) {

      // allproducts.add(p[i]);
      if (p[i]["categories"][0]["slug"] == "rolls") {
        widget.products_rolls.add(p[i]);
      }
      else if (p[i]["categories"][0]["slug"] == "pizza") {
        widget.products_pizza.add(p[i]);
      }
      else if (p[i]["categories"][0]["slug"] == "sets") {
        widget.products_sets.add(p[i]);
      }
      else if (p[i]["categories"][0]["slug"] == "burgers") {
        widget.products_burgers.add(p[i]);
      }
      else if (p[i]["categories"][0]["slug"] == "drinks") {
        widget.products_drinks.add(p[i]);
      }
      else if (p[i]["categories"][0]["slug"] == "supplements") {
        widget.products_supplements.add(p[i]);
      }
      
    }

    }
    return p;
  }
}