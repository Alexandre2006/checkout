import 'package:checkout/globals.dart' as globals;
import 'package:checkout/models/checkout.dart';
import 'package:checkout/services/equipment/get_equipment.dart';
import 'package:checkout/services/user/get_user.dart';

Future<CheckoutCheckout> getCheckout(String uuid) async {
  try {
    final response = await globals.supabase
        .from('checkouts')
        .select()
        .eq('id', uuid)
        .single();
    final data = response as Map<String, dynamic>;

    return CheckoutCheckout(
      uuid: data['id'] as String,
      start: DateTime.parse(data['start'] as String),
      end: DateTime.parse(data['end'] as String),
      equipment: await Future.wait(
        (data['equipment'] as List<dynamic>).map((e) => getEquipment(e as int)),
      ),
      user: await getUser(data['user'] as String),
      returned: data['returned'] as bool,
    );
  } catch (error) {
    throw Exception("Error getting checkout: $error");
  }
}

Future<List<CheckoutCheckout>> getUserCheckouts(
    {String? uuid, int pagesize = 10, int page = 0,}) async {
  uuid ??= globals.supabase.auth.currentUser?.id;

  if (uuid == null) {
    throw Exception("User couldn't be found.");
  }

  try {
    final response = await globals.supabase.rpc(
      'get_user_checkouts',
      params: {
        'user_id': uuid,
        'pagesize': pagesize,
        'page': page,
      },
    ) as List<dynamic>;

    final data = response.map((e) => e as Map<String, dynamic>).toList();
    final List<CheckoutCheckout> checkouts = [];

    for (final checkout in data) {
      checkouts.add(
        CheckoutCheckout(
          uuid: checkout['id'] as String,
          start: DateTime.parse(checkout['start'] as String),
          end: DateTime.parse(checkout['end'] as String),
          equipment: await Future.wait(
            (checkout['equipment'] as List<dynamic>)
                .map((e) => getEquipment(e as int)),
          ),
          user: await getUser(checkout['user'] as String),
          returned: checkout['returned'] as bool,
        ),
      );
    }

    return checkouts;
  } catch (error) {
    throw Exception("Error getting user checkouts: $error");
  }
}
