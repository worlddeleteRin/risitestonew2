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
import 'package:scoped_model/scoped_model.dart';

import 'colors.dart';
import 'model/app_state_model.dart';
import 'model/product.dart';

class CategoryMenuPage extends StatelessWidget {
  final List<Category> _categories = Category.values;
  final VoidCallback onCategoryTap;

  const CategoryMenuPage({
    Key key,
    this.onCategoryTap,
  }) : super(key: key);

  Widget _buildCategory(Category category, BuildContext context) {
    final categoryString =
        category.toString().replaceAll('Category.', '').toUpperCase();
    final ThemeData theme = Theme.of(context);
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => GestureDetector(
            onTap: () {
              model.setCategory(category);
              if (onCategoryTap != null) onCategoryTap();
            },
            child: model.selectedCategory == category
                ? Column(
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      Text(
                        categoryString,
                        style: theme.textTheme.body2,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 14.0),
                      Container(
                        width: 70.0,
                        height: 2.0,
                        color: kShrineBrown900,
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      categoryString,
                      style: theme.textTheme.body2
                          .copyWith(color: kShrineBrown900.withAlpha(153)),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 100.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/menu_background.jpg'),
            fit: BoxFit.fitHeight,
          )
        ),
        //color: Colors.black87,
        child: ListView(
            children: <Widget>[
              _buildAll(Category.all, context),
              _buildPizza(Category.pizza, context),
              _buildRolls(Category.rolls, context),
              _buildSets(Category.sets, context),
              _buildDrinks(Category.drinks, context),
              _buildSupplements(Category.supplements, context),
            ]
                ),
      ),
    );
  }

Widget _buildPizza(Category category, BuildContext context) {
    final categoryString =
        category.toString().replaceAll('Category.', '').toUpperCase();
    final ThemeData theme = Theme.of(context);
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => GestureDetector(
            onTap: () {
              model.setCategory(category);
              if (onCategoryTap != null) onCategoryTap();
            },
            child: model.selectedCategory == category
                ? Column(
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      new Text(
                        'Пицца',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 14.0),
                      Container(
                        width: 100.0,
                        height: 2.0,
                        color: Colors.red,
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Пицца',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'Literata',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
    );
  }
  Widget _buildAll(Category category, BuildContext context) {
    final categoryString =
        category.toString().replaceAll('Category.', '').toUpperCase();
    final ThemeData theme = Theme.of(context);
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => GestureDetector(
            onTap: () {
              model.setCategory(category);
              if (onCategoryTap != null) onCategoryTap();
            },
            child: model.selectedCategory == category
                ? Column(
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      Text(
                        'Весь товар',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 14.0),
                      Container(
                        width: 100.0,
                        height: 2.0,
                        color: Colors.red
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Весь товар',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
    );
  }
  Widget _buildRolls(Category category, BuildContext context) {
    final categoryString =
        category.toString().replaceAll('Category.', '').toUpperCase();
    final ThemeData theme = Theme.of(context);
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => GestureDetector(
            onTap: () {
              model.setCategory(category);
              if (onCategoryTap != null) onCategoryTap();
            },
            child: model.selectedCategory == category
                ? Column(
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      Text(
                        'Роллы',
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 14.0),
                      Container(
                        width: 100.0,
                        height: 2.0,
                        color: Colors.red,
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Роллы',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
    );
  }
  Widget _buildSets(Category category, BuildContext context) {
    final categoryString =
        category.toString().replaceAll('Category.', '').toUpperCase();
    final ThemeData theme = Theme.of(context);
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => GestureDetector(
            onTap: () {
              model.setCategory(category);
              if (onCategoryTap != null) onCategoryTap();
            },
            child: model.selectedCategory == category
                ? Column(
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      Text(
                        'Сэты',
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 14.0),
                      Container(
                        width: 100.0,
                        height: 2.0,
                        color: Colors.red,
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Сэты',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
    );
  }
  Widget _buildDrinks(Category category, BuildContext context) {
    final categoryString =
        category.toString().replaceAll('Category.', '').toUpperCase();
    final ThemeData theme = Theme.of(context);
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => GestureDetector(
            onTap: () {
              model.setCategory(category);
              if (onCategoryTap != null) onCategoryTap();
            },
            child: model.selectedCategory == category
                ? Column(
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      Text(
                        'Напитки',
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 14.0),
                      Container(
                        width: 100.0,
                        height: 2.0,
                        color: Colors.red,
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Напитки',
                     style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
    );
  }
  Widget _buildSupplements(Category category, BuildContext context) {
    final categoryString =
        category.toString().replaceAll('Category.', '').toUpperCase();
    final ThemeData theme = Theme.of(context);
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => GestureDetector(
            onTap: () {
              model.setCategory(category);
              if (onCategoryTap != null) onCategoryTap();
            },
            child: model.selectedCategory == category
                ? Column(
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      Text(
                        'Добавки',
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 14.0),
                      Container(
                        width: 100.0,
                        height: 2.0,
                        color: Colors.red,
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Добавки',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
    );
  }
}
