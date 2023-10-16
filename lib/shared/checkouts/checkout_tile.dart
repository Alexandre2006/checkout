import 'package:checkout/models/checkout.dart';
import 'package:flutter/material.dart';

class CheckoutTile extends StatelessWidget {
  final CheckoutCheckout checkout;
  const CheckoutTile({super.key, required this.checkout});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (MediaQuery.of(context).size.width > 360)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 24,
              foregroundImage: NetworkImage(
                checkout.user.profilePicture,
              ),
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(checkout.user.name),
            Text(
              "${checkout.start.day}/${checkout.start.month}/${checkout.start.year} - ${checkout.end.day}/${checkout.end.month}/${checkout.end.year}",
            ),
            Text(
              "Equipment IDs: ${checkout.equipment.map((e) => e.id.toString()).join(", ")}",
            ),
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SizedBox(
            width: 100,
            child: ElevatedButton(
              onPressed: null,
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                backgroundColor: checkout.returned
                    ? const MaterialStatePropertyAll(Colors.grey)
                    : checkout.end.isAfter(DateTime.now())
                        ? MaterialStatePropertyAll(Colors.green.withAlpha(128))
                        : MaterialStatePropertyAll(Colors.red.withAlpha(128)),
                padding: const MaterialStatePropertyAll(EdgeInsets.zero),
              ),
              child: checkout.returned
                  ? const Text("Returned")
                  : checkout.end.isAfter(DateTime.now())
                      ? const Text("Ongoing")
                      : const Text("Late"),
            ),
          ),
        ),
      ],
    );
  }
}
