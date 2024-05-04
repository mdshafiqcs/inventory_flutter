import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:inventory_flutter/core/common/app_helper.dart';
import 'package:inventory_flutter/features/inventory/controllers/inventory_controller.dart';
import 'package:inventory_flutter/widgets/unfocus_ontap.dart';

import '../../../widgets/custom_button.dart';

class CreateInventoryScreen extends ConsumerStatefulWidget {
  const CreateInventoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateInventoryScreenState();
}

class _CreateInventoryScreenState extends ConsumerState<CreateInventoryScreen> {
  final _createKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  save() {
    hideKeyboard(context);
    if (_createKey.currentState != null) {
      if (_createKey.currentState!.validate()) {
        ref.watch(inventoryControllerProvider.notifier).createInventory(
              context: context,
              name: _nameController.text.trim(),
              description: _descriptionController.text.trim(),
            );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create New Inventory"),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
            child: Form(
              key: _createKey,
              child: ListView(
                children: [
                  SizedBox(height: 10.w),
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(fontSize: 15.w),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      labelText: "Inventory Name",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                    ),
                    validator: RequiredValidator(errorText: "Inventory Name is required").call,
                  ),
                  SizedBox(height: 10.w),
                  TextFormField(
                    controller: _descriptionController,
                    style: TextStyle(fontSize: 15.w),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      labelText: "Description",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                      alignLabelWithHint: true,
                    ),
                    validator: RequiredValidator(errorText: "Description is required").call,
                    maxLines: 3,
                  ),
                  SizedBox(height: 20.w),
                  CustomButton(
                    text: "Save",
                    onPressed: save,
                    loading: ref.watch(inventoryControllerProvider).creating,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
