import 'package:checkout/globals.dart' as globals;
import 'package:checkout/services/user/get_user.dart';
import 'package:checkout/services/user/register_user.dart';

Future<String?> getAuthRedirect(bool requireAuth, bool requireAdmin) async {
  final bool signedIn = globals.supabase.auth.currentUser != null;
  String email = "";

  if (signedIn) {
    email = globals.supabase.auth.currentUser?.email ?? "";
  }

  if (requireAuth && !signedIn) {
    return "/login";
  } else if (requireAuth && !email.endsWith("@menloschool.org")) {
    return "/invalidemail";
  } else if (requireAdmin) {
    if (!(await getCurrentUser()).admin) {
      return "/notadmin";
    }
  }
  registerUser();
  return null;
}
