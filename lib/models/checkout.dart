import 'package:checkout/models/equipment.dart';
import 'package:checkout/models/user.dart';

class CheckoutCheckout {
  final String uuid;
  final DateTime start;
  DateTime end;
  final List<CheckoutEquipment> equipment;
  final CheckoutUser user;
  bool returned;

  CheckoutCheckout({
    required this.uuid,
    required this.start,
    required this.end,
    required this.equipment,
    required this.user,
    required this.returned,
  });
}
