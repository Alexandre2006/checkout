import 'package:checkout/core/models/rental.dart';
import 'package:checkout/core/services/rentals.dart';
import 'package:flutter/material.dart';

class RentalPage extends StatefulWidget {
  final CheckoutRental rental;
  const RentalPage({super.key, required this.rental});

  @override
  State<RentalPage> createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  @override
  Widget build(BuildContext context) {
    final CheckoutRental rental = widget.rental;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${rental.start.day}/${rental.start.month}/${rental.start.year} - ${rental.end.day}/${rental.end.month}/${rental.end.year}",
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Image.network(rental.renter.profilePicture),
            ),
            title: Text("Borrower: ${rental.renter.name}"),
            subtitle: Text(rental.renter.email),
          ),
          const Divider(),
          ListTile(
            title: const Text("Start Date:"),
            subtitle: Text(
              "${rental.start.day}/${rental.start.month}/${rental.start.year}",
            ),
          ),
          ListTile(
            title: const Text("End Date:"),
            subtitle: Text(
                "${rental.end.day}/${rental.end.month}/${rental.end.year}",),
            trailing: !rental.returned
                ? IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      rental.end = await showDatePicker(
                            context: context,
                            initialDate: rental.end,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 7)),
                          ) ??
                          rental.end;
                      setState(() {
                        updateRental(rental);
                      });
                    },
                  )
                : null,
          ),
          const Divider(),
          ListTile(
            title: const Text(
              "Equipment:",
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Column(
              children: rental.equipment
                  .map(
                    (e) => ListTile(
                      title: Text(e.name),
                      subtitle: Text("#${e.id}"),
                    ),
                  )
                  .toList(),
            ),
          ),
          const Divider(),
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: ElevatedButton(
              onPressed: rental.returned
                  ? null
                  : () {
                      rental.returned = true;
                      setState(() {
                        updateRental(rental);
                      });
                    },
              child: Text(
                  rental.returned ? "Already Returned" : "Mark as Returned",),
            ),
          ),
        ],
      ),
    );
  }
}
