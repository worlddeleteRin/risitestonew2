import 'package:Shrine/app.dart';
import 'package:Shrine/home.dart';
import 'package:flutter/material.dart';
import 'mail_shopping.dart';
import 'shopping_cart.dart';
import 'model/app_state_model.dart';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:scoped_model/scoped_model.dart';

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}
// Create a corresponding State class. This class will hold the data related to
// the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  String name;
  String address;
  var phone;
  @override 
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Scaffold(
    appBar: AppBar(
      title: Text("Подтверждение заказа"),
      backgroundColor: Colors.black87,
    ),
    body: SingleChildScrollView(
      child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
      return Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[  
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 150.0),             
                        child: Column(children: <Widget>[
                                TextFormField(
                      decoration: InputDecoration(
                        hintText: "Имя",
                        labelText: "Ваше Имя"
                      ),                       
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'Введите ваше Имя';
                        }
                        else {
                          name = value;
                        }
                      },
                    ),
                  TextFormField(
                      decoration: InputDecoration(
                        hintText: "+7 (xxx)-xxx-xx-xx",
                       labelText: "Номер телефона"
                      ),
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'Введите номер телефона';
                        }
                        else if(!isNumeric(value))
                        {
                          return 'Пожалуйста введите корректный номер телефона';
                        }
                        else {
                          phone = value;
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Адрес",
                        labelText: "Ваш Адрес"
                      ),                       
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'Введите ваш Адрес';
                        }
                        else {
                          address = value;
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,  vertical: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, we want to show a Snackbar
                            /*Scaffold
                                .of(context)
                                .showSnackBar(
                                  SnackBar(content: Text('Processing Data'),
                                )
                                ).closed.then((SnackBarClosedReason reason) {
                                  _opennewpage();
                                });          */    
                                mailIt(model, name, phone);   
                                print('Заказ подтвержден');
                                _ackAlert(context, model);  

                          }
                        },
                        child: Text('Подтвердить заказ'),
                      ),
                    ),
                  ],
                ),
            ),
          ],
        ),
      );
            },
      ),
    ),
    );
  }

  Future<void> _ackAlert(BuildContext context, model) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Подтверждение заказа'),
        content: const Text('Ваш заказ подтвержден. Сейчас с вами свяжется оператор'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Ok',
              style: TextStyle(
                color: Colors.black,
              ),
              ),
            onPressed: () {
              model.clearCart();
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => ShrineApp()),
              );
            },
          ),
        ],
      );
    },
  );
}
  
/*void _opennewpage() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {      
          return new Scaffold(
        appBar: new AppBar(
          title: new Text('Success'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 19.0),             
                        child: Column(children: <Widget>[
                         Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 19.0),             
                            child:  FlutterLogo( size: 70.0,),
                         ),
                                Text('You have Successfully Signed with Flutter', 
                                 textAlign: TextAlign.center,
                                 overflow: TextOverflow.ellipsis,
                                 style: new TextStyle(fontWeight: FontWeight.w300),
                                 ),
                                                        
                  ],
                ),
            ),
            ],
          ),
        ),
      );
        },
      ),
    );
  }*/


  mailIt(AppStateModel model, name, phone) async {
  String username = 'naken505@gmail.com';
  String password = 'Worlddelete0Rin';

  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = new SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.  
  
  // Create our message.
  final message = new Message()
    ..from = new Address(username, 'Your name')
    ..recipients.add('worlddelete0@gmail.com')
    ..subject = 'Заказ с приложения Рис и Тесто :: 😀 :: ${new DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<h1>Товаров заказано: ${model.totalCartQuantity}</h1>\n<p>${model.totalProductsInCartName} : ${model.totalProductsInCartQuantity}</p> <p>$name, $phone, $address</p>";

  // Use [catchExceptions]: true to prevent [send] from throwing.
  // Note that the default for [catchExceptions] will change from true to false
  // in the future!
  final sendReports = await send(message, smtpServer, catchExceptions: false);
  
  }
}
                        
bool isNumeric(String s) {
  try
  {
    return double.parse(s) != null;
  }
  catch (e)
  {
    return false;
  }
}