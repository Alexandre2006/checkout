import 'package:flutter/material.dart';
import 'package:checkout/utils/globals.dart' as globals;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yearbook Checkout"),
      ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: ListView.builder(
          itemBuilder: (context, index) {
            String full_name =
                globals.supabase.auth.currentUser?.userMetadata?['full_name'];
            return ListTile(
              title: Text(
                  "$full_name is checking out item $index for the yearbook"),
              subtitle: Text("Item $index"),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {},
              ),
            );
          },
          itemCount: 10,
        ),
        onRefresh: () async {},
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Checkout"),
        icon: Icon(Icons.add),
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
