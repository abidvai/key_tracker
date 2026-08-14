import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedKeyNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void setKey(int? keyId) {
    state = keyId;
  }
}

final selectedKeyProvider = NotifierProvider<SelectedKeyNotifier, int?>(SelectedKeyNotifier.new);

class ExpectedReturnTimeNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;

  void setTime(DateTime? time) {
    state = time;
  }
}

final expectedReturnTimeProvider = NotifierProvider<ExpectedReturnTimeNotifier, DateTime?>(ExpectedReturnTimeNotifier.new);
