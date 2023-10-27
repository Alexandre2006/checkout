import 'dart:async';

import 'package:checkout/models/checkout.dart';
import 'package:checkout/pages/dashboard/new_checkout.dart';
import 'package:checkout/services/checkout/get_checkout.dart';
import 'package:checkout/services/routing/auth_redirect.dart';
import 'package:checkout/shared/checkouts/checkout_tile.dart';
import 'package:checkout/shared/checkouts/checkout_view.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CheckoutList extends StatefulWidget {
  const CheckoutList({super.key});

  @override
  State<CheckoutList> createState() => _CheckoutListState();
}

class _CheckoutListState extends State<CheckoutList> {
  static const _pageSize = 10;
  bool loading = false;
  bool adminMode = false;
  bool isAdmin = false;

  final PagingController<int, CheckoutCheckout> _pagingController =
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
      final newItems =
          // ignore: avoid_redundant_argument_values
          adminMode
              ? await getAllCheckouts(pagesize: _pageSize, page: pageKey)
              : await getUserCheckouts(pagesize: _pageSize, page: pageKey);

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

  Future<void> _refreshCheckouts() async {
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
    _refreshCheckouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: isAdmin
          ? [
              Center(
                child: TextButton(
                  onPressed: () => _toggleAdminMode(),
                  child: Text(adminMode
                      ? "Switch to User Mode"
                      : "Switch to Admin Mode"),
                ),
              ),
            ]
          : null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewCheckoutPage()),
          ).then((value) => _refreshCheckouts());
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
            : PagedListView<int, CheckoutCheckout>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<CheckoutCheckout>(
                  noItemsFoundIndicatorBuilder: (context) => const Center(
                    child: Text("No checkouts found."),
                  ),
                  firstPageErrorIndicatorBuilder: (context) => const Center(
                    child: Text("Error loading checkouts."),
                  ),
                  newPageErrorIndicatorBuilder: (context) => const Center(
                    child: Text("Error loading checkouts."),
                  ),
                  itemBuilder: (context, checkout, index) => InkWell(
                    onTap: () => showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => CheckoutView(checkout: checkout),
                    ).then((value) => _refreshCheckouts()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 2,
                      ),
                      child: CheckoutTile(checkout: checkout),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
