import 'package:checkout/models/report.dart';
import 'package:checkout/shared/equipment/equipment_tile.dart';
import 'package:flutter/material.dart';

class ReportView extends StatelessWidget {
  final CheckoutReport report;
  const ReportView({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              backgroundColor: Colors.transparent,
            ),
            SliverList.list(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        foregroundImage:
                            NetworkImage(report.reporter.profilePicture),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report.reporter.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "User ID: ${report.reporter.uuid}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Report ID: ${report.uuid}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text("Type:"),
                  subtitle: report.type == ReportType.damage
                      ? const Text("Equipment Damaged / Lost")
                      : report.type == ReportType.feature
                          ? const Text("Feature Request")
                          : const Text("Bug / Issue"),
                ),
                ListTile(
                  title: const Text("Title:"),
                  subtitle: Text(report.title),
                ),
                ListTile(
                  title: const Text("Description:"),
                  subtitle: Text(report.description),
                ),
                if (report.equipment.isNotEmpty) const Divider(),
                if (report.equipment.isNotEmpty)
                  const ListTile(
                    title: Text("Equipment:"),
                  ),
                if (report.equipment.isNotEmpty)
                  for (final equipment in report.equipment)
                    EquipmentTile(equipment: equipment),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
