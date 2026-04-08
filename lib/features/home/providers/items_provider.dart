import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:a_scientific_calculator_application_to_perform_mor/features/shared/data/models/item.dart';
import 'package:a_scientific_calculator_application_to_perform_mor/models/item.dart';

part 'items_provider.g.dart';

@riverpod
class Items extends _$Items {
  @override
  Future<List<Item>> build() async {
    // Simulate loading items from storage/API
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  Future<void> addItem(Item item) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentItems = await future;
      return [...currentItems, item];
    });
  }

  Future<void> removeItem(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentItems = await future;
      return currentItems.where((item) => item.id != id).toList();
    });
  }

  Future<void> updateItem(Item updatedItem) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentItems = await future;
      return [
        for (final item in currentItems)
          if (item.id == updatedItem.id) updatedItem else item,
      ];
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Simulate refreshing from storage/API
      await Future.delayed(const Duration(milliseconds: 300));
      return state.value ?? [];
    });
  }
}