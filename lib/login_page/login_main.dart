
import 'package:Shrine/login_page/forgot_password.dart';
import 'package:flutter/material.dart';
import '../woocommerce_api.dart';
import 'dart:async';
import '../app.dart';
import 'dart:convert';

import 'package:wordpress_api/wordpress_api.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;

import 'package:progress_dialog/progress_dialog.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/app_state_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';



class LoginPage extends StatefulWidget {

AppStateModel model;  
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _internet_result = false;


String email_field;
String password_field;

final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    var pr = new ProgressDialog(context,ProgressDialogType.Normal);
    pr.setMessage('Обработка запроса...');

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 80.0,
        child: Image.asset('assets/logo.png'),
      ),
    );
  
    final forgotLabel = FlatButton(
      child: Text(
        'Забыли пароль?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ForgotPage()));
      },
    );

    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) =>
    Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            FirstForm(),
            // SizedBox(height: 24.0),
            LoginButton(pr, model),
            // CreateAccountButton(pr, model),
            // forgotLabel
          ],
        ),
      ),
    ),
    );
  }

Widget CreateAccountButton(pr, model) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
          
          await checkConnectivity();
           if (_internet_result == false) {
             _noInternetConnection(context);
           } else {
          registerUser(model);
           }
          
          }
          // registerUser();
          // Navigator.of(context).pushNamed(HomePage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Создать аккаунт', style: TextStyle(color: Colors.white)),
      ),
    );
}
Widget LoginButton(pr, model) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
          await checkConnectivity();
          if (_internet_result == false) {
            _noInternetConnection(context);
          } else {
            signInUser(model);
          }
          }
          // registerUser();
          // Navigator.of(context).pushNamed(HomePage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Войти', style: TextStyle(color: Colors.white)),
      ),
    );
}

  Widget FirstForm() {

  return Form(
      key: _formKey,
      autovalidate: false,
      child: Column(
          verticalDirection: VerticalDirection.down,
          //crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[  
            Container(             
                        child: Column(children: <Widget>[
      // TextFormField(
      // keyboardType: TextInputType.emailAddress,
      //                             //expands: true,
      //                             //enableInteractiveSelection: true,
      //                             cursorColor: Colors.green,
      //                             autofocus: false,
      //                 decoration: InputDecoration(
      //                   hintText: "YourEmail@gmail.com",
      //                   labelText: "Ваша Почта",
      //                 ),                       
      //                 validator: (value) {
      //                   if(value.isEmpty) {
      //                     return 'Заполните поле почты';
      //                   }
      //                   else {
      //                     this.email_field = value;
      //                   }
      //                 },
      //               ),
                                TextFormField(
                                  // obscureText: true,
                                  //expands: true,
                                  //enableInteractiveSelection: true,
                                  cursorColor: Colors.green,
                                  autofocus: false,
                      decoration: InputDecoration(
                        hintText: "+7978xxxxxxx",
                        labelText: "Ваш номер телефона",
                      ),                       
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'Введите имя пользователя';
                        }
                        else {
                          this.password_field = value;
                        }
                      },
                    ),
                        ],
                        ),
            ),
      ],
      ),
  );                    
}

_noInternetConnection(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
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
              'ОК',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

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

  registerUser(model) async {
    // show loading 

    /// Initialize the API
    WooCommerceAPI wc_api = new WooCommerceAPI(
        "http://worlddelete.ru/risitesto",
        "ck_07a643e5cb2fe5088d880bc6aba20db513cae159",
        "cs_e84f4bb389cccf2260b0f864fdda145606c3c0f4"
    );

    //  var p = await wc_api.getAsync("customers?per_page=100");
    try {
      // print(email_field + ' ' + password_field);
     var response = await wc_api.postAsync(
      "customers",
      {
        "email": '${password_field}risitesto@gmail.com',
        "password": "$password_field",
        "username": "$password_field",
      },
     );


    print(response);

    var status_code = 200;
    if (response['data']['status'] == 400) {
      status_code = 400;
      String error_message = response['message'];
      _noRegistered(context, '$error_message');
    }  

    } catch(e) {

      print('все норм');
      // signInUser(pr, model);
      // Navigator.of(context).push(MaterialPageRoute(
      // builder: (context) => ShrineApp()));
      // print(e);
    }

  }

  signInUser(model) async {
    // pr.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // WooCommerceAPI wc_api = new WooCommerceAPI(
    //     "http://worlddelete.ru/risitesto",
    //     "ck_07a643e5cb2fe5088d880bc6aba20db513cae159",
    //     "cs_e84f4bb389cccf2260b0f864fdda145606c3c0f4"
    // );

    // var customers = await wc_api.getAsync("customers?per_page=100");
    List customersList = await model.updateCustomers();
    // print(customersList.firstWhere((c) => c['email'] == email_field)['id']);
    // pr.hide();
    try {
  // print(customersList.firstWhere((c) => c['email'] == email_field));

    // if successful
      int id = customersList.firstWhere((c) => c['username'] == password_field)['id'];
      
      if (customersList.firstWhere((c) => c['id'] == id)['username'] == password_field) {
      // print(id);
      model.setuserId(id);
      // print(model.userId);
      await prefs.setInt('id', id);
      // print(prefs.getInt('id'));
      // pr.hide();
      model.getprefs();
      print(id);
      print('пользователь залогинен');

      Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShrineApp()));
      
      } 
      else {
        print('не вышло');
        // pr.hide();
        _noSignIn(context);
      }

  } catch(e) {
    // _noSignIn(context);
    print(e.message);
    if (e.message == 'No element') {
      print('нет в базе');
      await registerUser(model);
    }
  }

    
}


// signInUser3() async {
//     WordPressAPI api = WordPressAPI('http://worlddelete.ru/risitesto',
//     consumerKey: '5a4dmLmKF40E',
//     consumerSecret: 'yDz39c7Vyi1CDQtntA71fHRPAcUq0c56lnHFzXXNdspqP2Gx',
//     // isWooCommerce: true,
//     );
//     final res = await api.getAsync('users');
//     List users = res['data'];
//     print(users.firstWhere((user) => user['name'] == 'Admin')['password']);
// }



_noSignIn(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: new RoundedRectangleBorder(
         borderRadius: new BorderRadius.circular(30.0)),
        title: Text('Неверная почта или пароль!',
        style: TextStyle(
          color: Colors.red,
        )
        ),
        // content: Icon(
        //   Icons.signal_wifi_off,
        //   size: 80,
        // ),
        actions: <Widget>[
          MaterialButton(
            height: 50,
            minWidth: 120,
            color: Colors.orange,
            shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
            child: Text(
              'ОК',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

_noRegistered(BuildContext context, String message) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: new RoundedRectangleBorder(
         borderRadius: new BorderRadius.circular(30.0)),
        title: Text('$message!',
        style: TextStyle(
          color: Colors.red,
        )
        ),
        // content: Icon(
        //   Icons.signal_wifi_off,
        //   size: 80,
        // ),
        actions: <Widget>[
          MaterialButton(
            height: 50,
            minWidth: 120,
            color: Colors.orange,
            shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
            child: Text(
              'ОК',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}



}