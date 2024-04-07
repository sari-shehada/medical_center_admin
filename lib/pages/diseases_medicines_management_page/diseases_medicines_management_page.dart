import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_center_admin/config/theme/app_colors.dart';
import 'package:medical_center_admin/core/services/http_service.dart';
import 'package:medical_center_admin/core/services/snackbar_service.dart';
import 'package:medical_center_admin/core/ui_utils/buttons/custom_filled_button.dart';
import 'package:medical_center_admin/core/ui_utils/spacing_utils.dart';
import 'package:medical_center_admin/core/widgets/custom_future_builder.dart';
import 'package:medical_center_admin/managers/diseases_repository.dart';
import 'package:medical_center_admin/models/disease.dart';
import 'package:medical_center_admin/models/medicine.dart';
import 'package:medical_center_admin/pages/diseases_medicines_management_page/dialogs/add_medicines_to_disease_dialog.dart';

class DiseaseMedicinesManagementPage extends StatefulWidget {
  const DiseaseMedicinesManagementPage({super.key});

  @override
  State<DiseaseMedicinesManagementPage> createState() =>
      _DiseaseMedicinesManagementPageState();
}

class _DiseaseMedicinesManagementPageState
    extends State<DiseaseMedicinesManagementPage> {
  Disease? selectedDisease;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Text(
            'إدارة أدوية الأمراض',
            style: TextStyle(
              fontSize: 30.sp,
              color: primaryColor,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 35,
                child: CustomFutureBuilder(
                  future: DiseasesRepository.diseases,
                  builder: (context, diseases) => ListView.separated(
                    itemCount: diseases.length,
                    itemBuilder: (context, index) {
                      Disease disease = diseases[index];
                      return ListTile(
                        leading: Text(
                          (disease.id).toString(),
                          style: TextStyle(
                            fontSize: 25.sp,
                          ),
                        ),
                        selected: disease == selectedDisease,
                        onTap: () => selectDisease(disease),
                        title: Text(disease.name),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: Colors.grey.shade400,
                      endIndent: 10.w,
                      indent: 20.w,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 65,
                child: SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: selectedDisease == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.find_replace,
                                size: 200.sp,
                              ),
                              AddVerticalSpacing(value: 50.h),
                              Text(
                                'قم باختيار أحد الأمراض لعرض الأدوية',
                                style: TextStyle(
                                  fontSize: 25.sp,
                                ),
                              ),
                              AddVerticalSpacing(value: 100.h),
                            ],
                          ),
                        )
                      : DiseaseMedicinesWindow(
                          key: Key(
                            selectedDisease!.id.toString(),
                          ),
                          disease: selectedDisease!,
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void selectDisease(Disease disease) {
    setState(() {
      if (selectedDisease == disease) {
        selectedDisease = null;
      } else {
        selectedDisease = disease;
      }
    });
  }
}

class DiseaseMedicinesWindow extends StatefulWidget {
  const DiseaseMedicinesWindow({super.key, required this.disease});
  final Disease disease;

  @override
  State<DiseaseMedicinesWindow> createState() => _DiseaseMedicinesWindowState();
}

class _DiseaseMedicinesWindowState extends State<DiseaseMedicinesWindow> {
  late Future<List<Medicine>> diseaseMedicinesFuture;

  List<int> selectedMedicines = [];

  @override
  void initState() {
    diseaseMedicinesFuture = getMedicinesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60.h,
            child: Row(
              children: [
                Text(
                  widget.disease.name,
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: primaryColor,
                  ),
                ),
                const Spacer(),
                if (selectedMedicines.isNotEmpty)
                  CustomFilledButton(
                    width: 350.w,
                    buttonStatus: deleteButtonStatus,
                    onTap: () => deleteSelectedMedicines(),
                    backgroundColor: Colors.red,
                    child: 'حذف الادوية من هذا المرض',
                  ),
              ],
            ),
          ),
          AddVerticalSpacing(value: 20.h),
          Expanded(
            child: CustomFutureBuilder(
              future: diseaseMedicinesFuture,
              builder: (context, medicines) {
                if (medicines.isEmpty) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article,
                          size: 200.sp,
                        ),
                        AddVerticalSpacing(value: 20.h),
                        Text(
                          'لم يتم العثور على أدوية لهذا المرض',
                          style: TextStyle(
                            fontSize: 22.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  itemCount: medicines.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 20.w,
                  ),
                  itemBuilder: (context, index) {
                    return SelectableMedicineCardWidget(
                      medicine: medicines[index],
                      isSelected: selectedMedicines.contains(
                        medicines[index].id,
                      ),
                      onSelectCallback: (Medicine medicine) =>
                          toggleSelectedMedicine(medicine),
                    );
                  },
                );
              },
            ),
          ),
          CustomFilledButton(
            onTap: addNewMedicines,
            child: 'إضافة أدوية جديدة',
          ),
          AddVerticalSpacing(value: 20.h),
        ],
      ),
    );
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

  Future<void> addNewMedicines() async {
    var result = await Get.dialog(
      AddMedicinesToDiseaseDialog(
        disease: widget.disease,
      ),
    );
    if (result == true) {
      SnackBarService.showSuccessSnackbar(
        'تمت العملية بنجاح',
      );
      refreshList();
    }
  }

  Future<List<Medicine>> getMedicinesList() async {
    selectedMedicines = [];
    return await HttpService.parsedMultiGet(
      endPoint: 'disease/${widget.disease.id}/medicines/',
      mapper: Medicine.fromMap,
    );
  }

  void refreshList() {
    setState(() {
      diseaseMedicinesFuture = getMedicinesList();
    });
  }

  Rx<CustomButtonStatus> deleteButtonStatus = CustomButtonStatus.enabled.obs;
  Future<void> deleteSelectedMedicines() async {
    try {
      deleteButtonStatus.value = CustomButtonStatus.processing;

      var result = await HttpService.rawFullResponsePost(
        endPoint: 'disease/${widget.disease.id}/removeMedicines/',
        body: {
          'diseaseMedicineIds': selectedMedicines,
        },
      );
      if (result.statusCode == 200) {
        SnackBarService.showSuccessSnackbar(
          'تمت العملية بنجاح',
        );
        refreshList();
      }
    } finally {
      deleteButtonStatus.value = CustomButtonStatus.enabled;
    }
  }
}
