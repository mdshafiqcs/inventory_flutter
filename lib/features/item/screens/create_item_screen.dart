import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:inventory_flutter/features/item/controllers/item_controller.dart';
import 'package:inventory_flutter/models/inventory.dart';
import 'package:inventory_flutter/widgets/unfocus_ontap.dart';

import '../../../core/common/app_helper.dart';
import '../../../widgets/custom_button.dart';

class CreateItemScreen extends ConsumerStatefulWidget {
  const CreateItemScreen({super.key, required this.inventory});

  final Inventory inventory;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends ConsumerState<CreateItemScreen> {
  final _createKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _qtyController = TextEditingController();

  save() {
    hideKeyboard(context);
    if (_createKey.currentState != null) {
      if (_createKey.currentState!.validate()) {
        ref.watch(itemControllerProvider.notifier).createItem(
              context: context,
              name: _nameController.text.trim(),
              description: _descriptionController.text.trim(),
              qty: int.parse(_qtyController.text.trim()),
              inventoryId: widget.inventory.id,
            );
      }
    }
  }

  setValue() async {
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      ref.watch(itemControllerProvider.notifier).set(uploadedImagePath: "");
    });
  }

  @override
  void initState() {
    setValue();
    super.initState();
  }

  // @override
  // void deactivate() {
  //   ref.watch(itemControllerProvider.notifier).set(uploadedImagePath: "");
  //   super.deactivate();
  // }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _qtyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add new Item"),
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
                      labelText: "Item Name",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                    ),
                    validator: RequiredValidator(errorText: "Item Name is required").call,
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
                  SizedBox(height: 10.w),
                  TextFormField(
                    controller: _qtyController,
                    style: TextStyle(fontSize: 15.w),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      labelText: "Quantity",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                      alignLabelWithHint: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    validator: RequiredValidator(errorText: "Quantity is required").call,
                  ),
                  SizedBox(height: 10.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          ref.watch(itemControllerProvider.notifier).selectImage();
                        },
                        child: Text(
                          "Upload Image",
                          style: TextStyle(fontSize: 16.w),
                        ),
                      ),
                    ],
                  ),
                  if (ref.watch(itemControllerProvider).uploadedImagePath.isNotEmpty)
                    Image.file(
                      File(ref.watch(itemControllerProvider).uploadedImagePath),
                      height: 200,
                    ),
                  SizedBox(height: 20.w),
                  CustomButton(
                    text: "Save",
                    onPressed: save,
                    loading: ref.watch(itemControllerProvider).creating,
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
