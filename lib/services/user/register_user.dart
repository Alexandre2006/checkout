import 'package:checkout/globals.dart' as globals;

Future<void> registerUser() async {
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

Future<void> updateUser() async {
  await globals.supabase.from('users').update(
    {
      'name': globals.supabase.auth.currentUser!.userMetadata?['name'],
      'email': globals.supabase.auth.currentUser!.email,
      'profile_picture':
          globals.supabase.auth.currentUser!.userMetadata!['avatar_url'],
    },
  ).eq('id', globals.supabase.auth.currentUser!.id);
}
