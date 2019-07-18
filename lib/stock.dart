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
      body: Text('Здесь будут все акции',
      textAlign: TextAlign.center,),
    );
  }
}