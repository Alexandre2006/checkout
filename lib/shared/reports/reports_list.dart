import 'package:checkout/models/report.dart';
import 'package:checkout/services/reports/get_report.dart';
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

  final PagingController<int, CheckoutReport> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await getUserReports(pagesize: _pageSize, page: pageKey);

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
    loading = true;
    _pagingController.refresh();
    loading = false;
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
            : PagedListView<int, CheckoutReport>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<CheckoutReport>(
                  noItemsFoundIndicatorBuilder: (context) => const Center(
                    child: Text("No reports found."),
                  ),
                  firstPageErrorIndicatorBuilder: (context) => const Center(
                    child: Text("Error loading reports."),
                  ),
                  newPageErrorIndicatorBuilder: (context) => const Center(
                    child: Text("Error loading reports."),
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
