import 'package:checkout/models/equipment.dart';
import 'package:checkout/models/user.dart';

class CheckoutReport {
  final String uuid;
  final DateTime createdAt;
  final String title;
  final String description;
  final CheckoutUser reporter;
  final List<CheckoutEquipment> equipment;
  final ReportType type;

  CheckoutReport({
    required this.uuid,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.reporter,
    required this.equipment,
    required this.type,
  });
}

enum ReportType {
  damage,
  bug,
  feature,
}
