import 'package:checkout/core/models/rental.dart';
import 'package:checkout/ui/shared/pages/rental.dart';
import 'package:flutter/material.dart';

class CheckoutListTile extends StatelessWidget {
  final CheckoutRental rental;
  final Function rebuildCallback;
  const CheckoutListTile(
      {super.key, required this.rental, required this.rebuildCallback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return RentalPage(rental: rental);
        })).then((value) => rebuildCallback());
      },
      leading: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Image.network(rental.renter.profilePicture),
      ),
      title: Text(rental.renter.name),
      subtitle: Text(
          "Equipment: ${rental.equipment.map((e) => e.id)}\n${rental.start.day}/${rental.start.month}/${rental.start.year} - ${rental.end.day}/${rental.end.month}/${rental.end.year}"),
      trailing: Container(
        color: rental.returned
            ? Colors.grey
            : rental.end.isBefore(DateTime.now())
                ? Colors.red
                : Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            rental.returned
                ? "Returned"
                : rental.end.isBefore(DateTime.now())
                    ? "Late"
                    : "Ongoing",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
