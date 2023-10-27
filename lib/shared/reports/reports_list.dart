import 'package:checkout/models/report.dart';
import 'package:checkout/pages/dashboard/new_report.dart';
import 'package:checkout/services/reports/get_report.dart';
import 'package:checkout/services/routing/auth_redirect.dart';
import 'package:checkout/shared/reports/report_tile.dart';
import 'package:checkout/shared/reports/report_view.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ReportList extends StatefulWidget {
  const ReportList({super.key});

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  static const _pageSize = 10;
  bool loading = false;
  bool adminMode = false;
  bool isAdmin = false;

  final PagingController<int, CheckoutReport> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (await getAuthRedirect(true, true) == null) {
        setState(() {
          isAdmin = true;
        });
      }
    });

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // ignore: avoid_redundant_argument_values
      final newItems = adminMode
          ? await getAllReports()
          : await getUserReports(pagesize: _pageSize, page: pageKey);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _refreshReports() async {
    setState(() {
      loading = true;
    });
    _pagingController.refresh();
    setState(() {
      loading = false;
    });
  }

  Future<void> _toggleAdminMode() async {
    adminMode = !adminMode;
    _refreshReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: isAdmin
          ? [
              Center(
                child: TextButton(
                  onPressed: () => _toggleAdminMode(),
                  child: Text(
                    adminMode ? "Switch to User Mode" : "Switch to Admin Mode",
                  ),
                ),
              ),
            ]
          : null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewReportPage()),
          ).then((value) => _refreshReports());
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
            : PagedListView<int, CheckoutReport>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<CheckoutReport>(
                  noItemsFoundIndicatorBuilder: (context) => const Center(
                    child: Text("No reports found."),
                  ),
                  firstPageErrorIndicatorBuilder: (context) => Center(
                    child: Column(
                      children: [
                        const Text("Error loading reports:"),
                        Text(_pagingController.error.toString())
                      ],
                    ),
                  ),
                  newPageErrorIndicatorBuilder: (context) => Center(
                    child: Column(
                      children: [
                        const Text("Error loading reports:"),
                        Text(_pagingController.error.toString())
                      ],
                    ),
                  ),
                  itemBuilder: (context, report, index) => InkWell(
                    onTap: () => showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => ReportView(report: report),
                    ).then((value) => _refreshReports()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 2,
                      ),
                      child: ReportTile(report: report),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
