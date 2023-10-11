import 'package:checkout/core/services/authcheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:checkout/utils/globals.dart' as globals;
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (globals.supabase.auth.currentUser != null) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        int authState = await getAuthState();
        if (authState == -1) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/autherror', (Route<dynamic> route) => false);
        } else if (authState > 0) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/', (Route<dynamic> route) => false);
        }
      });
    }
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
                  Text("Sign in to continue",
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.w500,
                      )),
                  const SignInWithGoogleButton(),
                  Text("You must sign in with your @menloschool.org email",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14))
                ],
              ),
            )),
      ),
    );
  }
}

class SignInWithGoogleButton extends StatelessWidget {
  const SignInWithGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        globals.supabase.auth.signInWithOAuth(Provider.google);
      },
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: SvgPicture.asset(
                'assets/icons/google.svg',
                height: 28,
              ),
            )),
      ),
      label: const Text(
        'Sign in with Google',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(255),
          ),
        ),
      ),
    );
  }
}
