import 'package:checkout/globals.dart' as globals;
import 'package:flutter/material.dart';

class NotAdminPage extends StatelessWidget {
  const NotAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "You're not an admin!",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Only administrators can view this page ¯\\_(ツ)_/¯",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 32,
                ),
                FilledButton.icon(
                  onPressed: () {
                    if (globals.supabase.auth.currentUser != null) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/dashboard', (route) => false,);
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false,);
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Go Back"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
