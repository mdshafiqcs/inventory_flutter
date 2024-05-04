import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/image_strings.dart';
import '../../../models/item.dart';
import '../../../widgets/loader.dart';
import '../controllers/item_controller.dart';
import '../screens/edit_item_screen.dart';
import '../screens/item_details_screen.dart';

class ItemCard extends ConsumerWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.index,
  });

  final Item item;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePath = item.image.isNotEmpty ? ApiEndpoints.imageUrl + item.image : "";
    return GestureDetector(
      onLongPress: () {
        ref.watch(itemControllerProvider.notifier).set(selectedItemIndex: index);
        ref.watch(itemControllerProvider.notifier).set(showEditDeleteButton: true);
      },
      onTap: () {
        if (ref.watch(itemControllerProvider).showEditDeleteButton) {
          ref.watch(itemControllerProvider.notifier).set(showEditDeleteButton: false);
        }
        Get.to(() => ItemDetailsScreen(item: item));
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imagePath.isNotEmpty ? NetworkImage(imagePath) : AssetImage(ImageStrings.noImage) as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(fontSize: 16.w, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.w),
                        Text(
                          item.description,
                          style: TextStyle(fontSize: 15.w),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ref.watch(itemControllerProvider).selectedItemIndex == index && ref.watch(itemControllerProvider).showEditDeleteButton
                  ? Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(() => EditItemScreen(index: index, item: item));
                          },
                          child: const Text(
                            "Edit",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ref.watch(itemControllerProvider.notifier).deleteItem(context: context, item: item);
                          },
                          child: ref.watch(itemControllerProvider).deleting
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
