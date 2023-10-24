import 'package:checkout/models/report.dart';
import 'package:checkout/shared/reports/report_tile.dart';
import 'package:checkout/shared/reports/report_view.dart';
import 'package:flutter/material.dart';

class ReportList extends StatelessWidget {
  final List<CheckoutReport> reports;
  final Function()? onEdit;
  const ReportList({super.key, required this.reports, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return reports.isEmpty
        ? const Center(
            child: Text("No reports found"),
          )
        : ListView(
            children: ListTile.divideTiles(
              tiles: [
                for (final report in reports)
                  InkWell(
                    onTap: () => showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => ReportView(report: report),
                    ).then((value) => onEdit?.call()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 2,
                      ),
                      child: ReportTile(report: report),
                    ),
                  ),
              ],
              context: context,
            ).toList(),
          );
  }
}
