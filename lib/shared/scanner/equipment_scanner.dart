import 'package:checkout/models/equipment.dart';
import 'package:checkout/services/equipment/get_equipment.dart';
import 'package:checkout/services/qr/parse_qr.dart';
import 'package:checkout/shared/scanner/overlay.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
      builder: (context) => MobileScanner(
        controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.unrestricted),
        overlay: const ScannerOverlay(),
        onDetect: (value) {
          if (!canScan) {
            return;
          }
          canScan = false;
          try {
            final int id =
                parseQRCode(value.barcodes.first.rawValue.toString());

            getEquipment(id).then((value) {
              if (alreadyScanned.where((element) => element.id == id).isEmpty) {
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
    ),
  );
  return scannedEquipment;
}
