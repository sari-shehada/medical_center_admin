import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_center_admin/config/theme/app_colors.dart';
import 'package:medical_center_admin/core/ui_utils/spacing_utils.dart';
import 'package:medical_center_admin/core/ui_utils/text_fields/custom_text_field.dart';
import 'package:medical_center_admin/pages/medicine_management_page/add_medicine_dialog/forms/add_medicine_form.dart';

class AddNewMedicineDialog extends StatefulWidget {
  const AddNewMedicineDialog({super.key});

  @override
  State<AddNewMedicineDialog> createState() => _AddNewMedicineDialogState();
}

class _AddNewMedicineDialogState extends State<AddNewMedicineDialog> {
  AddMedicineForm form = AddMedicineForm();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: screenSize.width * .45,
          height: screenSize.height * .7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.cancel,
                    ),
                  ),
                  AddHorizontalSpacing(value: 20.w),
                  Text(
                    'إضافة دواء جديد',
                    style: TextStyle(fontSize: 30.sp),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    AddVerticalSpacing(value: 20.h),
                    CustomTextField(
                      controller: form.nameController,
                      label: 'اسم الدواء',
                    ),
                    AddVerticalSpacing(value: 25.h),
                    Text(
                      'صورة الدواء',
                      style: TextStyle(fontSize: 28.sp),
                    ),
                    AddVerticalSpacing(value: 25.h),
                    Align(
                      child: Container(
                        height: 400.sp,
                        width: 400.sp,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                            width: 1.5.sp,
                            color: primaryColor,
                          ),
                        ),
                        child: InkWell(
                          onTap: () async {
                            if (await form.pickMedicineImage()) {
                              setState(() {});
                            }
                          },
                          child: form.imageBytes == null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.photo,
                                        size: 85.sp,
                                        color: Colors.grey.shade800,
                                      ),
                                      AddVerticalSpacing(value: 15.h),
                                      Text(
                                        'قم باختيار صورة',
                                        style: TextStyle(
                                          fontSize: 26.sp,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Image.memory(
                                  form.imageBytes!,
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
