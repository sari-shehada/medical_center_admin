import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_center_admin/config/theme/app_colors.dart';
import 'package:medical_center_admin/core/services/http_service.dart';
import 'package:medical_center_admin/core/services/snackbar_service.dart';
import 'package:medical_center_admin/core/ui_utils/buttons/custom_filled_button.dart';
import 'package:medical_center_admin/core/ui_utils/spacing_utils.dart';
import 'package:medical_center_admin/core/widgets/custom_future_builder.dart';
import 'package:medical_center_admin/models/disease.dart';
import 'package:medical_center_admin/models/medicine.dart';

class AddMedicinesToDiseaseDialog extends StatefulWidget {
  const AddMedicinesToDiseaseDialog({super.key, required this.disease});

  final Disease disease;
  @override
  State<AddMedicinesToDiseaseDialog> createState() =>
      _AddMedicinesToDiseaseDialogState();
}

class _AddMedicinesToDiseaseDialogState
    extends State<AddMedicinesToDiseaseDialog> {
  late Future<List<Medicine>> allMedicinesFuture;
  late List<int> currentMedicinesIds;

  List<int> selectedMedicines = [];
  @override
  void initState() {
    allMedicinesFuture = getMedicines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: screenSize.width * .6,
          height: screenSize.height * .6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    'إضافة أدوية للمرض',
                    style: TextStyle(fontSize: 30.sp),
                  ),
                  const Spacer(),
                  CustomFilledButton(
                    width: 250.w,
                    buttonStatus: proceedButtonStatus,
                    onTap: () => proceed(),
                    child: 'متابعة',
                  ),
                ],
              ),
              AddVerticalSpacing(value: 15.h),
              Padding(
                padding: EdgeInsets.only(right: 50.w),
                child: const Text(
                  'قم باختيار الادوية المراد اضافتها من القائمة ادناه ثم الضعط على زر المتابعة',
                ),
              ),
              AddVerticalSpacing(value: 20.h),
              Expanded(
                child: CustomFutureBuilder(
                  future: allMedicinesFuture,
                  builder: (BuildContext context, List<Medicine> medicines) {
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 50.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: 0.9,
                        crossAxisSpacing: 15.w,
                        mainAxisSpacing: 20.w,
                      ),
                      itemCount: medicines.length,
                      itemBuilder: (context, index) {
                        final Medicine medicine = medicines[index];
                        return SelectableMedicineCardWidget(
                          isSelected: selectedMedicines.contains(medicine.id),
                          medicine: medicine,
                          onSelectCallback: (medicine) =>
                              toggleSelectedMedicine(medicine),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Medicine>> getCurrentMedicinesList() async {
    return await HttpService.parsedMultiGet(
      endPoint: 'disease/${widget.disease.id}/medicines/',
      mapper: Medicine.fromMap,
    );
  }

  Future<List<Medicine>> getMedicines() async {
    List<Medicine> currentMeds = await getCurrentMedicinesList();
    currentMedicinesIds = currentMeds.map((e) => e.id).toList();

    List<Medicine> newMeds = await HttpService.parsedMultiGet(
      endPoint: 'medicines/',
      mapper: Medicine.fromMap,
    );
    return newMeds
        .where((element) => !currentMedicinesIds.contains(element.id))
        .toList();
  }

  Rx<CustomButtonStatus> proceedButtonStatus = CustomButtonStatus.enabled.obs;
  Future<void> proceed() async {
    try {
      if (selectedMedicines.isEmpty) {
        SnackBarService.showErrorSnackbar(
          'يرجى اختيار دواء واحد على الأقل للمتابعة',
        );
        return;
      }
      proceedButtonStatus.value = CustomButtonStatus.processing;
      var result = await HttpService.rawFullResponsePost(
        endPoint: 'disease/${widget.disease.id}/addMedicines/',
        body: {
          'medicineIds': selectedMedicines,
        },
      );
      if (result.statusCode == 201) {
        Get.back(result: true);
      }
    } finally {
      proceedButtonStatus.value = CustomButtonStatus.enabled;
    }
  }

  void toggleSelectedMedicine(Medicine medicine) {
    if (selectedMedicines.contains(medicine.id)) {
      selectedMedicines.remove(medicine.id);
    } else {
      selectedMedicines.add(medicine.id);
    }
    setState(() {});
    return;
  }
}

class SelectableMedicineCardWidget extends StatelessWidget {
  const SelectableMedicineCardWidget({
    super.key,
    required this.isSelected,
    required this.medicine,
    required this.onSelectCallback,
  });

  final Medicine medicine;
  final bool isSelected;
  final Function(Medicine medicine) onSelectCallback;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 400.milliseconds,
      curve: Curves.fastLinearToSlowEaseIn,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: isSelected ? 4.sp : 0.sp,
          color: isSelected ? primaryColor : primaryColor.withOpacity(0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
          ),
        ],
        borderRadius: BorderRadius.circular(
          15.r,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () => onSelectCallback(medicine),
          child: Column(
            children: [
              Expanded(
                flex: 75,
                child: Image.network(
                  medicine.imageUrl,
                ),
              ),
              Expanded(
                flex: 25,
                child: Center(
                  child: Text(
                    medicine.name,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
