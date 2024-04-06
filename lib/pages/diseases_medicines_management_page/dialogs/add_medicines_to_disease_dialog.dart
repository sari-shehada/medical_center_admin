import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_center_admin/core/services/http_service.dart';
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
          width: screenSize.width * .7,
          height: screenSize.height * .55,
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
                    'إضافة أدوية للمرض',
                    style: TextStyle(fontSize: 30.sp),
                  ),
                ],
              ),
              AddVerticalSpacing(value: 20.h),
              Expanded(
                child: CustomFutureBuilder(
                  future: allMedicinesFuture,
                  builder: (BuildContext context, List<Medicine> snapshot) {
                    return ListView.builder(
                      itemCount: snapshot.length,
                      itemBuilder: (context, index) {
                        return ListTile();
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
}
