import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_flutter/models/item.dart';

class ItemDetailsScreen extends ConsumerStatefulWidget {
  const ItemDetailsScreen({super.key, required this.item});
  final Item item;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends ConsumerState<ItemDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Details"),
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}
