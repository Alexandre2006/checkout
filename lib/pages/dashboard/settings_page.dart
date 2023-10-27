import 'package:checkout/globals.dart' as globals;
import 'package:checkout/pages/auth/login_page.dart';
import 'package:checkout/services/routing/auth_redirect.dart';
import 'package:checkout/shared/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getAuthRedirect(true, false).then((value) {
        if (value != null) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => value));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        pageTitle: "Preferences",
        showAuth: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.center,
                  direction: Axis.horizontal,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      foregroundImage: NetworkImage(
                        "${globals.supabase.auth.currentUser?.userMetadata?['avatar_url']}",
                      ),
                    ),
                    const SizedBox(
                      width: 36,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Signed in as:",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "${globals.supabase.auth.currentUser?.userMetadata?['name']}",
                              softWrap: true,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              child: const Text("Sign Out"),
              onPressed: () {
                globals.supabase.auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
            const Divider(),
            const ListTile(
              title: Center(
                child: Text(
                  "About",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const ListTile(
              title: Text(
                "Version",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              trailing: Text(
                "1.0.0",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
            ),
            const ListTile(
              title: Text(
                "Made with",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              trailing: Text(
                "Flutter & Dart",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
            ),
            const ListTile(
              title: Text(
                "Made by",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              trailing: Text(
                "Alexandre H.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
            ),
            ListTile(
              title: const Text(
                "Source Code",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              trailing: InkWell(
                child: const Text(
                  "GitHub",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  // open github
                  launchUrl(
                    Uri.parse("https://github.com/Alexandre2006/checkout"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
