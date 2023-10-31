import 'package:checkout/globals.dart' as globals;

Future<void> registerUser() async {
  // Check if user exists
  try {
    final response = await globals.supabase
        .from('users')
        .select()
        .eq('id', globals.supabase.auth.currentUser!.id);
    if (response != null) {
      globals.supabase.from('users').update({
        'id': globals.supabase.auth.currentUser!.id,
        'profile_picture':
            globals.supabase.auth.currentUser!.userMetadata!['avatar_url'],
      });
    }
  } catch (ignore) {
    // User does not exist
  }

  // Register user
  await globals.supabase.from('users').insert(
    {
      'id': globals.supabase.auth.currentUser!.id,
      'name': globals.supabase.auth.currentUser!.userMetadata?['name'],
      'email': globals.supabase.auth.currentUser!.email,
      'profile_picture':
          globals.supabase.auth.currentUser!.userMetadata!['avatar_url'],
      'admin': false,
    },
  );
}
