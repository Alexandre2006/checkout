import 'package:checkout/models/equipment.dart';
import 'package:flutter/material.dart';

class EquipmentTile extends StatelessWidget {
  final CheckoutEquipment equipment;
  const EquipmentTile({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(equipment.name),
          subtitle: Text("ID: ${equipment.id}"),
        ),
      ],
    );
  }
}
