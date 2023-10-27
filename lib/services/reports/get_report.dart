import 'package:checkout/globals.dart' as globals;
import 'package:checkout/models/report.dart';
import 'package:checkout/services/equipment/get_equipment.dart';
import 'package:checkout/services/user/get_user.dart';

Future<CheckoutReport> getReport(String uuid) async {
  try {
    final response =
        await globals.supabase.from('reports').select().eq('id', uuid).single();
    final data = response as Map<String, dynamic>;

    return CheckoutReport(
      uuid: data['id'] as String,
      createdAt: DateTime.parse(data['created_at'] as String),
      title: data['title'] as String,
      description: data['description'] as String,
      reporter: await getUser(data['reporter'] as String),
      equipment: await Future.wait(
        (data['equipment'] as List<dynamic>).map((e) => getEquipment(e as int)),
      ),
      type: ReportType.values
          .firstWhere((element) => element.name == data['type'] as String),
    );
  } catch (error) {
    throw Exception("Error getting report: $error");
  }
}

Future<List<CheckoutReport>> getUserReports({
  String? uuid,
  int pagesize = 10,
  int page = 0,
}) async {
  uuid ??= globals.supabase.auth.currentUser?.id;

  if (uuid == null) {
    throw Exception("User couldn't be found.");
  }

  try {
    final response = await globals.supabase
        .from('reports')
        .select()
        .eq('reporter', uuid)
        .range(page * pagesize, (page + 1) * pagesize) as List<dynamic>;

    final data = response.map((e) => e as Map<String, dynamic>).toList();
    final List<CheckoutReport> reports = [];

    for (final report in data) {
      reports.add(
        CheckoutReport(
          uuid: uuid,
          createdAt: DateTime.parse(report['created_at'] as String),
          title: report['title'] as String,
          description: report['description'] as String,
          reporter: await getUser(report['reporter'] as String),
          equipment: await Future.wait(
            (report['equipment'] as List<dynamic>)
                .map((e) => getEquipment(e as int)),
          ),
          type: ReportType.values.firstWhere(
            (element) => element.name == report['type'] as String,
          ),
        ),
      );
    }

    return reports;
  } catch (error) {
    throw Exception("$error");
  }
}

Future<List<CheckoutReport>> getAllReports({
  int pagesize = 10,
  int page = 0,
}) async {
  try {
    final response = await globals.supabase
        .from('reports')
        .select()
        .range(page * pagesize, (page + 1) * pagesize) as List<dynamic>;

    final data = response.map((e) => e as Map<String, dynamic>).toList();
    final List<CheckoutReport> reports = [];

    for (final report in data) {
      reports.add(
        CheckoutReport(
          uuid: report['reporter'] as String,
          createdAt: DateTime.parse(report['created_at'] as String),
          title: report['title'] as String,
          description: report['description'] as String,
          reporter: await getUser(report['reporter'] as String),
          equipment: await Future.wait(
            (report['equipment'] as List<dynamic>)
                .map((e) => getEquipment(e as int)),
          ),
          type: ReportType.values.firstWhere(
            (element) => element.name == report['type'] as String,
          ),
        ),
      );
    }

    return reports;
  } catch (error) {
    throw Exception("$error");
  }
}
