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
  return ListView.builder(
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
                else {
                  return orders[index]['status'];
                }
              };
              return Container(
                child: Card(
                  child: Column(children: <Widget>[
                    Text('Заказ №'),
                    Text('${orders[index]["number"]}',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                    ),
                    Text('Статус:'),
                    Text('${getStatus()}',
                    style: TextStyle(
                      fontSize: 20,
                      color: _status_color,
                    ),
                    ),
                    Text('Сумма заказа:'),
                    Text('${orders[index]['total']}',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.green,
                    ),
                    ),
                  ],),
                ),
              );
            }
  );
}
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
        return ListView(children: <Widget>[
          Text(
            '${meta_bonus}',
          )
        ],);
      } 
      );
  }

}
