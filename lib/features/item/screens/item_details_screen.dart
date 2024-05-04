import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_flutter/models/item.dart';

import '../../../core/constants/api_endpoints.dart';

class ItemDetailsScreen extends ConsumerWidget {
  const ItemDetailsScreen({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String imagePath = item.image.isNotEmpty ? ApiEndpoints.imageUrl + item.image : "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Details"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
          child: ListView(
            children: [
              if (imagePath.isNotEmpty) Image.network(imagePath, height: 200),
              const SizedBox(height: 10),
              Text(
                item.name,
                style: TextStyle(fontSize: 16.w, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text(
                "Quantity: ${item.qty}",
                style: TextStyle(fontSize: 16.w),
              ),
              const SizedBox(height: 10),
              Text(
                item.description,
                style: TextStyle(fontSize: 15.w),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
