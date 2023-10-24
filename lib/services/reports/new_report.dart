import 'package:checkout/globals.dart' as globals;
import 'package:checkout/models/equipment.dart';
import 'package:checkout/models/report.dart';

Future<void> createReport(
  String title,
  String description,
  List<CheckoutEquipment> equipment,
  ReportType type,
) async {
  try {
    await globals.supabase.from('reports').insert({
      'created_at': DateTime.now().toIso8601String(),
      'title': title,
      'description': description,
      'reporter': globals.supabase.auth.currentUser?.id,
      'equipment': equipment.map((e) => e.id).toList(),
      'type': type.name,
    });
  } catch (e) {
    throw Exception("Failed to create report: $e");
  }
}
