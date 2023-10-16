import 'package:checkout/models/checkout.dart';
import 'package:checkout/shared/checkouts/checkout_tile.dart';
import 'package:checkout/shared/checkouts/checkout_view.dart';
import 'package:flutter/material.dart';

class CheckoutList extends StatelessWidget {
  final List<CheckoutCheckout> checkouts;
  final Function()? onEdit;
  const CheckoutList({super.key, required this.checkouts, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return checkouts.isEmpty
        ? const Center(
            child: Text("No checkouts found"),
          )
        : ListView(
            children: ListTile.divideTiles(
              tiles: [
                for (final checkout in checkouts)
                  InkWell(
                    onTap: () => showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => CheckoutView(checkout: checkout),
                    ).then((value) => onEdit?.call()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 2,
                      ),
                      child: CheckoutTile(checkout: checkout),
                    ),
                  ),
              ],
              context: context,
            ).toList(),
          );
  }
}
