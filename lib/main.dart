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

import 'dart:io';

import 'package:Shrine/model/app_state_model.dart' as prefix0;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scoped_model/scoped_model.dart';

import 'app.dart';
import 'model/app_state_model.dart';

import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

// imports for login page 
import 'login_page/login_main.dart';


void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      
AppStateModel model = AppStateModel();

  runApp(
    ScopedModel<AppStateModel>(
      model: model,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {

AppStateModel model;  
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _internet_result = false;

checkConnectivity() async {
  try {
  final result = await InternetAddress.lookup('google.com');
  if (result[0].rawAddress.isNotEmpty) {
    setState(() => this._internet_result = true);
  }
} on SocketException catch (_) {
  return false;
}
}

@override 
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity();
  }

 
@override
Widget build(BuildContext context) {
    return new MaterialApp(
    debugShowCheckedModeBanner: false,
    color: Colors.blue,
    home: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {

    if (_internet_result == false) {
      return AlertDialog(
        backgroundColor: Colors.red,
        shape: new RoundedRectangleBorder(
         borderRadius: new BorderRadius.circular(30.0)),
        title: Text('Нет соединения с интернетом!',
        style: TextStyle(
          color: Colors.white,
        )
        ),
        content: Icon(
          Icons.signal_wifi_off,
          size: 80,
        ),
        actions: <Widget>[
          MaterialButton(
            height: 50,
            minWidth: 120,
            color: Colors.orange,
            shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
            child: Text(
              'Повторить',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyApp()
              ));
            },
          ),
        ],
      );
    } else {
    
    return Scaffold(
    body: FutureBuilder(
        future: model.getProductswc(),
        builder: (_, snapshot){
          if(snapshot.data == null){
            return Container(
              decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage("assets/back1.jpg"),
                  fit: BoxFit.cover,
              ),
            ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
              //        Container(
              // decoration: new BoxDecoration(
              // image: new DecorationImage(
              //     image: new AssetImage("assets/logo_white2.png"),
              //     fit: BoxFit.fill,
              //     ),
              //   ),
              //       ),
                    Card(
                    color: Colors.white38,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                      // color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                    SpinKitDualRing(
                  color: Colors.red[800],
                  size: 50.0,
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Загрузка...',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      ),
                ),
                ],)
                    ),
                ],)
              ),
            );
          }
          return App();
        },
      ),
    );

    }
            },
    ),

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
    // print(prefs.getInt('id'));
    if (prefs.getInt('id') != null) {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new ShrineApp()));
    } else {
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new LoginPage()));
    }
    } else {
    prefs.setBool('seen', true);
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new IntroScreen()));
    }
}
  @override
void initState() {
    print('get it');
    super.initState();
    new Timer(new Duration(milliseconds: 200), () {
    checkFirstSeen();
    });
}

@override
Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model)  { 
              model.getprefs();
    return Scaffold(
      body: Center(
        child: Text('Загрузка')
      ), 
    );
            }
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
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ), //ThemeData
      home: Builder(
        builder: (context) => IntroViewsFlutter(
              pages,
              onTapDoneButton: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
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