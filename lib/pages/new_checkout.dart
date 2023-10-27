import 'package:checkout/models/equipment.dart';
import 'package:checkout/services/checkout/new_checkout.dart';
import 'package:checkout/services/routing/auth_redirect.dart';
import 'package:checkout/shared/appbar/appbar.dart';
import 'package:checkout/shared/scanner/equipment_scanner.dart';
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
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => value));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        pageTitle: "New Checkout",
        showAuth: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (equipment.isNotEmpty) {
            createCheckout(equipment, endDate).then(
              (value) => Navigator.pop(context),
              onError: (error, stackTrace) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      error.toString(),
                    ),
                  ),
                );
              },
            );
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
                "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}",
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
                  "${endDate.month}/${endDate.day}/${endDate.year}",
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
                    setState(() {
                      scanEquipment(context, alreadyScanned: equipment).then(
                        (value) => setState(() {
                          if (value != null) {
                            equipment.add(value);
                          }
                        }),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
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
