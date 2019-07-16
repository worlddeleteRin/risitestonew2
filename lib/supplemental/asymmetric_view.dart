// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';

import '../model/product.dart';
import 'product_columns.dart';

class AsymmetricView extends StatelessWidget {
  final List<Product> products;

  const AsymmetricView({Key key, this.products});

  List<Container> _buildColumns(BuildContext context) {
    /*if (products == null || products.isEmpty) {
      return const <Container>[];
    }
*/
    /// This will return a list of columns. It will oscillate between the two
    /// kinds of columns. Even cases of the index (0, 2, 4, etc) will be
    /// TwoProductCardColumn and the odd cases will be OneProductCardColumn.
    ///
    /// Each pair of columns will advance us 3 products forward (2 + 1). That's
    /// some kinda awkward math so we use _evenCasesIndex and _oddCasesIndex as
    /// helpers for creating the index of the product list that will correspond
    /// to the index of the list of columns.
    return List.generate(_listItemCount(products.length), (int index) {
      double width = .40 * MediaQuery.of(context).size.width;
      double height = 0.31 * MediaQuery.of(context).size.height;
      Widget column;
    
        /// Odd cases
        column = OneProductCardColumn(
          product: products[index],
        );
      
      return Container(
        height: height,
        width: width,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 0),
           child: column,
        ),
       // alignment: Alignment(0.0, 0.0),
      );
    }).toList();
  }


  int _listItemCount(int totalItems) {
    /*if (totalItems % 3 == 0) {
      return totalItems ~/ 3 * 2;
    } else {
      return (totalItems / 3).ceil() * 2 - 1;
    }*/
    return totalItems;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.fromLTRB(0.0, 3.0, 1.0, 4.0),
      children: _buildColumns(context),
      physics: AlwaysScrollableScrollPhysics(),
    );
  }
}
