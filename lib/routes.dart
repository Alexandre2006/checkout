import 'package:checkout/pages/dashboard.dart';
import 'package:checkout/pages/errors/invalid_email_page.dart';
import 'package:checkout/pages/errors/not_admin_page.dart';
import 'package:checkout/pages/new_checkout.dart';
import 'package:checkout/pages/login_page.dart';
import 'package:checkout/pages/settings_page.dart';
import 'package:flutter/material.dart';

final routes = <String, WidgetBuilder>{
  // Main Pages
  '/dashboard': (context) => const DashboardPage(),
  '/settings': (context) => const SettingsPage(),
  '/login': (context) => const LoginPage(),

  // Creation Pages
  '/newcheckout': (context) => const NewCheckoutPage(),

  // Error Pages
  '/notadmin': (context) => const NotAdminPage(),
  '/invalidemail': (context) => const InvalidEmailPage(),
};
