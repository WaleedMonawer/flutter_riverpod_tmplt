import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../theme/adaptive_theme.dart';

class AdaptiveScaffold extends StatelessWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget body;
  final Widget? floatingActionButton;
  final bool automaticallyImplyLeading;

  const AdaptiveScaffold({
    super.key,
    this.title,
    this.actions,
    this.leading,
    required this.body,
    this.floatingActionButton,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    if (AdaptiveTheme.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: title != null
            ? CupertinoNavigationBar(
                middle: Text(title!),
                trailing: actions != null && actions!.isNotEmpty
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions!,
                      )
                    : null,
                leading: leading,
                automaticallyImplyLeading: automaticallyImplyLeading,
              )
            : null,
        child: Stack(
          children: [
            body,
            if (floatingActionButton != null)
              Positioned(
                right: 16,
                bottom: 16,
                child: floatingActionButton!,
              ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: title != null
            ? AppBar(
                title: Text(title!),
                actions: actions,
                leading: leading,
                automaticallyImplyLeading: automaticallyImplyLeading,
              )
            : null,
        body: body,
        floatingActionButton: floatingActionButton,
      );
    }
  }
} 