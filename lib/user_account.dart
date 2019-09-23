import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'model/app_state_model.dart';

class UserAccount extends StatefulWidget {


  @override
  _UserAccountState createState() => new _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {

  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        // return Scaffold(
        //   body: CustomScrollView(
        //     slivers: <Widget>[
        //       SliverAppBar(
        //         title: Text('Профиль'),
        //         expandedHeight: 180,
        //       ),
        //     ],
        //   )
        // );
      return Scaffold(
    body: DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              title: Text('Профиль'),
              expandedHeight: 180,
              backgroundColor: Colors.black87,
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.supervised_user_circle), text: "Профиль"),
                  Tab(icon: Icon(Icons.message), text: "Заказы"),
                  Tab(icon: Icon(Icons.brightness_high), text: "Бонусы"),
                ],
              ),
              pinned: true,
              floating: true,
            ),
          ];
        },
        body: TabBarView(
          children: [
            Text('Информация о профиле'),
            OrdersPage(),
            BonusPage(),
          ],
        ),
      ),
    ),
  );
      }
    );
  }

}

class OrdersPage extends StatefulWidget {

  @override
  _OrdersPageState createState() => new _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

   var _status_color;

Widget build(BuildContext context) {
  return ScopedModelDescendant<AppStateModel>(
    builder: (context, child, model) {
      List orders = model.customer_orders;
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.1, 0.6, 0.7, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.indigo[300],
            Colors.indigo[200],
            Colors.lime[200],
            Colors.lime[300],
          ],
        ),
        ),
     child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (BuildContext context,index){
              String getStatus() {
                if (orders[index]['status'] == 'completed') {
                  _status_color = Colors.green;
                  return 'Выполнен';
                }
                else if(orders[index]['status'] == 'processing') {
                  _status_color = Colors.orange;
                  return 'В процессе';
                }
                else if(orders[index]['status'] == 'refunded') {
                  _status_color = Colors.red;
                  return 'Возвращен';
                }
                else if(orders[index]['status'] == 'pending') {
                  _status_color = Colors.orange;
                  return 'В ожидании оплаты';
                }
                else if(orders[index]['status'] == 'on-hold') {
                  _status_color = Colors.orange;
                  return 'На удержании';
                }
                else if(orders[index]['status'] == 'cancelled') {
                  _status_color = Colors.red;
                  return 'Отменен';
                }
                else if(orders[index]['status'] == 'failed') {
                  _status_color = Colors.red;
                  return 'Не удался';
                }
                else {
                  return orders[index]['status'];
                }
              };
              return Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                  margin: EdgeInsets.only(top: 20),
                  child: Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    child: InkWell(
                  splashColor: Colors.yellow[700],
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => OrdersDetailPage(
        current_order: orders[index],
        number: orders[index]['number'],
        status: getStatus(),
        total: orders[index]['total'],
        first_name: orders[index]['billing']['first_name'],
        address_1: orders[index]['shipping']['address_1'],
        address_2: orders[index]['shipping']['address_2'],
        phone: orders[index]['billing']['phone'],
        payment_method_title: orders[index]['payment_method_title'],
        line_items: orders[index]['line_items'],
        )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    Column(
                      children: <Widget>[
                    // Text('${orders[index]['date_completed']}',),
                    Text('Заказ №'),
                    Text('${orders[index]["number"]}',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                    ),
                    ],),
                    Container(margin: EdgeInsets.only(right: 90, )),
                    Column(  
                    children: <Widget>[
                    Text('Статус:'),
                    Text('${getStatus()}',
                    style: TextStyle(
                      fontSize: 18,
                      color: _status_color,
                    ),
                    ),
                    Text('Сумма заказа:'),
                    Text('${orders[index]['total']}',
                    style: TextStyle(
                      fontSize: 20,
                      // fontFamily: '',
                      color: Colors.green,
                    ),
                    ),
                    ],),
                  ],),
                    ),
                  ),
                ),
              );
            }
     ),
  );
}
 ); 
}

}


class OrdersDetailPage extends StatefulWidget {

  OrdersDetailPage(
    {
    this.current_order,
    this.number,
    this.status,
    this.total,
    this.first_name,
    this.address_1,
    this.address_2,
    this.phone,
    this.payment_method_title,
    this.line_items,
    }

);

  var current_order;
  var number;
  String status;
  var total;
  String first_name;
  String address_1;
  String address_2;
  String phone;
  String payment_method_title;
  List line_items;


  @override
  _OrdersDetailPageState createState() => new _OrdersDetailPageState();
}

class _OrdersDetailPageState extends State<OrdersDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Заказ № ${widget.number}',
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          Column(
            children: <Widget>[
            Text(
              'Клиент: '
            ),
            Container(
              child: Text(
                '${widget.first_name}'
              ),
            ),
          ],),
          Column(children: <Widget>[
            Text(
              'Адрес: '
            ),
            Container(
              child: Text(
                '${widget.address_1}'
              ),
            ),
          ],),
          Column(children: <Widget>[
            Text(
              'Способ доставки: '
            ),
            Container(
              child: Text(
                '${widget.address_2}'
              ),
            ),
          ],),
          Column(children: <Widget>[
            Text(
              'Способ оплаты: '
            ),
            Container(
              child: Text(
                '${widget.payment_method_title}'
              ),
            ),
          ],),
          Column(children: <Widget>[
            Text(
              'Телефон: '
            ),
            Container(
              child: Text(
                '${widget.phone}'
              ),
            ),
          ],)
        ],)
      )
    );
  }

}



class BonusPage extends StatefulWidget {

  @override
  _BonusPageState createState() => new _BonusPageState();
}

class _BonusPageState extends State<BonusPage> {

  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        List meta = model.customersList.firstWhere((c) => c['id'] == model.current_user_id)['meta_data'];
        var meta_bonus = meta.firstWhere((b) => b['key'] == 'hp_woo_rewards_points')['value'];
        return Scaffold(
         body: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 100),
          child: Column(children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
            color: Colors.black87,
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
            Row(
              
              children: <Widget>[
                Text('Рис & Тесто',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 19,
                  fontFamily: 'SenseiMedium',
                ),
                ),
            ],),
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('$meta_bonus',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.green[400],
                  fontWeight: FontWeight.w600,
                ),
                ),
                Text(
                  '  БОНУСОВ',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.lightBlueAccent,
                  ),
                )
            ],),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
              Text(
                'Персональная карта',
                style: TextStyle(
                  color: Colors.white,
                )
              )
            ],)
            ],),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
            color: Colors.orange,
            splashColor: Colors.black,
            child: Text(
              'Подробнее о бонусах',
              style: TextStyle(
                color: Colors.white,
              )
            ),
            onPressed: () {

            },
          ),
          ),
          ],)
          ),
        );
      } 
      );
  }

}

class BonusPageWrapper extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Бонусы'),
      ),
      body: BonusPage()
    );
  }
}
