import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inventory_flutter/features/item/controllers/item_controller.dart';
import 'package:inventory_flutter/features/item/screens/create_item_screen.dart';
import 'package:inventory_flutter/features/item/widgets/item_card.dart';
import 'package:inventory_flutter/models/inventory.dart';
import 'package:inventory_flutter/widgets/loader.dart';

import '../../../models/item.dart';

class ViewItemsScreen extends ConsumerStatefulWidget {
  const ViewItemsScreen({super.key, required this.inventory});
  final Inventory inventory;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewItemsScreenState();
}

class _ViewItemsScreenState extends ConsumerState<ViewItemsScreen> {
  loadData() async {
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      ref.read(itemControllerProvider.notifier).getItems(context: context, inventoryId: widget.inventory.id);
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.inventory.name),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All Items",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16.w, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ref.watch(itemControllerProvider).loading
                    ? const Loader()
                    : ref.watch(itemControllerProvider).items.isNotEmpty
                        ? ListView(
                            children: List.generate(ref.watch(itemControllerProvider).items.length, (index) {
                              final Item item = ref.watch(itemControllerProvider).items[index];
                              return ItemCard(item: item, index: index);
                            }),
                          )
                        : Center(
                            child: Text(
                              "No Item found",
                              style: TextStyle(fontSize: 15.w),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () async {
              Get.to(() => CreateItemScreen(inventory: widget.inventory));
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
