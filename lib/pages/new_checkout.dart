import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:checkout/models/equipment.dart';
import 'package:checkout/services/checkout/new_checkout.dart';
import 'package:checkout/services/equipment/get_equipment.dart';
import 'package:checkout/services/routing/auth_redirect.dart';
import 'package:checkout/shared/appbar/appbar.dart';
import 'package:flutter/material.dart';

class NewCheckoutPage extends StatefulWidget {
  const NewCheckoutPage({super.key});

  @override
  State<NewCheckoutPage> createState() => _NewCheckoutPageState();
}

class _NewCheckoutPageState extends State<NewCheckoutPage> {
  bool loading = false;
  bool canScan = false;
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  List<CheckoutEquipment> equipment = [];

  @override
  void initState() {
    super.initState();

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
      appBar: const DefaultAppBar(pageTitle: "New Checkout"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (equipment.isNotEmpty) {
            createCheckout(equipment, endDate)
                .then((value) => Navigator.pop(context),
                    onError: (error, stackTrace) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    error.toString(),
                  ),
                ),
              );
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "No equipment added",
                ),
              ),
            );
          }
        },
        label:
            const Row(children: [Text("Confirm Checkout"), Icon(Icons.check)]),
      ),
      body: ListView(
        children: [
          const ListTile(title: Text("Checkout Period:")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("-"),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    showDatePicker(
                      context: context,
                      initialDate: endDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(
                        const Duration(days: 7),
                      ),
                    ).then(
                      (value) {
                        setState(() {
                          endDate = value ?? endDate;
                        });
                      },
                    );
                  });
                },
                child: Text(
                  "${endDate.day}/${endDate.month}/${endDate.year}",
                ),
              ),
            ],
          ),
          const Divider(),
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

                            final int id = int.parse(value);

                            getEquipment(id).then((value) {
                              if (equipment
                                  .where((element) => element.id == id)
                                  .isEmpty) {
                                setState(() {
                                  equipment.add(value);
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
          if (equipment.isEmpty)
            const ListTile(
              title: Center(child: Text("No equipment added")),
            ),
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
