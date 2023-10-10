import 'package:checkout/ui/pages/home.dart';
import 'package:checkout/ui/pages/signin.dart';
import 'package:flutter/material.dart';

final routes = <String, WidgetBuilder>{
  '/': (context) => const HomeScreen(),
  '/signin': (context) => const SignInPage(),
};
