import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meals/screens/tabs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(
    const ProviderScope(        //wraping with provider is necessary beacause to unlock the behind the scene state management functionality at the end
      child: App(),             //since wraping the App() ensure all the widget can use this riverpod package
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      //home: const CategoriesScreen(),
      home:
          const TabsScreen(), //previously we are having categoriesScreen here but now we fix tab in intermidiate and we are visiting categories screen via tabscreen
      // Todo ...,
    );
  }
}
