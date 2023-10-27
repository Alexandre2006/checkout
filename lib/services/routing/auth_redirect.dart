import 'package:checkout/globals.dart' as globals;
import 'package:checkout/pages/errors/invalid_email_page.dart';
import 'package:checkout/pages/errors/not_admin_page.dart';
import 'package:checkout/pages/login_page.dart';
import 'package:checkout/services/user/get_user.dart';
import 'package:checkout/services/user/register_user.dart';
import 'package:flutter/material.dart';

Future<Widget?> getAuthRedirect(bool requireAuth, bool requireAdmin) async {
  final bool signedIn = globals.supabase.auth.currentUser != null;
  String email = "";

  if (signedIn) {
    email = globals.supabase.auth.currentUser?.email ?? "";
  }

  if (requireAuth && !signedIn) {
    return const LoginPage();
  } else if (requireAuth && !email.endsWith("@menloschool.org")) {
    return const InvalidEmailPage();
  } else if (requireAdmin) {
    if (!(await getCurrentUser()).admin) {
      return const NotAdminPage();
    }
  }
  registerUser();
  return null;
}
