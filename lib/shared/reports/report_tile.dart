import 'package:checkout/models/report.dart';
import 'package:flutter/material.dart';

class ReportTile extends StatelessWidget {
  final CheckoutReport report;
  const ReportTile({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Row(
            children: [
              if (MediaQuery.of(context).size.width > 360)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 24,
                    foregroundImage: NetworkImage(
                      report.reporter.profilePicture,
                    ),
                  ),
                ),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.reporter.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      report.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Created on: ${report.createdAt.month}/${report.createdAt.day}/${report.createdAt.year}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SizedBox(
            width: 128,
            child: ElevatedButton(
              onPressed: null,
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                backgroundColor: report.type == ReportType.damage
                    ? const MaterialStatePropertyAll(Colors.grey)
                    : report.type == ReportType.feature
                        ? MaterialStatePropertyAll(Colors.green.withAlpha(128))
                        : MaterialStatePropertyAll(Colors.red.withAlpha(128)),
                padding: const MaterialStatePropertyAll(EdgeInsets.zero),
              ),
              child: report.type == ReportType.damage
                  ? const Text("Damage / Lost")
                  : report.type == ReportType.feature
                      ? const Text("Feature Request")
                      : const Text("Bug / Issue"),
            ),
          ),
        ),
      ],
    );
  }
}
