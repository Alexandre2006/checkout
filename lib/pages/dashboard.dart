import 'package:checkout/services/routing/auth_redirect.dart';
import 'package:checkout/shared/appbar/appbar.dart';
import 'package:checkout/shared/checkouts/checkout_list.dart';
import 'package:checkout/shared/reports/reports_list.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int index = 0;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getAuthRedirect(true, false).then((value) {
        if (value != null) {
          Navigator.of(context).pushReplacementNamed(value);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(pageTitle: "Dashboard"),
      body: index == 0 ? const CheckoutList() : const ReportList(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) => setState(() => index = value),
        items: const [
          BottomNavigationBarItem(
            label: "Checkouts",
            icon: Icon(Icons.camera_alt_outlined),
            activeIcon: Icon(Icons.camera_alt),
          ),
          BottomNavigationBarItem(
            label: "Reports",
            icon: Icon(Icons.checklist_outlined),
            activeIcon: Icon(Icons.checklist),
          ),
        ],
      ),
    );
  }
}
