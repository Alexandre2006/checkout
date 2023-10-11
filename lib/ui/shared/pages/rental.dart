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
    CheckoutRental rental = widget.rental;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${rental.start.day}/${rental.start.month}/${rental.start.year} - ${rental.end.day}/${rental.end.month}/${rental.end.year}"),
      ),
      body: ListView(children: [
        ListTile(
          leading: Container(
            child: Image.network(rental.renter.profilePicture),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(shape: BoxShape.circle),
          ),
          title: Text("Borrower: ${rental.renter.name}"),
          subtitle: Text("${rental.renter.email}"),
        ),
        Divider(),
        ListTile(
          title: Text("Start Date:"),
          subtitle: Text(
              "${rental.start.day}/${rental.start.month}/${rental.start.year}"),
        ),
        ListTile(
          title: Text("End Date:"),
          subtitle:
              Text("${rental.end.day}/${rental.end.month}/${rental.end.year}"),
          trailing: !rental.returned
              ? IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    rental.end = await showDatePicker(
                            context: context,
                            initialDate: rental.end,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 7))) ??
                        rental.end;
                    setState(() {
                      updateRental(rental);
                    });
                  },
                )
              : null,
        ),
        Divider(),
        ListTile(
          title: Text(
            "Equipment:",
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Column(
            children: rental.equipment
                .map((e) => ListTile(
                      title: Text("${e.name}"),
                      subtitle: Text("#${e.id}"),
                    ))
                .toList(),
          ),
        ),
        Divider(),
        ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          title: ElevatedButton(
            child:
                Text(rental.returned ? "Already Returned" : "Mark as Returned"),
            onPressed: rental.returned
                ? null
                : () {
                    rental.returned = true;
                    setState(() {
                      updateRental(rental);
                    });
                  },
          ),
        )
      ]),
    );
  }
}
