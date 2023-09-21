import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    super.key,
    required this.appBar,
    this.title = "",
    this.backButtonVisible = true,
    this.onPressed,
    this.textColor,
    this.backgroundColor,
    this.textWidget,
    this.actions,
  });

  final AppBar appBar;
  final String title;
  final bool backButtonVisible;
  final Function()? onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final Text? textWidget;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: textWidget ??
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: textColor,
                ),
          ),
      backgroundColor: backgroundColor,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: backButtonVisible
          ? IconButton(
              padding: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              onPressed: onPressed ?? () => context.pop(),
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: textColor,
              ),
              iconSize: 30,
            )
          : null,
      actions: actions,
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
