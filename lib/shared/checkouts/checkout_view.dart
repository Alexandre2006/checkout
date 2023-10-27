import 'package:checkout/models/checkout.dart';
import 'package:checkout/pages/dashboard/new_report.dart';
import 'package:checkout/services/checkout/update_checkout.dart';
import 'package:checkout/shared/equipment/equipment_tile.dart';
import 'package:flutter/material.dart';

class CheckoutView extends StatefulWidget {
  final CheckoutCheckout checkout;
  const CheckoutView({super.key, required this.checkout});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  late CheckoutCheckout editableCheckout;

  @override
  void initState() {
    super.initState();

    editableCheckout = widget.checkout;
  }

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
                        foregroundImage: NetworkImage(
                          editableCheckout.user.profilePicture,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              editableCheckout.user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "User ID: ${editableCheckout.user.uuid}",
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
                                "Checkout ID: ${editableCheckout.uuid}",
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
                const ListTile(
                  title: Text("Checkout Period:"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${editableCheckout.start.month}/${editableCheckout.start.day}/${editableCheckout.start.year}",
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("-"),
                    ),
                    OutlinedButton(
                      onPressed: editableCheckout.start
                                  .add(const Duration(days: 7))
                                  .isAfter(DateTime.now()) &&
                              !editableCheckout.returned
                          ? () {
                              setState(() {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now()
                                          .isAfter(editableCheckout.end)
                                      ? DateTime.now()
                                      : editableCheckout.end,
                                  firstDate: DateTime.now(),
                                  lastDate: editableCheckout.start.add(
                                    const Duration(days: 7),
                                  ),
                                ).then(
                                  (value) {
                                    setState(() {
                                      editableCheckout.end =
                                          value ?? editableCheckout.end;
                                      updateCheckout(editableCheckout).onError(
                                        (error, stackTrace) =>
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              error.toString(),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                );
                              });
                            }
                          : null,
                      child: Text(
                        "${editableCheckout.end.month}/${editableCheckout.end.day}/${editableCheckout.end.year}",
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const ListTile(
                  title: Text("Equipment:"),
                ),
                for (final equipment in editableCheckout.equipment)
                  EquipmentTile(equipment: equipment),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: OutlinedButton(
                    onPressed: editableCheckout.returned
                        ? null
                        : () {
                            setState(() {
                              editableCheckout.returned = true;
                              updateCheckout(editableCheckout).onError(
                                (error, stackTrace) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      error.toString(),
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                    child: Text(
                      editableCheckout.returned
                          ? "Already Returned"
                          : " Mark Returned",
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewReportPage(
                            equipment: editableCheckout.equipment,
                          ),
                        ),
                      );
                    },
                    child: const Text("Report an Issue"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
