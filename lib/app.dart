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
import 'user_account.dart';
import 'products_menu.dart';
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

  int _selectedIndex = 1;
static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  

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

  widgetOptions(int page) {
    switch (page) {
      case 0: 
      return StockPage();
      case 1: 
      return ProductMainPage();
      case 2:  
      return ShoppingCartPage(); 
    }
  }

void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}



  _getPage(int page) {
    switch (page) {
      case 0: 
      return StockPage();
      case 1: 
      return ProductMainPage();
      case 2:  
      return ShoppingCartPage();

        
      
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Рис & Тесто',
      home: Scaffold(
        body: widgetOptions(_selectedIndex),
        
        bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          title: Text('Акции'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fastfood),
          title: Text('Товары'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          title: Text('Корзина'),
        ),
      ],
      type: BottomNavigationBarType.shifting,
      currentIndex: _selectedIndex,
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.red,
      backgroundColor: Colors.black87,
      onTap: _onItemTapped,
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


Widget MainDrawer()  {

    
    return ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model)  {

            // model.getprefs();
    return Drawer(
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
                      model.current_user_email == null ? 'Гость' : '${model.current_user_email}',
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
                'Мой профиль',
                ),
                leading: Icon(Icons.account_circle, color: Colors.black),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.red),
              onTap: () {
                //Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UserAccount()));
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Меню доставки',
                ),
                leading: Icon(Icons.restaurant, color: Colors.black),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.red),
              onTap: () {
                //Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProductsMenu()));
                //Navigator.pop(context);
              },
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
                // prefs.setInt('id', null);
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
  );
            }
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

  AsyncSnapshot s;

  AppStateModel model;

  _ProductMainPageState createState() => _ProductMainPageState();
}

class _ProductMainPageState extends State<ProductMainPage> {


@override
Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
   child: Scaffold(
          drawer: MainDrawer(),
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
              ProductPage('pizza'),
              ProductPage('rolls'),
              ProductPage('sets'),
              ProductPage('burgers'),
              ProductPage('drinks'),
              ProductPage('supplements'),
            ],
          ),
   ),
   );

}

}
