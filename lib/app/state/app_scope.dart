import 'package:flutter/widgets.dart';
import 'package:nw_trails/app/state/app_state.dart';

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    required AppState notifier,
    required super.child,
    super.key,
  }) : super(notifier: notifier);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree.');
    return scope!.notifier!;
  }
}
