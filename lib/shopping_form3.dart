import 'package:Shrine/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'model/app_state_model.dart';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wave_progress_widget/wave_progress_widget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
// import 'package:woocommerce_api/woocommerce_api.dart';
import 'woocommerce_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyShopping extends StatefulWidget {
  List allproducts;
  MyShopping(this.allproducts);
  @override
  MyShoppingState createState() => MyShoppingState();
}

class MyShoppingState extends State<MyShopping> {
  
  int _radioValue;
  String _payResult;
  String _deliveryResult;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
  
      switch (_radioValue) {
        case 0:
          _deliveryResult = 'Доставка курьером';
          break;
        case 1:
          _deliveryResult = 'Самовывоз';
          break;
        case 2:
          _payResult = 'Оплата наличными';
          break;
        case 3:
          _payResult = 'Оплата картой курьеру';
      }
    });
  }

  checkWayPick() {
    if(isSwitched == true) {
      return 'Доставка курьером';
    }
    if(isSwitched2 == true) {
      return 'Самовывоз';
    }
  }

  checkWayPay() {
    if(isSwitched3 == true) {
      return 'Оплата наличными';
    }
    if(isSwitched4 == true) {
      return 'Оплата картой курьеру';
    }
  }

  AppStateModel model;
final _formKey = GlobalKey<FormState>();
  String name;
  String address;
  String waytopick;
  String waytopay;
  var phone;
bool isSwitched = false;
bool isSwitched2 = false;
bool isSwitched3 = false;
bool isSwitched4 = false;
  // init the step to 0th position
  int current_step = 0;

  bool _internet_result = false;

  var _progress = 50.0;

 var phonecontroller = new MaskedTextController(mask: '70000000000');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        backgroundColor: Colors.black87,
        //shape: new RoundedRectangleBorder(
         //borderRadius: new BorderRadius.circular(30.0)),
        // Title
        title: Text("Подтверждение заказа"),
      ),
      // Body
      body: SingleChildScrollView(
      child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
          return Container(
            padding: EdgeInsets.only(top: 40),
           child: Stepper( 
        // Using a variable here for handling the currentStep
        currentStep: this.current_step,
        // List the steps you would like to have
        steps: [
          Step(
        // Title of the Step
        title: Text("Ваши данные"),
        // Content, it can be any widget here. Using basic Text for this example
        content: FirstForm(),
        isActive: true),
    Step(
        title: Text("Способ доставки"),
        content: Column(children: <Widget>[
        Row(children: <Widget>[
          new Radio(
            value: 0,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
          ),
          new Text(
          'Доставка курьером',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        ),
        ],
        ),
        Row(children: <Widget>[
        new Radio(
            value: 1,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
          ),
          new Text(
          'Самовывоз',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        ),
        ],
        ),
        
          /*
        Row(children: <Widget>[

        
        Text('Доставка курьером',
        style: TextStyle(

        )
        ), 
        Checkbox(
  value: isSwitched,
  onChanged: (value) {
    setState(() {
      isSwitched = value;
    });
  },
  activeColor: Colors.green,
),
],),
  Row(children: <Widget>[
        Text('Самовывоз',
        style: TextStyle(

        )
        ), 
        Checkbox(
  value: isSwitched2,
  onChanged: (value) {
    setState(() {
      isSwitched2 = value;
    });
  },
  activeColor: Colors.green,
),
],)
        ], */
        ],
),
        // You can change the style of the step icon i.e number, editing, etc.
        state: StepState.editing,
        isActive: true),
    Step(
        title: Text("Способ оплаты"),
        content: Column(children: <Widget>[
        Row(children: <Widget>[
          new Radio(
            value: 2,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
          ),
          new Text(
          'Опалата наличными',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        ),
        ],
        ),
        Row(children: <Widget>[
        new Radio(
            value: 3,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
          ),
          new Text(
          'Оплата картой курьеру',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        ),
        ],
        ),
],),
        // You can change the style of the step icon i.e number, editing, etc.
        state: StepState.editing,
        isActive: true),
        ],
        // Define the type of Stepper style
        // StepperType.horizontal :  Horizontal Style
        // StepperType.vertical   :  Vertical Style
        type: StepperType.vertical,
        // Know the step that is tapped
        onStepTapped: (step) {
          checkConnectivity();
          // On hitting step itself, change the state and jump to that step
          setState(() {
            // update the variable handling the current step value
            // jump to the tapped step
            this.current_step = step;
          });
          // Log function call
          print("onStepTapped : " + step.toString());
        },
        onStepCancel: () {
          // On hitting cancel button, change the state
          setState(() {
            // update the variable handling the current step value
            // going back one step i.e subtracting 1, until its 0
            if (current_step > 0) {
              current_step = current_step - 1;
            } else {
              current_step = 0;
            }
          });
          // Log function call
          print("onStepCancel : " + current_step.toString());
        },
        // On hitting continue button, change the state
        onStepContinue: () {
          checkConnectivity();
          setState(() async {
            // update the variable handling the current step value
            // going back one step i.e adding 1, until its the length of the step
            if (current_step!= null) {
              checkConnectivity();
              current_step = current_step + 1;
            if(current_step == 3) {              
              if (_formKey.currentState.validate()) {
                checkConnectivity();
                if (this._internet_result == true) {
                waytopick = checkWayPick();
                waytopay = checkWayPay();
                mailIt2(model, name, phone, address, _deliveryResult, _payResult);
                model.updateCustomerOrders();
                //mailIt(model, name, phone, address, _deliveryResult, _payResult);
                _ackAlert(context, model);
                }
                 else {
                   _noInternetConnection(context);
                 } 
              } 
              current_step = 0;
            }
            } else {
              current_step = 0;
            }
          });
          // Log function call
          print("onStepContinue : " + current_step.toString());
        },
           ),
      );
            }
      ),
      ),
    );
  }

Widget FirstForm() {

  return Form(
      autovalidate: false,
      key: _formKey,
      child: Column(
          verticalDirection: VerticalDirection.down,
          //crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[  
            Container(             
                        child: Column(children: <Widget>[
                                TextFormField(
                                  //expands: true,
                                  //enableInteractiveSelection: true,
                                  cursorColor: Colors.green,
                                  autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Имя",
                        labelText: "Ваше Имя",
                        icon: Icon(GroovinMaterialIcons.account, color: Colors.orange),
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
                    controller: this.phonecontroller,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        icon: Icon(Icons.phone, color: Colors.green),
                        hintText: "7 (xxx)-xxx-xx-xx",
                       labelText: "Номер телефона",
                      ),
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'Введите номер телефона';
                        }
                        else {
                          phone = value;
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.location_city, color: Colors.red),
                        hintText: "Адрес",
                        labelText: "Ваш Адрес"
                      ),                       
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'Введите ваш Адрес';
                        }
                        else {
                          address = value;
                          checkConnectivity();
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




bool isNumeric(String s)  {
  try
  {
    return double.parse(s) != null;
  }
  catch (e)
  {
    return false;
  }
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

mailIt(AppStateModel model, name, phone, address, waytopick, waytopay) async {
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
    ..recipients.add('worlddelete0@gmail.com')
    ..recipients.add('ris.testo@mail.ru')
    ..subject = 'Заказ с приложения Рис и Тесто :: 😀 :: ${new DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<h1>Товаров заказано: ${model.totalCartQuantity}</h1>\n<p>${model.totalProductsInCartName} : ${model.totalProductsInCartQuantity}</p> <p>$name, $phone, $address</p> <p>$waytopick, $waytopay</p>";

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

  mailIt2(AppStateModel model, name, phone, address, waytopick, waytopay) async {

    /// Initialize the API
    WooCommerceAPI wc_api = new WooCommerceAPI(
        "http://worlddelete.ru/risitesto",
        "ck_07a643e5cb2fe5088d880bc6aba20db513cae159",
        "cs_e84f4bb389cccf2260b0f864fdda145606c3c0f4"
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {

      List productsCart = [];
      model.productsInCart.keys
        .map(
          (id) {
      productsCart.add({"product_id" : id, "quantity" : model.productsInCart[widget.allproducts.firstWhere((p) => p['id'] == id)['id']]});
          }
        ).toList();
      
    var response = await wc_api.postAsync(
      // "customers",
      // {
      //   "email": 'naken505@gmail.com',
      //   "password": "123",
      //   "billing": {
      //     "first_name": "$name",
      //   }
      // },
      "orders",
      {
  "customer_id": prefs.getInt('id'),
  "payment_method": "RUB",
  "payment_method_title": "$waytopay",
  "status": "processing",
  // "set_paid": true,
  "billing": {
    "first_name": "$name",
    //"last_name": "505",
    "address_1": "$waytopay",
    // "address_2": "$waytopay",
    //"city": "San Francisco",
    //"state": "CA",
    //"postcode": "94103",
    "country": "Страна: Россия",
    //"email": "john.doe@example.com",
    "phone": "$phone"
  },
  "shipping": {
    // "first_name": "",
    // "last_name": "Doe",
    "address_1": "$address, ",
    "address_2": "$waytopick",
    // "city": "San Francisco",
    // "state": "CA",
    // "postcode": "94103",
    // "country": "RU"
  },
  
  "line_items": productsCart,
      },
    );
    print(response); // JSON Object with response


  //   var createCustomer = await wc_api.postAsync(
  //   "customers",
  //     {
  //       "email": "noemail@examle.com",
  //       "first_name": "$name",
  //       "username": "$phone",
  //       "billing": {
  //         "first_name": "$name",
  //         "country": "Russia",
  //         "phone": "$phone",
  //       },
  //       "shipping": {
  //         "first_name": "$name",
  //         "addresss_1": "$address",
  //         "country": "Russia"
  //       }
  //     },
  // );
  // print(createCustomer);
  
  } catch (e) {
    print(e);
  }

  

  }



  Future<void> _ackAlert(BuildContext context, model) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black87,
        shape: new RoundedRectangleBorder(
         borderRadius: new BorderRadius.circular(30.0)),
        title: Text('Ваш заказ подтвержден!',
        style: TextStyle(
          color: Colors.white,
        )
        ),
        content: ProgressWidget(),
        actions: <Widget>[
          MaterialButton(
            height: 50,
            minWidth: 120,
            color: Colors.orange,
            shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
            child: Text(
              'Продолжить',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w700,
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

}

class ProgressWidget extends StatefulWidget {
  ProgressWidget({Key key, this.title,}) : super(key: key);
  final String title;
  @override
  _ProgressWidgetState createState() => new _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
  var _progress = 50.0;
  var _color_rate = Colors.white;

  setColorRate(value) {
    if(value <= 40) {
      _color_rate = Colors.red;
    }
    else if (value > 40 && value <= 70) {
      _color_rate = Colors.yellow;
    }
    else if (value > 70 ) {
      _color_rate = Colors.lightGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Оцените качество наших услуг!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            )
            ),
            Container(padding: EdgeInsets.only(bottom:19)),
            WaveProgress(180.0, Colors.white, _color_rate, _progress),
            Container(
              margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Slider(
                activeColor: Colors.orange,
                inactiveColor: Colors.white,
                  max: 100.0,
                  min: 0.0,
                  value: _progress,
                  onChanged: (value) {
                    setState(() => _progress = value);
                    setColorRate(value);
                  }),
            ),
            Text(
              '${_progress.round()}',
              style: TextStyle(color: _color_rate, fontSize: 40.0),
            )
          ],
        ),
      );
  }
}

