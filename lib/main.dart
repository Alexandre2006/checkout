import 'package:checkout/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://cxeemzhxqpvhnmjcnmgm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN4ZWVtemh4cXB2aG5tamNubWdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTY2NDY0ODksImV4cCI6MjAxMjIyMjQ4OX0.6LQRrXkUFU6qxKgtWKd4MVjGWkTeHoOFgJ_lDwFHRrE',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MaterialApp(
      title: 'Yearbook Checkout',
      initialRoute: '/signin',
      routes: routes,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    ));
  }
}
