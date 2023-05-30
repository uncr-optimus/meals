import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

const kInitialFilter = {
     Filter.glutenFree : false,
     Filter.lactoseFree : false,
     Filter.vegetarian :false,
     Filter.vegan :false
  };

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favouriteMeal = [];

  Map<Filter,bool> _selectedFilters = kInitialFilter;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavouriteStatus(Meal meal) {
    final isExisting = _favouriteMeal.contains(meal);
    if (isExisting) {
      setState(() {
        // set state helps us to instant update the UI state as moment as we press the button
        _favouriteMeal.remove(meal);
      });
      _showInfoMessage('meal is removed from favourite');
    } else {
      setState(() {
        _favouriteMeal.add(meal);
      });
      _showInfoMessage('meal is added to favourite');
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async{
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter,bool>>(          //check the return type of push here ,it is mentioned it will return future
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(currentFilters: _selectedFilters,),
        ),
      );
      print(result);
      setState(() {
        _selectedFilters = result ?? kInitialFilter;      //?? special operator use like ternary expression in case if result is null
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final availableMeals = dummyMeals.where((meals){
       if(_selectedFilters[Filter.glutenFree]! && !meals.isGlutenFree)
       return false;
       if(_selectedFilters[Filter.lactoseFree]! && !meals.isLactoseFree)
       return false;
       if(_selectedFilters[Filter.vegetarian]! && !meals.isVegetarian)
       return false;
       if(_selectedFilters[Filter.vegan]! && !meals.isVegan)
       return false;

       return true;
       },).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavourite: _toggleMealFavouriteStatus,
      availableMeals: availableMeals,
    );

    var activePageTitle = 'CategoriesScreen';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favouriteMeal,
        onToggleFavourite: _toggleMealFavouriteStatus,
      );
      activePageTitle = 'Your Favourite';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap:
            _selectPage, //initially we are pasing index here but then we got function _selectPage
        currentIndex:
            _selectedPageIndex, //for visibility of selected category screen icon
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourite'),
        ],
      ),
    );
  }
}
