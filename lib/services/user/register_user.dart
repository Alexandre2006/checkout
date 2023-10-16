import 'package:checkout/globals.dart' as globals;

Future<void> registerUser() async {
  // Check if user exists
  try {
    final response = await globals.supabase
        .from('users')
        .select()
        .eq('uuid', globals.supabase.auth.currentUser!.id);
    if (response != null) {
      return;
    }
  } catch (error) {
    throw Exception("Error checking if user exists: $error");
  }

  // Register user
  globals.supabase.from('users').insert(
    {
      'uuid': globals.supabase.auth.currentUser!.id,
      'name': globals.supabase.auth.currentUser!.userMetadata?['name'],
      'email': globals.supabase.auth.currentUser!.email,
      'profile_picture':
          globals.supabase.auth.currentUser!.userMetadata!['avatar_url'],
      'admin': false,
    },
  );
}
