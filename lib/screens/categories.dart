import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';

import '../models/meal.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  
  final List<Meal> availableMeals;

  void _selectCategory(BuildContext context, Category category) {    //pass BuildContext as parameter   //since build method is not provided globally by stateless widget unlike sstateful widget so we mannually accept here
    final filteredMeals = availableMeals                                           //dummyMeals.where initially when no filter is there// 
        .where((Meal) => Meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(      //Navigator.push(context ,route)
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
        padding: EdgeInsets.all(26),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          //availableCategories.map((category) => CategoryGridItem(category: category)).toList();            //alternative of for loop used below
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context , category);
              },
            ),
        ],
    );
  }
}
