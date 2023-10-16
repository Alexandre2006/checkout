import 'package:checkout/globals.dart' as globals;
import 'package:checkout/models/checkout.dart';

Future<void> updateCheckout(CheckoutCheckout checkout) async {
  try {
    await globals.supabase.from('checkouts').update({
      'id': checkout.uuid,
      'start': checkout.start.toIso8601String(),
      'end': checkout.end.toIso8601String(),
      'equipment': checkout.equipment.map((e) => e.id).toList(),
      'user': checkout.user.uuid,
      'returned': checkout.returned,
    }).eq('id', checkout.uuid);
  } catch (e) {
    throw Exception("Failed to update checkout: $e");
  }
}
