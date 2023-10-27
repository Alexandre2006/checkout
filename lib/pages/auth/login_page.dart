import 'package:checkout/globals.dart' as globals;
import 'package:checkout/pages/dashboard/dashboard.dart';
import 'package:checkout/services/auth/get_redirect.dart';
import 'package:checkout/services/routing/auth_redirect.dart';
import 'package:checkout/shared/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getAuthRedirect(true, false).then((value) {
        if (value.runtimeType != LoginPage) {
          if (value != null) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => value),);
          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const DashboardPage()),);
          }
        }
      });
    });
    return Scaffold(
      appBar: const DefaultAppBar(pageTitle: "Yearbook Checkout"),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Please sign in to continue",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "You must be signed in with your @menloschool.org email",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 32,
                ),
                FilledButton.icon(
                  onPressed: () {
                    globals.supabase.auth.signInWithOAuth(
                      Provider.google,
                      redirectTo: getRedirectURI(),
                    );
                  },
                  icon: const Icon(Icons.login),
                  label: const Text("Sign In"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
