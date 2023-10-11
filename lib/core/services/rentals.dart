import 'package:checkout/core/models/equipment.dart';
import 'package:checkout/core/models/rental.dart';
import 'package:checkout/core/models/user.dart';
import 'package:checkout/core/services/equipment.dart';
import 'package:checkout/core/services/users.dart';
import 'package:checkout/utils/globals.dart' as globals;

Future<List<CheckoutRental>> getUserRentals() async {
  if (globals.supabase.auth.currentUser == null) return [];
  CheckoutUser user = await getUser(globals.supabase.auth.currentUser!.id);

  late final response;
  try {
    response = await globals.supabase
        .from('rentals')
        .select()
        .eq('renter', user.uuid)
        .order('start', ascending: false);
  } catch (e) {
    return [];
  }

  final rentals = Future.wait((response as List<dynamic>).map((e) async {
    return CheckoutRental(
      uuid: e['id'],
      start: DateTime.parse(e['start']),
      end: DateTime.parse(e['end']),
      equipment: await Future.wait(
          (e['equipment'] as List<dynamic>).map((e) => getEquipment(e))),
      renter: user,
      returned: e['returned'],
    );
  }).toList());

  return rentals;
}

Future<List<CheckoutRental>> getAllRentals() async {
  late final response;
  try {
    response = await globals.supabase
        .from('rentals')
        .select()
        .order('start', ascending: false);
  } catch (e) {
    return [];
  }

  final rentals = Future.wait((response as List<dynamic>)
      .map((e) async => CheckoutRental(
            uuid: e['uuid'],
            start: DateTime.parse(e['start']),
            end: DateTime.parse(e['end']),
            equipment: await Future.wait((e['equipment'] as List<dynamic>)
                .map((e) => getEquipment(e['id']))),
            renter: await getUser(e['renter']),
            returned: e['returned'],
          ))
      .toList());

  return rentals;
}

Future<void> updateRental(CheckoutRental rental) async {
  await globals.supabase.from('rentals').update({
    'end': rental.end.toIso8601String(),
    'returned': rental.returned
  }).eq('id', rental.uuid);
}

Future<void> startRental(
  DateTime start,
  DateTime end,
  List<CheckoutEquipment> equipment,
  CheckoutUser renter,
) async {
  await globals.supabase.from('rentals').insert({
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
    'equipment': equipment.map((e) => e.id).toList(),
    'renter': renter.uuid
  });
}
