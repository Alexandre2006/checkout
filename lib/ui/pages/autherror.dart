import 'package:checkout/core/services/authcheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:checkout/utils/globals.dart' as globals;

class AuthErrorPage extends StatelessWidget {
  const AuthErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      int authState = await getAuthState();
      if (authState == 0) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/signin', (Route<dynamic> route) => false);
      } else if (authState > 0) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/', (Route<dynamic> route) => false);
      }
    });
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
            constraints: const BoxConstraints(
                maxHeight: 250, maxWidth: 500, minHeight: 200, minWidth: 400),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey[900]?.withAlpha(200),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Error Signing In",
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.w500,
                      )),
                  const SignOutButton(),
                  Text("You must sign in with your @menloschool.org email",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14))
                ],
              ),
            )),
      ),
    );
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        globals.supabase.auth.signOut();
        Navigator.pushNamedAndRemoveUntil(
            context, '/signin', (Route<dynamic> route) => false);
      },
      icon: const Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child:
              Padding(padding: EdgeInsets.all(2.0), child: Icon(Icons.logout))),
      label: const Text(
        'Sign Out',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.grey[800]),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(255),
          ),
        ),
      ),
    );
  }
}
