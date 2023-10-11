import 'package:checkout/core/models/equipment.dart';
import 'package:checkout/utils/globals.dart' as globals;

Future<CheckoutEquipment> getEquipment(int id) async {
  late final response;
  try {
    response =
        await globals.supabase.from('equipment').select().eq('id', id).single();
  } catch (e) {
    return CheckoutEquipment(
      id: 0,
      name: "Deleted Equipment",
    );
  }
  return CheckoutEquipment(
    id: response['id'],
    name: response['name'],
  );
}

Future<List<CheckoutEquipment>> getAllEquipment() async {
  late final response;
  try {
    response = await globals.supabase.from('equipment').select();
  } catch (e) {
    return [];
  }

  final users = (response as List<dynamic>)
      .map((e) => CheckoutEquipment(
            id: e['id'],
            name: e['name'],
          ))
      .toList();

  return users;
}
