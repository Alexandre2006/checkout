import 'package:checkout/core/models/user.dart';
import 'package:checkout/utils/globals.dart' as globals;

Future<CheckoutUser> getUser(String id) async {
  late final response;
  try {
    response =
        await globals.supabase.from('users').select().eq('id', id).single();
  } catch (e) {
    return CheckoutUser(
        uuid: '0',
        name: "Deleted User",
        email: "deleted@user.com",
        profilePicture:
            "https://api-private.atlassian.com/users/4b3537aa0667e335931a7982526af3d9/avatar");
  }

  return CheckoutUser(
      uuid: response['id'] as String,
      name: response['name'] as String,
      email: response['email'] as String,
      profilePicture: response['profile_picture'] as String);
}

Future<List<CheckoutUser>> getAllUsers() async {
  late final response;
  try {
    response = await globals.supabase.from('users').select();
  } catch (e) {
    return [];
  }

  final users = (response as List<dynamic>)
      .map((e) => CheckoutUser(
          uuid: e['id'] as String,
          name: e['name'] as String,
          email: e['email'] as String,
          profilePicture: e['profile_picture'] as String))
      .toList();

  return users;
}
