import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inventory_flutter/features/inventory/controllers/inventory_controller.dart';
import 'package:inventory_flutter/features/inventory/screens/edit_inventory_screen.dart';
import 'package:inventory_flutter/features/item/screens/view_items_screen.dart';
import 'package:inventory_flutter/widgets/loader.dart';

import '../../../models/inventory.dart';

class InventoryCard extends ConsumerWidget {
  const InventoryCard({
    super.key,
    required this.inventory,
    required this.index,
  });

  final Inventory inventory;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onLongPress: () {
        ref.watch(inventoryControllerProvider.notifier).set(selectedInvetoryIndex: index);
        ref.watch(inventoryControllerProvider.notifier).set(showEditDeleteButton: true);
      },
      onTap: () {
        if (ref.watch(inventoryControllerProvider).showEditDeleteButton) {
          ref.watch(inventoryControllerProvider.notifier).set(showEditDeleteButton: false);
        }
        Get.to(() => ViewItemsScreen(inventory: inventory));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.w),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                inventory.name,
                style: TextStyle(fontSize: 16.w, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5.w),
              Text(
                inventory.description,
                style: TextStyle(fontSize: 15.w),
              ),
              ref.watch(inventoryControllerProvider).selectedInvetoryIndex == index && ref.watch(inventoryControllerProvider).showEditDeleteButton
                  ? Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(() => EditInventoryScreen(index: index, inventory: inventory));
                          },
                          child: const Text(
                            "Edit",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ref.watch(inventoryControllerProvider.notifier).deleteInventory(context: context, inventory: inventory);
                          },
                          child: ref.watch(inventoryControllerProvider).deleting
                              ? const Loader()
                              : const Text(
                                  "Delete",
                                  style: TextStyle(fontSize: 14),
                                ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
