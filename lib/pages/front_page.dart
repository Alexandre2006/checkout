import 'package:checkout/globals.dart' as globals;
import 'package:checkout/services/auth/get_redirect.dart';
import 'package:checkout/services/routing/auth_redirect.dart';
import 'package:checkout/shared/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getAuthRedirect(true, false).then((value) {
        if (value == null) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else if (value != "/notauthed") {
          Navigator.pushReplacementNamed(context, value);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(pageTitle: "Yearbook Checkout"),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 250,
            maxWidth: 500,
            minHeight: 200,
            minWidth: 400,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey[900]?.withAlpha(200),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Sign in to continue",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Sign In",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    globals.supabase.auth.signInWithOAuth(
                      Provider.google,
                      redirectTo: getRedirectURI(),
                    );
                  },
                ),
                Text(
                  "You must sign in with your @menloschool.org email",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
