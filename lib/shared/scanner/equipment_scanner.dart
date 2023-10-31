import 'dart:developer';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:checkout/models/equipment.dart';
import 'package:checkout/services/equipment/get_equipment.dart';
import 'package:checkout/services/qr/parse_qr.dart';
import 'package:checkout/shared/scanner/overlay.dart';
import 'package:flutter/material.dart';

Future<CheckoutEquipment?> scanEquipment(
  BuildContext context, {
  List<CheckoutEquipment> alreadyScanned = const [],
}) async {
  // Allow scanning
  bool canScan = true;

  // Store scanned equipment
  CheckoutEquipment? scannedEquipment;

  // Push scanner
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => Stack(children: [
        AiBarcodeScanner(
          //blank smallest possible size
          bottomBar: const SizedBox(
            height: 0,
            width: 0,
          ),
          showOverlay: false,
          canPop: false,
          scanWindow: Rect.fromCenter(
            center: Offset.zero,
            width: 256,
            height: 256,
          ),
          onScan: (value) {
            log("HI!");
            if (!canScan) {
              return;
            }
            canScan = false;
            try {
              final int id = parseQRCode(value);
              getEquipment(id).then((value) {
                if (alreadyScanned
                    .where((element) => element.id == id)
                    .isEmpty) {
                  scannedEquipment = value;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Equipment already added",
                      ),
                    ),
                  );
                }
                Navigator.of(context).pop();
              }).onError((error, stackTrace) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      error.toString(),
                    ),
                  ),
                );
                Navigator.of(context).pop();
              });
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Failed to add equipment: $e",
                  ),
                ),
              );
              Navigator.of(context).pop();
            }
          },
        ),
        const ScannerOverlay(),
      ]),
    ),
  );
  return scannedEquipment;
}
