import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_flutter/models/item.dart';

class EditItemScreen extends ConsumerStatefulWidget {
  const EditItemScreen({
    super.key,
    required this.index,
    required this.item,
  });

  final Item item;
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends ConsumerState<EditItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Item"),
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}
