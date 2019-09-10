import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'app.dart';
import 'shopping_cart.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class StockPage extends StatefulWidget {

  StockPage(this.allproducts, this.products_stocks);

  List allproducts;
  List products_stocks;

  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {

  //    fetchPosts() async {
  //     WordPressAPI api = WordPressAPI('http://worlddelete.ru/risitesto');
  //     final res = await api.getAsync('posts');
  //     return res['data'];
  // }


  @override
  Widget build(BuildContext context) {
    // fetchPosts();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Акции'),
        centerTitle: true,
      ),
      body: stockPage(context),
    );
  }


Widget stockPage(BuildContext context) {
  return Container(
        child: ListView.builder(
        itemCount: widget.products_stocks.length,
        itemBuilder: (_, index) {
      
      return bodyWidget(context, index, Colors.red, "${widget.products_stocks[index]['name']}",
      "${widget.products_stocks[index]['description']}",);
      // bodyWidget(context, Icons.drive_eta, Colors.green, "Самовывоз - 15%!",
      // "Заберите свой заказ сами и получите скидку в размере 15%!",),
    
        },
      ),
  );
}

Widget bodyWidget(BuildContext context,
index, sColor, sheader, sdesc
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
        stockCardContent(context, sheader, sdesc),
        stockThumbnail(context, index, sColor),
      ],
    )
  ); 
}

Widget stockThumbnail(BuildContext context, index,  sColor) {
  return Container(
  margin: new EdgeInsets.symmetric(
    vertical: 16.0
  ),
  alignment: FractionalOffset.centerLeft,
  child: Image.network(widget.products_stocks[index]["images"][0]["src"],
    width: 160,
    height: 160,
  )
);
}

Widget stockCard(BuildContext context) {
    
  // double width =  MediaQuery.of(context).size.width;
    return Container(
     width: 400,
     height: 120,
     margin: new EdgeInsets.only(left: 30.0, top: 40),
     decoration: new BoxDecoration(
       color: Colors.blue,
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
    double width = 500;

  return Container(
    height: 100,
    width: 600,
      margin: new EdgeInsets.fromLTRB(160.0, 50.0, 16.0, 16.0),
      //constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(
            sheader,
            style: TextStyle(
              color: Colors.black,
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
              color: Colors.black,
            ),
            ),
        ],
      ),
  );
  }

}