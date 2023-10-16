import 'package:checkout/pages/dashboard.dart';
import 'package:checkout/pages/front_page.dart';
import 'package:checkout/pages/invalid_email_page.dart';
import 'package:checkout/pages/new_checkout.dart';
import 'package:checkout/pages/not_admin_page.dart';
import 'package:checkout/pages/not_authed_page.dart';
import 'package:checkout/pages/settings_page.dart';
import 'package:flutter/material.dart';

final routes = <String, WidgetBuilder>{
  // Main Pages
  '/': (context) => const FrontPage(),
  '/dashboard': (context) => const DashboardPage(),
  '/settings': (context) => const SettingsPage(),

  // Creation Pages
  '/newcheckout': (context) => const NewCheckoutPage(),

  // Error Pages
  '/notadmin': (context) => const NotAdminPage(),
  '/notauthed': (context) => const NotAuthedPage(),
  '/invalidemail': (context) => const InvalidEmailPage(),
};
