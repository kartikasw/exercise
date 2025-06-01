import 'package:flutter/material.dart';

class ChangeNotifierProvider<T extends ChangeNotifier> extends InheritedWidget {
  const ChangeNotifierProvider({
    super.key,
    required this.notifier,
    required super.child,
  });

  final T notifier;

  static T? maybeOf<T extends ChangeNotifier>(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ChangeNotifierProvider<T>>();
    return provider?.notifier;
  }

  static T of<T extends ChangeNotifier>(BuildContext context) {
    final notifier = maybeOf<T>(context);
    assert(notifier != null, 'No ChangeNotifierProvider<$T> found in context');
    return notifier!;
  }

  @override
  bool updateShouldNotify(ChangeNotifierProvider oldWidget) => notifier != oldWidget.notifier;
}
