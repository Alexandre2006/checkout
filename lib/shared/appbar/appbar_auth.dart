import 'package:checkout/globals.dart' as globals;
import 'package:checkout/pages/dashboard.dart';
import 'package:checkout/pages/settings_page.dart';
import 'package:checkout/services/auth/get_redirect.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppBarAuth extends StatefulWidget {
  const AppBarAuth({super.key});

  @override
  State<AppBarAuth> createState() => _AppBarAuthState();
}

class _AppBarAuthState extends State<AppBarAuth> {
  @override
  Widget build(BuildContext context) {
    return globals.supabase.auth.currentUser == null
        ? _unAuthAppBar()
        : ModalRoute.of(context)?.settings.name == "/"
            ? _dashboardAppBar()
            : _authAppBar();
  }

  @override
  void initState() {
    super.initState();
    globals.supabase.auth.onAuthStateChange.listen((data) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
  }

  Widget _authAppBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 12.0),
          ),
        ),
        onPressed: ModalRoute.of(context)?.settings.name == '/settings'
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: CircleAvatar(
                radius: 24,
                foregroundImage: NetworkImage(
                  "${globals.supabase.auth.currentUser?.userMetadata?['avatar_url']}",
                ),
              ),
            ),
            if (MediaQuery.of(context).size.width > 520)
              Text(
                "${globals.supabase.auth.currentUser?.userMetadata?['name']}",
                style: const TextStyle(fontSize: 16),
              ),
            if (MediaQuery.of(context).size.width <= 520)
              const Icon(Icons.settings),
          ],
        ),
      ),
    );
  }

  Widget _dashboardAppBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilledButton.icon(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        },
        icon: const Text("Dashboard"),
        label: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _unAuthAppBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilledButton.icon(
        onPressed: () {
          globals.supabase.auth.signInWithOAuth(
            Provider.google,
            redirectTo: getRedirectURI(),
          );
        },
        icon: const Icon(Icons.login),
        label: const Text("Sign In"),
      ),
    );
  }
}
