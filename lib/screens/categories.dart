import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';

import '../models/meal.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController
      _animationController; //late tells the dart this variable will have a value as soon as its being used first time but not yet when class is created

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    //for cleaning purpose
    _animationController
        .dispose(); //ensure this enimination should be removed as soon as this widget get removed to avoid memory overflow
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    //pass BuildContext as parameter   //since build method is not provided globally by stateless widget unlike sstateful widget so we mannually accept here
    final filteredMeals = widget
        .availableMeals //dummyMeals.where initially when no filter is there//
        .where((Meal) => Meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      //Navigator.push(context ,route)
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
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
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
                _selectCategory(context, category);
              },
            ),
        ],
      ),
      // builder: (context, child) => Padding(
      //   padding: EdgeInsets.only(top: 100 - _animationController.value * 100),
      //   child: child,
      builder: (context, child) => SlideTransition(
        position: Tween(                  //initially _animationController.drive(Tween(  .... ))is used not with .animate()
          begin: const Offset(0, 0.3),
          end: const Offset(0, 0),
        ).animate(                         //.animate : it gives us more control how the animation work and to cutomise that
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        ),
        child: child,
      ),
    );
  }
}
