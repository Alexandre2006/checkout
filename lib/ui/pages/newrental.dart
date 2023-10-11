import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:checkout/core/models/equipment.dart';
import 'package:checkout/core/services/authcheck.dart';
import 'package:checkout/core/services/equipment.dart';
import 'package:checkout/core/services/rentals.dart';
import 'package:checkout/core/services/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:checkout/utils/globals.dart' as globals;

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int currentScreen = 0;
  bool loading = false;
  bool scanning = false;
  DateTime endDate = DateTime.now().add(Duration(days: 1));
  List<CheckoutEquipment> equipment = [];

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      int authState = await getAuthState();
      if (authState == -1) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/autherror', (Route<dynamic> route) => false);
      } else if (authState == 0) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/signin', (Route<dynamic> route) => false);
      }
    });
    return Scaffold(
        appBar: AppBar(title: const Text("Checkout")),
        body: Form(
          child: ListView(
            children: [
              const ListTile(
                title: Text("Checkout Date"),
              ),
              ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} - "),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8)),
                      child: InkWell(
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: endDate,
                                  firstDate: DateTime.now(),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 7)))
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                endDate = value;
                              });
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "${endDate.day}/${endDate.month}/${endDate.year}"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                  title: const Text("Equipment"),
                  subtitle:
                      const Text("Add the equipment you want to checkout"),
                  trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        scanning = true;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AiBarcodeScanner(
                                canPop: scanning,
                                appBar:
                                    AppBar(title: const Text("Scan Equipment")),
                                onScan: (value) {
                                  try {
                                    scanning = false;
                                    int id = int.parse(value);
                                    setState(() {
                                      loading = true;
                                    });
                                    getEquipment(id).then((value) {
                                      setState(() {
                                        if (value.id == 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Equipment not found")));
                                          loading = false;
                                        } else {
                                          if (equipment.contains(value)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Equipment already added")));
                                          } else {
                                            equipment.add(value);
                                          }
                                          loading = false;
                                        }
                                      });
                                    });
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Invalid code scanned")));
                                    return;
                                  }
                                }),
                          ),
                        );
                      })),
              // all equipment
              ...equipment.map((e) => ListTile(
                    title: Text(e.name),
                    subtitle: Text("#${e.id}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          equipment.remove(e);
                        });
                      },
                    ),
                  )),
              Divider(),
              ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: ElevatedButton(
                  child: const Text("Checkout"),
                  onPressed: () async {
                    if (equipment.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please add some equipment")));
                      return;
                    }
                    setState(() {
                      loading = true;
                    });
                    await startRental(DateTime.now(), endDate, equipment,
                        await getUser(globals.supabase.auth.currentUser!.id));

                    setState(() {
                      loading = false;
                    });
                  },
                ),
              )
            ],
          ),
        ));
  }
}
