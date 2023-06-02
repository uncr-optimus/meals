import 'package:flutter/material.dart';
import 'package:meals/providers/favorites_provider.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/filters_provider.dart';

const kInitialFilter = {
     Filter.glutenFree : false,
     Filter.lactoseFree : false,
     Filter.vegetarian :false,
     Filter.vegan :false
  };

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;


  // void _toggleMealFavouriteStatus(Meal meal) {
  //   final isExisting = _favouriteMeal.contains(meal);
  //   if (isExisting) {
  //     setState(() {
  //       // set state helps us to instant update the UI state as moment as we press the button
  //       _favouriteMeal.remove(meal);
  //     });
  //     //_showInfoMessage('meal is removed from favourite');
  //   } else {
  //     setState(() {
  //       _favouriteMeal.add(meal);
  //     });
  //     //_showInfoMessage('meal is added to favourite');
  //   }
  // }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async{
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter,bool>>(          //check the return type of push here ,it is mentioned it will return future
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final availableMeals = ref.watch(filteredMealsProvider);
    Widget activePage = CategoriesScreen(
      
      availableMeals: availableMeals,
    );

    var activePageTitle = 'CategoriesScreen';

    if (_selectedPageIndex == 1) {
      final _favouriteMeal = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: _favouriteMeal,
        
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
