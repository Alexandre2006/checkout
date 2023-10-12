import 'package:checkout/core/models/rental.dart';
import 'package:checkout/core/models/user.dart';
import 'package:checkout/core/services/authcheck.dart';
import 'package:checkout/core/services/rentals.dart';
import 'package:checkout/core/services/users.dart';
import 'package:checkout/ui/shared/widgets/checkout.dart';
import 'package:checkout/ui/shared/widgets/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      int authState = await getAuthState();
      if (authState == -1) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/autherror', (Route<dynamic> route) => false);
      } else if (authState == 0) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/signin', (Route<dynamic> route) => false);
      }
    });
    return Scaffold(
      body: Center(
        child: currentScreen == 0
            ? const EquipmentScreen()
            : const ReportsScreen(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined),
              label: "Equipment",
              tooltip: "Equipment"),
          BottomNavigationBarItem(
              icon: Icon(Icons.checklist),
              label: "Reports",
              tooltip: "Reports"),
        ],
        currentIndex: currentScreen,
        onTap: (value) => setState(() => currentScreen = value),
      ),
    );
  }
}

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  List<CheckoutRental> rentals = [];
  bool loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        loading = true;
      });
      getUserRentals().then((value) {
        setState(() {
          rentals = value;
          loading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yearbook Checkout"),
        actions: [UserButton()],
      ),
      body: RefreshIndicator(
        child: ListView(
          children: rentals
              .map((e) => CheckoutListTile(
                    rental: e,
                    rebuildCallback: () {
                      setState(() {
                        loading = true;
                      });
                      getUserRentals().then((value) {
                        setState(() {
                          rentals = value;
                          loading = false;
                        });
                      });
                    },
                  ))
              .toList(),
        ),
        onRefresh: () async {
          setState(() {
            loading = true;
          });
          rentals = await getUserRentals();
          setState(() {
            loading = false;
          });
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/checkout').then((value) {
            setState(() {
              loading = true;
            });
            getUserRentals().then((value) {
              setState(() {
                rentals = value;
                loading = false;
              });
            });
          });
        },
        label: const Text("Checkout"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("You have no reports");
  }
}
