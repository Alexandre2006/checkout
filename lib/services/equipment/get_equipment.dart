import 'package:checkout/globals.dart' as globals;
import 'package:checkout/models/equipment.dart';

Future<CheckoutEquipment> getEquipment(int id) async {
  try {
    final response =
        await globals.supabase.from('equipment').select().eq('id', id).single();

    final data = response as Map<String, dynamic>;

    return CheckoutEquipment(
      id: data['id'] as int,
      name: data['name'] as String,
    );
  } catch (error) {
    throw Exception("Error getting equipment: $error");
  }
}

Future<List<CheckoutEquipment>> getAllEquipment() async {
  try {
    final response =
        await globals.supabase.from('equipment').select() as List<dynamic>;

    final data = response.map((e) => e as Map<String, dynamic>).toList();
    return data
        .map(
          (e) =>
              CheckoutEquipment(id: e['id'] as int, name: e['name'] as String),
        )
        .toList();
  } catch (error) {
    throw Exception("$error");
  }
}
