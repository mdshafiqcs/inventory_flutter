// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

import '../../../core/common/app_helper.dart';
import '../../../models/item.dart';
import '../repositories/item_repo.dart';

final itemControllerProvider = StateNotifierProvider<ItemController, ItemControllerData>((ref) {
  return ItemController(itemRepo: ref.watch(itemRepoProvider), ref: ref);
});

class ItemController extends StateNotifier<ItemControllerData> {
  ItemController({required ItemRepo itemRepo, required Ref ref})
      : _itemRepo = itemRepo,
        _ref = ref,
        super(ItemControllerData(items: []));
  final ItemRepo _itemRepo;
  final Ref _ref;

  Future<void> getItems({required BuildContext context, required int inventoryId}) async {
    set(loading: true);
    final result = await _itemRepo.getItems(inventoryId);

    return result.fold(
      (failure) {
        showSnackBar(context: context, message: failure.message);
        set(loading: false);
      },
      (items) {
        set(loading: false, items: items);
      },
    );
  }

  void createItem({
    required BuildContext context,
    required String name,
    required String description,
    required int qty,
    required int inventoryId,
  }) async {
    if (state.uploadedImagePath.isEmpty) {
      showError(context: context, error: "Select an Image first");
    } else {
      if (!state.creating) {
        set(creating: true);

        Item item = Item(id: 0, inventoryId: inventoryId, name: name, description: description, image: "", qty: qty, createdAt: "");

        final result = await _itemRepo.createItem(item, state.uploadedImagePath);

        set(creating: false);

        result.fold(
          (failure) => showError(context: context, error: failure.message),
          (success) async {
            List<Item> items = state.items;

            final newItem = success.data != null ? success.data as Item : item;

            items.add(newItem);

            set(items: items, uploadedImagePath: "");
            showSnackBar(context: context, message: success.message);

            Get.back();
          },
        );
      }
    }
  }

  void updateItem({
    required BuildContext context,
    required String name,
    required String description,
    required int qty,
    required Item item,
    required int index,
  }) async {
    if (!state.updating) {
      set(updating: true);

      Item uploadItem = item.copyWith(name: name, description: description, qty: qty);

      final result = await _itemRepo.updateItem(uploadItem, state.uploadedImagePath);

      set(updating: false);

      result.fold(
        (failure) => showError(context: context, error: failure.message),
        (success) async {
          List<Item> items = state.items;

          final newItem = success.data != null ? success.data as Item : uploadItem;

          items.remove(item);

          items.insert(index, newItem);

          set(items: items, uploadedImagePath: "");
          showSnackBar(context: context, message: success.message);

          Get.back();
        },
      );
    }
  }

  void deleteItem({
    required BuildContext context,
    required Item item,
  }) async {
    if (!state.deleting) {
      set(deleting: true);

      final result = await _itemRepo.deleteItem(item.id);

      result.fold(
        (failure) {
          showError(context: context, error: failure.message);
          set(deleting: false);
        },
        (success) async {
          List<Item> items = state.items;

          items.remove(item);

          set(items: items, deleting: false, showEditDeleteButton: false);
          showSnackBar(context: context, message: success.message);
        },
      );
    }
  }

  selectImage() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      set(uploadedImagePath: pickedFile.path);
      log("uploadedImagePath ${state.uploadedImagePath}");
    } else {
      Get.snackbar(
        "Not selected",
        "No image selected.",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  set({
    String? uploadedImagePath,
    bool? creating,
    bool? updating,
    bool? deleting,
    bool? loading,
    bool? showEditDeleteButton,
    int? selectedItemIndex,
    List<Item>? items,
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
    if (selectedItemIndex != null) {
      state = state.copyWith(selectedItemIndex: selectedItemIndex);
    }
    if (items != null) {
      state = state.copyWith(items: items);
    }
    if (uploadedImagePath != null) {
      state = state.copyWith(uploadedImagePath: uploadedImagePath);
    }
  }
}

class ItemControllerData {
  final bool creating;
  final String uploadedImagePath;
  final bool updating;
  final bool deleting;
  final bool loading;
  final bool showEditDeleteButton;
  final int selectedItemIndex;

  final List<Item> items;

  ItemControllerData({
    this.creating = false,
    this.uploadedImagePath = "",
    this.updating = false,
    this.deleting = false,
    this.loading = false,
    this.showEditDeleteButton = false,
    this.selectedItemIndex = 0,
    required this.items,
  });

  ItemControllerData copyWith({
    bool? creating,
    String? uploadedImagePath,
    bool? updating,
    bool? deleting,
    bool? loading,
    bool? showEditDeleteButton,
    int? selectedItemIndex,
    List<Item>? items,
  }) {
    return ItemControllerData(
      creating: creating ?? this.creating,
      uploadedImagePath: uploadedImagePath ?? this.uploadedImagePath,
      updating: updating ?? this.updating,
      deleting: deleting ?? this.deleting,
      loading: loading ?? this.loading,
      showEditDeleteButton: showEditDeleteButton ?? this.showEditDeleteButton,
      selectedItemIndex: selectedItemIndex ?? this.selectedItemIndex,
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return 'ItemControllerData(creating: $creating, uploadedImagePath: $uploadedImagePath, updating: $updating, deleting: $deleting, loading: $loading, showEditDeleteButton: $showEditDeleteButton, selectedItemIndex: $selectedItemIndex, items: $items)';
  }

  @override
  bool operator ==(covariant ItemControllerData other) {
    if (identical(this, other)) return true;

    return other.creating == creating &&
        other.uploadedImagePath == uploadedImagePath &&
        other.updating == updating &&
        other.deleting == deleting &&
        other.loading == loading &&
        other.showEditDeleteButton == showEditDeleteButton &&
        other.selectedItemIndex == selectedItemIndex &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return creating.hashCode ^ uploadedImagePath.hashCode ^ updating.hashCode ^ deleting.hashCode ^ loading.hashCode ^ showEditDeleteButton.hashCode ^ selectedItemIndex.hashCode ^ items.hashCode;
  }
}
