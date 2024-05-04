import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/pallete.dart';
import '../../../models/inventory.dart';
import '../../inventory/controllers/inventory_controller.dart';
import '../../inventory/screens/create_inventory_screen.dart';
import '../controllers/home_controller.dart';
import '../widgets/inventory_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  loadData() async {
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      ref.read(inventoryControllerProvider.notifier).getInventories(context);
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
        elevation: 0,
        title: const Text("Inventory App"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.watch(homeControllerProvider.notifier).logout(context);
            },
            icon: ref.watch(homeControllerProvider).checkingLogout ? const CircularProgressIndicator(color: whiteColor) : const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All Inventories",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16.w, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ref.watch(inventoryControllerProvider).loading
                    ? Center(
                        child: SizedBox(
                          width: 50.w,
                          height: 50.w,
                        ),
                      )
                    : ref.watch(inventoryControllerProvider).inventories.isNotEmpty
                        ? ListView(
                            children: List.generate(ref.watch(inventoryControllerProvider).inventories.length, (index) {
                              final Inventory inventory = ref.watch(inventoryControllerProvider).inventories[index];
                              return InventoryCard(inventory: inventory, index: index);
                            }),
                          )
                        : Center(
                            child: Text(
                              "You have not created any Inventory yet.",
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
              Get.to(() => const CreateInventoryScreen());
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
