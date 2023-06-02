import 'package:riverpod/riverpod.dart';
import 'package:meals/providers/meals_provider.dart';
enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.vegan: false,
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
        });
  void setFilters(Map<Filter,bool> choodenFilters){
    state = choodenFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
        (ref) => FiltersNotifier());

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((meals){
       if(activeFilters[Filter.glutenFree]! && !meals.isGlutenFree)
        return false;
       if(activeFilters[Filter.lactoseFree]! && !meals.isLactoseFree)
        return false;
       if(activeFilters[Filter.vegetarian]! && !meals.isVegetarian)
        return false;
       if(activeFilters[Filter.vegan]! && !meals.isVegan)
        return false;

       return true;
       },).toList();
});