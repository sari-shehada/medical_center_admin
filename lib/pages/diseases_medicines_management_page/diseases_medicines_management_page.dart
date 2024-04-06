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
import 'package:medical_center_admin/pages/medicine_management_page/medicine_card_widget.dart';

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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.disease.name,
            style: TextStyle(
              fontSize: 28.sp,
              color: primaryColor,
            ),
          ),
          AddVerticalSpacing(value: 20.h),
          Expanded(
            child: CustomFutureBuilder(
              future: getMedicinesList(),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    return MedicineCardWidget(
                      medicine: medicines[index],
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
      setState(() {});
    }
  }

  Future<List<Medicine>> getMedicinesList() async {
    return await HttpService.parsedMultiGet(
      endPoint: 'disease/${widget.disease.id}/medicines/',
      mapper: Medicine.fromMap,
    );
  }
}
