import 'package:Shrine/app.dart';
import 'package:Shrine/shopping_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'home.dart';
import 'model/app_state_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:badges/badges.dart';

class ProductsMenu extends StatefulWidget {
 
  @override
  _ProductsMenuAppState createState() => _ProductsMenuAppState();
}

class _ProductsMenuAppState extends State<ProductsMenu> {

  AppStateModel model;
  bool _visible = true;

@override
Widget build(BuildContext context) {
  
  return ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              List cat = model.products_categories.where((cat) => cat['name'] != 'Акции',).toList();
              List categories = cat.where((cat) => cat['name'] != 'Uncategorized',).toList();

   return Scaffold(
    appBar: AppBar(
      actions: <Widget>[  
          // padding: EdgeInsets.only(right: 10), 
        Badge(
      position: BadgePosition.topRight(top: 0, right: 3),
      animationDuration: Duration(seconds: 1),
      animationType: BadgeAnimationType.scale,
      badgeContent: Text('${model.totalCartQuantity}',
      style: TextStyle(
        color: Colors.white,
      ),
      ),
      child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShoppingCartPage(),
                  ),
                );
      }),
    ),

      ],
      
      title: Text('Меню доставки'),
    ),
    body: Center(
      child: Container(
        color: Colors.white60,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: categories.length,
          itemBuilder: (_, index) {

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductsMenuItem(
                      name: categories[index]['name'],
                      slug: categories[index]['slug'],
                    ),
                  ),
                );
              },
            child: Card(
              elevation: 30,
              // height: 200,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.rectangle,
            //  image: DecorationImage(
            //             image: NetworkImage(categories[index]["image"]["src"]),
            //  ),
            //   ),

                    child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      
                    Container(
                    height: 100,
                    width: 100,
                    child: CachedNetworkImage(
                    imageUrl: categories[index]["image"]["src"],
                    placeholder: (context, url) => new CircularProgressIndicator(),
                    ),
                    // child: Text('${categories[index]["image"]["src"]}'),
                  ),
                    Text(
                      '${categories[index]['name']}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '(${categories[index]['count']})',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],),
                    ),
                  
            ),    
            );
          }
        ),
      ),
    ),
  );
            }
  );
}
}

class ProductsMenuItem extends StatefulWidget {

  ProductsMenuItem({this.name, this.slug});

  String name;
  String slug;
 
  @override
  _ProductsMenuItemAppState createState() => _ProductsMenuItemAppState();
}

class _ProductsMenuItemAppState extends State<ProductsMenuItem> {

@override
Widget build(BuildContext context) {
   return ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
  return Scaffold(
    appBar: AppBar(
      actions: <Widget>[  
          // padding: EdgeInsets.only(right: 10), 
        Badge(
      position: BadgePosition.topRight(top: 0, right: 3),
      animationDuration: Duration(milliseconds: 500),
      animationType: BadgeAnimationType.scale,
      badgeContent: Text('${model.totalCartQuantity}',
      style: TextStyle(
        color: Colors.white,
      ),
      ),
      child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShoppingCartPage(),
                  ),
                );
      }),
    ),

      ],
      title: Text('${widget.name}'),
    ),
    body: ProductPage('${widget.slug}'),
  );
            }
   );
}


}