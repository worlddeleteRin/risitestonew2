import 'package:flutter/material.dart';
import 'model/app_state_model.dart';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:Shrine/app.dart';
import 'package:wave_progress_widget/wave_progress_widget.dart';

class MyShopping extends StatefulWidget {
  @override
  MyShoppingState createState() => MyShoppingState();
}

class MyShoppingState extends State<MyShopping> {

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

  var _progress = 50.0;



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
],),
        // You can change the style of the step icon i.e number, editing, etc.
        state: StepState.editing,
        isActive: true),
    Step(
        title: Text("Способ оплаты"),
        content: Column(children: <Widget>[
        Row(children: <Widget>[
        Text('Оплата наличными',
        style: TextStyle(

        )
        ), 
        Checkbox(
  value: isSwitched3,
  onChanged: (value) {
    setState(() {
      isSwitched3 = value;
    });
  },
  activeColor: Colors.green,
),
],),
  Row(children: <Widget>[
        Text('Оплата картой курьеру',
        style: TextStyle(

        )
        ), 
        Checkbox(
  value: isSwitched4,
  onChanged: (value) {
    setState(() {
      isSwitched4 = value;
    });
  },
  activeColor: Colors.green,
),
],)
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
          setState(() {
            // update the variable handling the current step value
            // going back one step i.e adding 1, until its the length of the step
            if (current_step!= null) {
              current_step = current_step + 1;
            if(current_step == 3) {
              if (_formKey.currentState.validate()) {
                waytopick = checkWayPick();
                waytopay = checkWayPay();
                mailIt(model, name, phone, address, waytopick, waytopay);
                print("отправлено");
                _ackAlert(context, model); 
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
      autovalidate: true,
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[  
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),             
                        child: Column(children: <Widget>[
                                TextFormField(
                                  enableInteractiveSelection: true,
                                  cursorColor: Colors.green,
                                  autofocus: true,
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
    ..from = new Address(username, 'Your name')
    ..recipients.add('worlddelete0@gmail.com')
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

