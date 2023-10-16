import 'package:checkout/globals.dart' as globals;
import 'package:checkout/models/user.dart';
import 'package:checkout/services/user/register_user.dart';

Future<CheckoutUser> getUser(String uuid) async {
  final response =
      await globals.supabase.from('users').select().eq('id', uuid).single();

  try {
    // Parse response
    final data = response as Map<String, dynamic>;

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
    return getUser(globals.supabase.auth.currentUser!.id);
  } catch (error) {
    registerUser();
  }

  try {
    return getUser(globals.supabase.auth.currentUser!.id);
  } catch (error) {
    throw Exception("Error getting current user: $error");
  }
}
