import 'package:checkout/utils/globals.dart' as globals;
import 'package:flutter/material.dart';

class UserButton extends StatefulWidget {
  const UserButton({super.key});

  @override
  State<UserButton> createState() => _UserButtonState();
}

class _UserButtonState extends State<UserButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      focusColor: Colors.transparent,
      underline: Container(),
      value: 0,
      items: [
        DropdownMenuItem(
          value: 0,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(children: [
              if (globals
                      .supabase.auth.currentUser?.userMetadata?['avatar_url'] !=
                  null)
                Container(
                  height: 32,
                  width: 32,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.network(globals.supabase.auth.currentUser
                      ?.userMetadata?['avatar_url'] as String),
                )
              else
                Container(),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
              Text(
                globals.supabase.auth.currentUser?.userMetadata?['full_name']
                        as String? ??
                    "Signed Out",
              ),
            ]),
          ),
        ),
        const DropdownMenuItem(
          child: Text("Sign Out"),
          value: 1,
        )
      ],
      onChanged: (newval) {
        if (newval == 1) {
          globals.supabase.auth.signOut();
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/signin', (Route<dynamic> route) => false);
        }
      },
    );
  }
}
