import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/hive_service.dart';

// Provider to track Hive initialization status
final hiveStatusProvider = StateNotifierProvider<HiveStatusNotifier, HiveStatus>((ref) {
  return HiveStatusNotifier();
});

class HiveStatusNotifier extends StateNotifier<HiveStatus> {
  HiveStatusNotifier() : super(HiveStatus.initializing) {
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    try {
      await HiveService.init();
      await HiveService.openBoxes();
      state = HiveStatus.ready;
    } catch (e) {
      state = HiveStatus.error;
    }
  }

  Future<void> retry() async {
    state = HiveStatus.initializing;
    await _initializeHive();
  }
}

enum HiveStatus {
  initializing,
  ready,
  error,
}