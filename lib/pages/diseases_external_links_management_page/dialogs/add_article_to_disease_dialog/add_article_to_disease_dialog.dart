import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/services/http_service.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/ui_utils/buttons/custom_filled_button.dart';
import '../../../../core/ui_utils/spacing_utils.dart';
import '../../../../core/ui_utils/text_fields/custom_text_field.dart';
import 'forms/add_article_form.dart';

class AddArticleToDiseaseDialog extends StatefulWidget {
  const AddArticleToDiseaseDialog({super.key, required this.diseaseId});

  final int diseaseId;
  @override
  State<AddArticleToDiseaseDialog> createState() =>
      _AddArticleToDiseaseDialogState();
}

class _AddArticleToDiseaseDialogState extends State<AddArticleToDiseaseDialog> {
  late AddArticleForm form;

  @override
  void initState() {
    form = AddArticleForm(diseaseId: widget.diseaseId);
    super.initState();
  }

  Rx<CustomButtonStatus> addMedicineButtonStatus =
      CustomButtonStatus.enabled.obs;
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
                    'إضافة مقال جديد',
                    style: TextStyle(fontSize: 30.sp),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    AddVerticalSpacing(value: 20.h),
                    CustomTextField(
                      controller: form.titleController,
                      maxLength: 200,
                      label: 'عنوان المقال',
                    ),
                    AddVerticalSpacing(value: 25.h),
                    CustomTextField(
                      controller: form.briefController,
                      label: 'ملخص المقال',
                      maxLength: 500,
                    ),
                    AddVerticalSpacing(value: 25.h),
                    CustomTextField(
                      controller: form.linkController,
                      label: 'رابط المقال',
                      maxLength: 2000,
                    ),
                    AddVerticalSpacing(value: 25.h),
                    Text(
                      'صورة المقال',
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
                            if (await form.pickArticleImage()) {
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
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    AddVerticalSpacing(value: 20.h),
                    CustomFilledButton(
                      onTap: () => addArticle(),
                      buttonStatus: addMedicineButtonStatus,
                      child: 'إضافة المقال',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addArticle() async {
    String? validationMessage = form.validateForm();
    if (validationMessage != null) {
      SnackBarService.showErrorSnackbar(validationMessage);
      return;
    }
    try {
      addMedicineButtonStatus.value = CustomButtonStatus.processing;

      var response = await HttpService.dioMultiPartPost(
        endPoint: 'externalLinks/new/',
        formData: await form.toFormData(),
      );
      if (response.statusCode == 201) {
        Get.back(result: true);
      }
    } catch (e) {
      SnackBarService.showErrorSnackbar('يرجى التأكد من اتصال الانترنت');
    } finally {
      addMedicineButtonStatus.value = CustomButtonStatus.enabled;
    }
  }
}
