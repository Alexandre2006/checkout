import 'package:checkout/utils/globals.dart' as globals;
import 'package:supabase_flutter/supabase_flutter.dart';

// 0 = Unauthenticated, 1 = Authenticated, 2 = Authenticated (Admin), -1 = Error
Future<int> getAuthState() async {
  final User? currentUser = globals.supabase.auth.currentUser;

  // If the user is not logged in, return 0
  if (currentUser == null) {
    return 0;
  }

  // Check the users email
  if (currentUser.email == null ||
      !currentUser.email!.endsWith("@menloschool.org")) {
    return -1;
  }

  // Create user table if necessary
  try {
    await globals.supabase.from('users').insert([
      {
        'id': currentUser.id,
        'name': currentUser.userMetadata?['full_name'],
        'email': currentUser.email,
        'profile_picture': currentUser.userMetadata?['avatar_url'],
      }
    ]);
  } catch (e) {
    // Don't do anything
  }

  // Check if the user is an admin
  late final userData;
  try {
    userData = await globals.supabase
        .from('users')
        .select('admin')
        .eq('id', currentUser.id)
        .single();
  } catch (e) {
    return -1;
  }

  return userData['admin'] as bool ? 2 : 1;
}
