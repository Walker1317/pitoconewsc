import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  pageTransitionsTheme:  PageTransitionsTheme(
    builders: kIsWeb ? {
        for (final platform in TargetPlatform.values)
          platform:const NoTransitionsBuilder(),
      }
    : const {
    },
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 33, 62, 165)),
  scrollbarTheme: ScrollbarThemeData(
    thickness: MaterialStateProperty.all(20),
    thumbColor: MaterialStateProperty.all(const Color.fromARGB(255, 33, 62, 165))
  ),
  useMaterial3: true,
  iconTheme: const IconThemeData(color: Colors.white),
  scaffoldBackgroundColor: const Color(0xff282828),
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.transparent,
    backgroundColor: Color(0xff282828),
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontFamily: 'GothamBlack'),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      disabledBackgroundColor: Colors.white60,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white,),
    headlineSmall: TextStyle(color: Colors.white,),
  ),
  fontFamily: 'GothamBlack',
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromARGB(255, 33, 62, 165),
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white30,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromARGB(255, 33, 62, 165),
      ),
    ),
  ),
);

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget? child,
  ) {
    // only return the child without warping it with animations
    return child!;
  }
}