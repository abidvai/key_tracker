import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_tracker/core/database_helper.dart';

final databaseProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

final keysProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final dbHelper = ref.watch(databaseProvider);
  final keys = await dbHelper.getAllKeys();
  
  if (keys.isEmpty) {
    // Initialize if empty
    await dbHelper.insertInitialKeys();
    return await dbHelper.getAllKeys();
  }
  return keys;
});

final historyProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final dbHelper = ref.watch(databaseProvider);
  return await dbHelper.getHandoverHistory();
});

class KeyActionNotifier extends StateNotifier<bool> {
  KeyActionNotifier(this.ref) : super(false);
  final Ref ref;

  Future<void> takeKey(int keyId, String personName, String expectedReturnTime) async {
    final dbHelper = ref.read(databaseProvider);
    await dbHelper.takeKey(keyId, personName, expectedReturnTime);
    _invalidateData();
  }

  Future<void> returnKey(int keyId) async {
    final dbHelper = ref.read(databaseProvider);
    await dbHelper.returnKey(keyId);
    _invalidateData();
  }

  void _invalidateData() {
    ref.invalidate(keysProvider);
    ref.invalidate(historyProvider);
  }
}

final keyActionProvider = StateNotifierProvider<KeyActionNotifier, bool>((ref) {
  return KeyActionNotifier(ref);
});
