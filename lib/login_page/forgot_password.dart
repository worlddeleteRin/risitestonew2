import 'package:Shrine/main.dart';
import 'package:flutter/material.dart';
import '../woocommerce_api.dart';
import 'dart:async';
import '../app.dart';
import 'dart:convert';
import 'login_main.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ForgotPage extends StatefulWidget {

  @override
  _ForgotPageState createState() => new _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {

  String email_field_forgot;
  final _formKey = GlobalKey<FormState>();

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text(
        'Восстановление аккаунта',
      ),
    ),
    body: Center(
      child: Column(
        children: <Widget>[
          Container(padding: EdgeInsets.only(top: 40),),
          Icon(
            Icons.mail_outline,
            size: 100,
            ),
            Container(padding: EdgeInsets.only(top: 30)),
            Text(
              'Забыли пароль?',
              style: TextStyle(
                fontSize: 25,
              )
            ),
            Container(padding: EdgeInsets.only(top: 10)),
            Container(
              padding: EdgeInsets.only(left: 50, right: 50),
            child: Text(
              'Введите вашу почту, и на нее будет выслан ваш текущий пароль',
              textAlign: TextAlign.center,
            ),
            ),
            Form(
              key: _formKey,
              autovalidate: false,
            child: Container(
              padding: EdgeInsets.only(top: 30, left: 40, right: 40),
            child: TextFormField(
      keyboardType: TextInputType.emailAddress,
                                  //expands: true,
                                  //enableInteractiveSelection: true,
                                  cursorColor: Colors.green,
                                  autofocus: false,
                      decoration: InputDecoration(
                        fillColor: Colors.black,
                        hintText: "YourEmail@gmail.com",
                        labelText: "Ваша Почта",
                      ),                       
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'Заполните поле почты';
                        }
                        else {
                          this.email_field_forgot = value;
                        }
                      },
                    ),
            ),
            ),
            Container(padding: EdgeInsets.only(top: 20)),
            RaisedButton(
              color: Colors.cyan,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                Text(
                  'Отправить',
                  style: TextStyle(
                    color: Colors.white
                  )
                ),
                // Icon(Icons.keyboard_arrow_right,
                // color: Colors.redAccent
                // ),
              ],),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  mailUserPass();
              }
              },
            )
        ],
      ),
    ),
  );
}

  mailUserPass() async {
    print('lol');
    WooCommerceAPI wc_api = new WooCommerceAPI(
        "http://worlddelete.ru/risitesto",
        "ck_07a643e5cb2fe5088d880bc6aba20db513cae159",
        "cs_e84f4bb389cccf2260b0f864fdda145606c3c0f4"
    );
    var customers = await wc_api.getAsync("customers?per_page=100");
    List customersList = customers;

     try {
    // if successful
      String email  = customersList.firstWhere((c) => c['email'] == email_field_forgot)['email'];
      String username  = customersList.firstWhere((c) => c['email'] == email_field_forgot)['username'];
      print(email);

      mailIt(email, username);
      
      // Navigator.of(context).push(MaterialPageRoute(
      // builder: (context) => ShrineApp()));

  } catch(e) {
    _noSignIn(context);
    print(e);
  }

  }

  _noSignIn(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: new RoundedRectangleBorder(
         borderRadius: new BorderRadius.circular(30.0)),
        title: Text('На данную почту не зарегистрирован аккаунт',
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

mailIt(email, user_password) async {
  String username = 'naken505@gmail.com';
  String password = 'Worlddelete0Rin';
  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = new SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.  
  
  // Create our message.
  final message = new Message()
    ..from = new Address(username, 'Ris & Testo App')
    ..recipients.add('$email')
    // ..recipients.add('ris.testo@mail.ru')
    ..subject = 'Ваш Аккаунт приложения Рис и Тесто :: 😀 :: ${new DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<h2>Ваш пароль для входа в аккаунт:  $user_password</h2>";

  // Use [catchExceptions]: true to prevent [send] from throwing.
  // Note that the default for [catchExceptions] will change from true to false
  // in the future!
  final sendReports = await send(message, smtpServer, timeout: Duration(seconds: 10) /*catchExceptions: false*/);
  
  var connection = PersistentConnection(smtpServer);
  
  // Send the first message
  // send the equivalent message
  
  // close the connection
  await connection.close();
  }

}