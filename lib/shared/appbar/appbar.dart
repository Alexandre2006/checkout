import 'package:checkout/shared/appbar/appbar_auth.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final bool showAuth;
  const DefaultAppBar(
      {super.key, required this.pageTitle, this.showAuth = true,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: FittedBox(fit: BoxFit.scaleDown, child: Text(pageTitle)),
      actions: [if (showAuth) const AppBarAuth()],
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
