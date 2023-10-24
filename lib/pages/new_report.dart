import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:checkout/models/equipment.dart';
import 'package:checkout/models/report.dart';
import 'package:checkout/services/equipment/get_equipment.dart';
import 'package:checkout/services/qr/parse_qr.dart';
import 'package:checkout/services/reports/new_report.dart';
import 'package:checkout/services/routing/auth_redirect.dart';
import 'package:checkout/shared/appbar/appbar.dart';
import 'package:flutter/material.dart';

class NewReportPage extends StatefulWidget {
  final List<CheckoutEquipment> equipment;
  const NewReportPage({super.key, this.equipment = const []});

  @override
  State<NewReportPage> createState() => _NewCheckoutPageState();
}

class _NewCheckoutPageState extends State<NewReportPage> {
  bool loading = false;
  bool canScan = false;
  // Report Details
  List<CheckoutEquipment> equipment = [];
  String title = "";
  String description = "";
  ReportType type = ReportType.damage;

  @override
  void initState() {
    super.initState();

    equipment.addAll(widget.equipment);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getAuthRedirect(true, false).then((value) {
        if (value != null) {
          Navigator.of(context).pushReplacementNamed(value);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(pageTitle: "New Report"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (equipment.isEmpty && type == ReportType.damage) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "No equipment added",
                ),
              ),
            );
          } else if (title == "") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "No title added",
                ),
              ),
            );
          } else if (description == "") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "No description added",
                ),
              ),
            );
          } else {
            createReport(
              title,
              description,
              equipment,
              type,
            ).then((value) => Navigator.pop(context),
                onError: (error, stackTrace) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    error.toString(),
                  ),
                ),
              );
            });
          }
        },
        label: const Row(children: [Text("Submit Report"), Icon(Icons.check)]),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              maxLength: 64,
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "Report Title",
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text("Report Type: "),
                  DropdownButton(
                    items: const [
                      DropdownMenuItem(
                        value: ReportType.damage,
                        child: Text("Equipment Damaged / Lost"),
                      ),
                      DropdownMenuItem(
                        value: ReportType.bug,
                        child: Text("Bug / Issue"),
                      ),
                      DropdownMenuItem(
                        value: ReportType.feature,
                        child: Text("Feature Request"),
                      )
                    ],
                    value: type,
                    onChanged: (newValue) {
                      setState(() {
                        type = newValue ?? type;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Padding(
            // Added bottom padding so the text field doesn't get covered by the action button
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              minLines: 4,
              maxLines: 16,
              maxLength: 512,
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
              decoration: const InputDecoration(
                hintText: "Description",
              ),
            ),
          ),
          if (type == ReportType.damage) const Divider(),
          if (type == ReportType.damage)
            ListTile(
                title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Equipment:"),
                OutlinedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Add Equipment"),
                  onPressed: () {
                    canScan = true;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AiBarcodeScanner(
                          canPop: false,
                          appBar: AppBar(
                            title: const Text("Scan Equipment"),
                          ),
                          onScan: (value) {
                            if (!canScan) {
                              return;
                            }
                            canScan = false;
                            Navigator.of(context).pop();
                            try {
                              setState(() {
                                loading = true;
                              });

                              final int id = parseQRCode(value);

                              getEquipment(id).then((value) {
                                if (equipment
                                    .where((element) => element.id == id)
                                    .isEmpty) {
                                  setState(() {
                                    print("A");
                                    equipment.add(value);
                                    print("B");
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Equipment already added",
                                      ),
                                    ),
                                  );
                                }
                              }).onError((error, stackTrace) {
                                setState(() {
                                  loading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      error.toString(),
                                    ),
                                  ),
                                );
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Failed to add equipment: $e",
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                )
              ],
            )),
          if (equipment.isEmpty && type == ReportType.damage)
            const ListTile(
              title: Center(child: Text("No equipment added")),
            ),
          if (type == ReportType.damage)
            for (final item in equipment)
              ListTile(
                title: Text(item.name),
                subtitle: Text("ID: ${item.id}"),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      equipment.remove(item);
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
        ],
      ),
    );
  }
}
