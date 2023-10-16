import 'package:flutter/material.dart';

class NotAuthedPage extends StatelessWidget {
  const NotAuthedPage({super.key});

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
                  "You're not signed in!",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "You must be signed in to view this page ¯\\_(ツ)_/¯",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 32,
                ),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false,);
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
