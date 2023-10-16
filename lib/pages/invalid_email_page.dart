import 'package:checkout/globals.dart' as globals;
import 'package:flutter/material.dart';

class InvalidEmailPage extends StatelessWidget {
  const InvalidEmailPage({super.key});

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
                  "You've signed in with an invalid email!",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Please use your menlo email when signing in",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 32,
                ),
                FilledButton.icon(
                  onPressed: () {
                    globals.supabase.auth.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    );
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
