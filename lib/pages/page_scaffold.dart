import 'package:flutter/material.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    required this.child,
    this.appBar,
    this.floatingActionButton,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final AppBar? appBar;
  final FloatingActionButton? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: appBar,
          body: child,
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }
}
