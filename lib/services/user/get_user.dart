import 'package:checkout/globals.dart' as globals;
import 'package:checkout/models/user.dart';
import 'package:checkout/services/supabase/single_fix.dart';
import 'package:checkout/services/user/register_user.dart';

Future<CheckoutUser> getUser(String uuid) async {
  final response = await globals.supabase
      .from('users')
      .select()
      .eq('id', uuid)
      .limit(1)
      .maybeSingle();

  try {
    // Parse response
    final data = fixSingle(response);

    return CheckoutUser(
      uuid: data['id'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      profilePicture: data['profile_picture'] as String,
      admin: data['admin'] as bool,
    );
  } catch (error) {
    throw Exception("Error getting user: $error");
  }
}

Future<CheckoutUser> getCurrentUser() async {
  try {
    final CheckoutUser user =
        await getUser(globals.supabase.auth.currentUser!.id);
    await updateUser();
    return user;
  } catch (error) {
    await registerUser();
  }

  try {
    return await getUser(globals.supabase.auth.currentUser!.id);
  } catch (error) {
    throw Exception("Error getting current user: $error");
  }
}
