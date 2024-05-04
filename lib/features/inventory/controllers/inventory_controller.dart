// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'package:inventory_flutter/features/inventory/repositories/inventory_repo.dart';
import 'package:inventory_flutter/models/inventory.dart';

import '../../../core/common/app_helper.dart';

final inventoryControllerProvider = StateNotifierProvider<InventoryController, InventoryControllerData>((ref) {
  return InventoryController(inventoryRepo: ref.watch(inventoryRepoProvider), ref: ref);
});

class InventoryController extends StateNotifier<InventoryControllerData> {
  InventoryController({required InventoryRepo inventoryRepo, required Ref ref})
      : _inventoryRepo = inventoryRepo,
        _ref = ref,
        super(InventoryControllerData(inventories: []));
  final InventoryRepo _inventoryRepo;
  final Ref _ref;

  Future<void> getInventories(BuildContext context) async {
    set(loading: true);
    final result = await _inventoryRepo.getInventories();

    return result.fold(
      (failure) {
        showSnackBar(context: context, message: failure.message);
        set(loading: false);
      },
      (inventories) {
        set(loading: false, inventories: inventories);
      },
    );
  }

  void createInventory({
    required BuildContext context,
    required String name,
    required String description,
  }) async {
    if (!state.creating) {
      set(creating: true);

      String body = jsonEncode({
        "name": name,
        "description": description,
      });

      final result = await _inventoryRepo.createInventory(body);

      set(creating: false);

      result.fold(
        (failure) => showError(context: context, error: failure.message),
        (success) async {
          List<Inventory> inventories = state.inventories;

          final inventory = success.data != null ? success.data as Inventory : Inventory(id: 0, userId: 0, name: name, description: description, createdAt: "createdAt");

          inventories.add(inventory);

          state = state.copyWith(inventories: inventories);
          showSnackBar(context: context, message: success.message);
          Get.back();
        },
      );
    }
  }

  void updateInventory({
    required BuildContext context,
    required String name,
    required String description,
    required Inventory inventory,
    required int index,
  }) async {
    if (!state.updating) {
      set(updating: true);

      String body = jsonEncode({
        "id": inventory.id,
        "name": name,
        "description": description,
      });

      final result = await _inventoryRepo.updateInventory(body);

      result.fold(
        (failure) {
          showError(context: context, error: failure.message);
          set(updating: false);
        },
        (success) async {
          List<Inventory> inventories = state.inventories;

          final newInventory = success.data != null ? success.data as Inventory : inventory;

          inventories.removeAt(index);
          inventories.insert(index, newInventory);

          set(inventories: inventories, updating: false);
          showSnackBar(context: context, message: success.message);
          Get.back();
        },
      );
    }
  }

  void deleteInventory({
    required BuildContext context,
    required Inventory inventory,
  }) async {
    if (!state.deleting) {
      set(deleting: true);

      final result = await _inventoryRepo.deleteInventory(inventory.id);

      result.fold(
        (failure) {
          showError(context: context, error: failure.message);
          set(deleting: false);
        },
        (success) async {
          List<Inventory> inventories = state.inventories;

          inventories.remove(inventory);

          state = state.copyWith(inventories: inventories);
          set(deleting: false, showEditDeleteButton: false);
          showSnackBar(context: context, message: success.message);
        },
      );
    }
  }

  set({
    bool? creating,
    bool? updating,
    bool? deleting,
    bool? loading,
    bool? showEditDeleteButton,
    int? selectedInvetoryIndex,
    List<Inventory>? inventories,
  }) {
    if (creating != null) {
      state = state.copyWith(creating: creating);
    }
    if (updating != null) {
      state = state.copyWith(updating: updating);
    }
    if (deleting != null) {
      state = state.copyWith(deleting: deleting);
    }
    if (loading != null) {
      state = state.copyWith(loading: loading);
    }
    if (showEditDeleteButton != null) {
      state = state.copyWith(showEditDeleteButton: showEditDeleteButton);
    }
    if (selectedInvetoryIndex != null) {
      state = state.copyWith(selectedInvetoryIndex: selectedInvetoryIndex);
    }
    if (inventories != null) {
      state = state.copyWith(inventories: inventories);
    }
  }
}

class InventoryControllerData {
  final bool creating;
  final bool updating;
  final bool deleting;
  final bool loading;
  final bool showEditDeleteButton;
  final int selectedInvetoryIndex;

  final List<Inventory> inventories;

  InventoryControllerData({
    this.creating = false,
    this.updating = false,
    this.deleting = false,
    this.loading = false,
    this.showEditDeleteButton = false,
    this.selectedInvetoryIndex = 0,
    required this.inventories,
  });

  InventoryControllerData copyWith({
    bool? creating,
    bool? updating,
    bool? deleting,
    bool? loading,
    bool? showEditDeleteButton,
    int? selectedInvetoryIndex,
    List<Inventory>? inventories,
  }) {
    return InventoryControllerData(
      creating: creating ?? this.creating,
      updating: updating ?? this.updating,
      deleting: deleting ?? this.deleting,
      loading: loading ?? this.loading,
      showEditDeleteButton: showEditDeleteButton ?? this.showEditDeleteButton,
      selectedInvetoryIndex: selectedInvetoryIndex ?? this.selectedInvetoryIndex,
      inventories: inventories ?? this.inventories,
    );
  }

  @override
  String toString() {
    return 'InventoryControllerData(creating: $creating, updating: $updating, deleting: $deleting, loading: $loading, showEditDeleteButton: $showEditDeleteButton, selectedInvetoryIndex: $selectedInvetoryIndex, inventories: $inventories)';
  }

  @override
  bool operator ==(covariant InventoryControllerData other) {
    if (identical(this, other)) return true;

    return other.creating == creating &&
        other.updating == updating &&
        other.deleting == deleting &&
        other.loading == loading &&
        other.showEditDeleteButton == showEditDeleteButton &&
        other.selectedInvetoryIndex == selectedInvetoryIndex &&
        listEquals(other.inventories, inventories);
  }

  @override
  int get hashCode {
    return creating.hashCode ^ updating.hashCode ^ deleting.hashCode ^ loading.hashCode ^ showEditDeleteButton.hashCode ^ selectedInvetoryIndex.hashCode ^ inventories.hashCode;
  }
}
