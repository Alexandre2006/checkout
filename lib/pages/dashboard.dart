import 'package:checkout/models/checkout.dart';
import 'package:checkout/models/report.dart';
import 'package:checkout/services/checkout/get_checkout.dart';
import 'package:checkout/services/reports/get_report.dart';
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
      body: index == 0 ? const CheckoutsView() : const ReportsView(),
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

class CheckoutsView extends StatefulWidget {
  const CheckoutsView({super.key});

  @override
  State<CheckoutsView> createState() => _CheckoutsViewState();
}

class _CheckoutsViewState extends State<CheckoutsView> {
  List<CheckoutCheckout> checkouts = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();

    _refreshCheckouts();
  }

  Future<void> _refreshCheckouts() async {
    setState(() {
      loading = true;
    });

    getUserCheckouts()
        .then(
      (value) => setState(
        () {
          checkouts = value;
          loading = false;
        },
      ),
    )
        .onError(
      (error, stackTrace) {
        if (mounted) {
          setState(
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error getting checkouts: $error"),
                  action: SnackBarAction(
                    label: "Dismiss",
                    onPressed: () =>
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  ),
                ),
              );
              loading = false;
            },
          );
        }
      },
    );
  }

  List<CheckoutCheckout> _sortCheckouts(List<CheckoutCheckout> checkouts) {
    // Divide into categories
    final List<CheckoutCheckout> late = checkouts
        .where(
          (element) =>
              element.end.isBefore(DateTime.now()) && !element.returned,
        )
        .toList();

    final List<CheckoutCheckout> ongoing = checkouts
        .where(
          (element) => element.end.isAfter(DateTime.now()) && !element.returned,
        )
        .toList();

    final List<CheckoutCheckout> returned =
        checkouts.where((element) => element.returned).toList();

    // Sort each by date
    late.sort((a, b) => a.end.compareTo(b.end));
    ongoing.sort((a, b) => a.end.compareTo(b.end));
    returned.sort((a, b) => a.end.compareTo(b.end));

    // Combine and return
    return late + ongoing + returned;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, "/newcheckout")
              .then((value) => _refreshCheckouts());
        },
        label: const Row(children: [Icon(Icons.add), Text("Checkout")]),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => _refreshCheckouts(),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CheckoutList(
                checkouts: _sortCheckouts(checkouts),
                onEdit: _refreshCheckouts,
              ),
      ),
    );
  }
}

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  List<CheckoutReport> reports = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();

    _refreshReports();
  }

  Future<void> _refreshReports() async {
    setState(() {
      loading = true;
    });

    getUserReports()
        .then(
      (value) => setState(
        () {
          reports = value;
          loading = false;
        },
      ),
    )
        .onError(
      (error, stackTrace) {
        if (mounted) {
          setState(
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error getting reports: $error"),
                  action: SnackBarAction(
                    label: "Dismiss",
                    onPressed: () =>
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  ),
                ),
              );
              loading = false;
            },
          );
        }
      },
    );
  }

  List<CheckoutReport> _sortReports(List<CheckoutReport> checkouts) {
    // Sort by date
    return checkouts..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, "/newreport")
              .then((value) => _refreshReports());
        },
        label: const Row(children: [Icon(Icons.add), Text("Report")]),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => _refreshReports(),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ReportList(
                reports: _sortReports(reports),
                onEdit: _refreshReports,
              ),
      ),
    );
  }
}
