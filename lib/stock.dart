import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'app.dart';
import 'shopping_cart.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'dart:math' as math;


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

String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
  }

Widget stockPage(BuildContext context) {
  
  return Container(
        child: ListView.builder(
        itemCount: widget.products_stocks.length,
        itemBuilder: (_, index) {
      var image = (widget.products_stocks[index]["images"][0]["src"]);
      String description = removeAllHtmlTags(widget.products_stocks[index]["description"]);

      return AwesomeListItem(
                    title: widget.products_stocks[index]["name"],
                    content: description,
                    color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0),
                    image: image,
                    );
      // return bodyWidget(context, index, Colors.red, "${widget.products_stocks[index]['name']}",
      // "$formatted_desc",);
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
        // stockCard(context),
        stockCardContent(context, sheader, sdesc),
        // stockThumbnail(context, index, sColor),
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

  return Card(
    
    // width: 600,
      margin: new EdgeInsets.fromLTRB(50.0, 20.0, 16.0, 16.0),
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
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 40,
            style: TextStyle(
              decorationStyle: TextDecorationStyle.dotted,
              fontSize: 13,
              color: Colors.black,
            ),
            ),
        ],
      ),
  );
  }

}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height / 4.75);
    p.lineTo(0.0, size.height / 3.75);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class AwesomeListItem extends StatefulWidget {
  String title;
  String content;
  Color color;
  String image;

  AwesomeListItem({this.title, this.content, this.color, this.image});

  @override
  _AwesomeListItemState createState() => new _AwesomeListItemState();
}

class _AwesomeListItemState extends State<AwesomeListItem> {
  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Container(width: 10.0, height: 190.0, color: widget.color),
        new Expanded(
          child: new Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  widget.title,
                  style: TextStyle(
                      fontFamily: 'Greece',
                      color: Colors.redAccent,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: new Text(
                    widget.content,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        new Container(
          height: 150.0,
          width: 150.0,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              new Transform.translate(
                offset: new Offset(50.0, 0.0),
                child: new Container(
                  height: 100.0,
                  width: 100.0,
                  color: widget.color,
                ),
              ),
              new Transform.translate(
                offset: Offset(10.0, 20.0),
                child: new Card(
                  elevation: 20.0,
                  child: new Container(
                    height: 120.0,
                    width: 120.0,
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 10.0,
                            color: Colors.white,
                            style: BorderStyle.solid),
                        image: DecorationImage(
                          image: NetworkImage(widget.image),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}