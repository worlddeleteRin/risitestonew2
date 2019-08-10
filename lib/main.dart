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
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

import 'app.dart';
import 'model/app_state_model.dart';

import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';



void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      
AppStateModel model = AppStateModel();
model.loadProducts();
  runApp(
    ScopedModel<AppStateModel>(
      model: model,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
    return new MaterialApp(
    debugShowCheckedModeBanner: false,
    color: Colors.blue,
    home: App(),
    );
}
}

/*
 class RunShrineApp extends StatelessWidget {

Widget build(BuildContext context) {
AppStateModel model = AppStateModel();
model.loadProducts();
  return ScopedModel<AppStateModel>(
    model: model,
    child: ShrineApp(),
  );
}
}*/

class App extends StatefulWidget {

@override
AppState createState() => new AppState();

}

class AppState extends State<App> {

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new ShrineApp()));
    } else {
    prefs.setBool('seen', true);
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new IntroScreen()));
    }
}
  @override
void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 200), () {
    checkFirstSeen();
    });
}

@override
Widget build(BuildContext context) {
    return new Scaffold(
    body: new Center(
        child: new Text('Загрузка...'),
    ),
    );
}
}



class IntroScreen extends StatelessWidget {
//making list of pages needed to pass in IntroViewsFlutter constructor.
  final pages = [
    PageViewModel(
        pageColor: Color.fromRGBO(26, 26, 26, 10),
        // iconImageAssetPath: 'assets/air-hostess.png',
        //bubble: Image.asset('assets/logo_white.png'),
        body: Text(
          'Доставка еды, которой ты будешь доволен',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        title: Text(
          'Рис & Тесто',
        ),
        textStyle: TextStyle(fontFamily: 'GogoiaDec', color: Colors.white, fontWeight: FontWeight.w600),
        mainImage: Image.asset(
          'assets/logo_white2.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )),
    PageViewModel(
      pageColor: const Color(0xFF607D8B),
      //iconImageAssetPath: 'assets/logo_white.png',
      body: Text(
        'Мы усердно работаем для вас, и используем только качественные продукты',
      ),
      title: Text('Любимая еда'),
      mainImage: Image.asset(
        'assets/favorite_food.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'SenseiMedium', color: Colors.white),
    ),
    PageViewModel(
      pageColor: Color.fromRGBO(255, 133, 51, 10),
      //iconImageAssetPath: 'assets/logo_white.png',
      body: Text(
        'Мы ценим ваше время, поэтому организуем доставку максимально быстро',
      ),
      title: Text('Быстрая доставка'),
      mainImage:Icon(
        Icons.local_shipping,
        color: Colors.black,
        size: 250,
        ), /*Image.asset(
        'assets/logo_white.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),*/
      textStyle: TextStyle(fontFamily: 'GogoiaDec', color: Colors.white, fontWeight: FontWeight.w600),
    ),
  ];

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IntroViews Flutter', //title of app
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), //ThemeData
      home: Builder(
        builder: (context) => IntroViewsFlutter(
              pages,
              onTapDoneButton: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShrineApp(),
                  ),
                );
              },
              pageButtonTextStyles: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ), //IntroViewsFlutter
      ), //Builder
    );
  }
}