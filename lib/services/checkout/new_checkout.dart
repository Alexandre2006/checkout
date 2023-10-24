import 'package:checkout/globals.dart' as globals;
import 'package:checkout/models/equipment.dart';

Future<void> createCheckout(
    List<CheckoutEquipment> equipment, DateTime endDate) async {
  // loop 1000 times
  try {
    await globals.supabase.from('checkouts').insert({
      'start': DateTime.now().toIso8601String(),
      'end': endDate.toIso8601String(),
      'equipment': equipment.map((e) => e.id).toList(),
      'user': globals.supabase.auth.currentUser?.id,
    });
  } catch (e) {
    throw Exception("Failed to create checkout: $e");
  }
}
