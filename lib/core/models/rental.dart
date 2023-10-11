import 'package:checkout/core/models/equipment.dart';
import 'package:checkout/core/models/user.dart';

class CheckoutRental {
  final String uuid;
  final DateTime start;
  DateTime end;
  final List<CheckoutEquipment> equipment;
  final CheckoutUser renter;
  bool returned;

  CheckoutRental({
    required this.uuid,
    required this.start,
    required this.end,
    required this.equipment,
    required this.renter,
    required this.returned,
  });
}
