import 'package:flutter/material.dart';

class StockPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Акции'),
        centerTitle: true,
      ),
      body: stockPage(context),
    );
  }
}

Widget stockPage(BuildContext context) {
  return Container(
    color: Color(0xFF333359),
  child: ListView(
    //verticalDirection: VerticalDirection.down,
    children: <Widget>[
      bodyWidget(context, Icons.cake, Colors.red, "День рождение? Скидка 20%!",
      "Порадуйте себя в ваш день рождения! Закажите свою любимую пиццу, сет или роллы со скидкой 20%!",),
      bodyWidget(context, Icons.drive_eta, Colors.green, "Самовывоз - 15%!",
      "Заберите свой заказ сами и получите скидку в размере 15%!",),
      bodyWidget(context, Icons.local_dining, Colors.yellow, "Скидка на роллы 20%!",
      "Самая жаркая акция этого лета! Получи скидку на все роллы в размере 20%! Акция длится до 8 августа.",),
    ],
  ),
  );
}

Widget bodyWidget(BuildContext context,
sIcon, sColor, sheader, sdesc
) {
  double width = .40 * MediaQuery.of(context).size.width;
  return new Container(
    width: width,
    //height: 150.0,
    margin: const EdgeInsets.symmetric(
      vertical: 16.0,
      horizontal: 24.0,
    ),
    child: new Stack(
      children: <Widget>[
        stockCard(context),
        stockThumbnail(context, sIcon, sColor),
        stockCardContent(context, sheader, sdesc),
      ],
    )
  ); 
}

Widget stockThumbnail(BuildContext context, sIcon, sColor) {
  return Container(
  margin: new EdgeInsets.symmetric(
    vertical: 16.0
  ),
  alignment: FractionalOffset.centerLeft,
  child: Icon(
    sIcon,
    size: 100,
    color: sColor,
    ),
);
}

Widget stockCard(BuildContext context) {
  double width = .40 * MediaQuery.of(context).size.width;
    return Container(
     width: width,
     margin: new EdgeInsets.only(left: 40.0),
     decoration: new BoxDecoration(
       color: new Color(0xFF333366),
       shape: BoxShape.rectangle,
       borderRadius: new BorderRadius.circular(8.0),
       boxShadow: <BoxShadow>[
         new BoxShadow(  
          color: Colors.black12,
          blurRadius: 10.0,
          offset: new Offset(0.0, 10.0),
        ),
      ],
    ),
  );
}


  Widget stockCardContent(BuildContext context, sheader, sdesc) {
  return Container(
      margin: new EdgeInsets.fromLTRB(100.0, 16.0, 16.0, 16.0),
      //constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(
            sheader,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w600
            ),
          ),
          new Container(height: 10.0),
          new Text(
            sdesc,
            softWrap: true,
            maxLines: 40,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            ),
        ],
      ),
  );
  }