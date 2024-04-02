import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_center_admin/config/theme/app_colors.dart';
import 'package:medical_center_admin/core/services/http_service.dart';
import 'package:medical_center_admin/core/services/snackbar_service.dart';
import 'package:medical_center_admin/core/ui_utils/buttons/custom_filled_button.dart';
import 'package:medical_center_admin/core/ui_utils/spacing_utils.dart';
import 'package:medical_center_admin/core/widgets/custom_future_builder.dart';
import 'package:medical_center_admin/models/medicine.dart';
import 'package:medical_center_admin/pages/medicine_management_page/add_medicine_dialog/add_medicine_dialog.dart';
import 'package:medical_center_admin/pages/medicine_management_page/medicine_card_widget.dart';
import 'package:medical_center_admin/shared_widgets/refresh_list_button.dart';

class MedicineManagementPage extends StatefulWidget {
  const MedicineManagementPage({super.key});

  @override
  State<MedicineManagementPage> createState() => _MedicineManagementPageState();
}

class _MedicineManagementPageState extends State<MedicineManagementPage> {
  late Future<List<Medicine>> medicinesFuture;

  @override
  void initState() {
    medicinesFuture = getMedicinesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Row(
            children: [
              Text(
                'إدارة الأدوية',
                style: TextStyle(
                  fontSize: 30.sp,
                  color: primaryColor,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  CustomFilledButton(
                    width: 250.w,
                    onTap: () => addNewMedicine(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'اضافة دواء جديد',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AddHorizontalSpacing(value: 15.w),
                  RefreshListButton(
                    refreshCallback: () => updateList(),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: CustomFutureBuilder(
            future: medicinesFuture,
            builder: (context, medicines) => GridView.builder(
              itemCount: medicines.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                return MedicineCardWidget(
                  medicine: medicines[index],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<List<Medicine>> getMedicinesList() async {
    return HttpService.parsedMultiGet(
      endPoint: 'medicines/',
      mapper: Medicine.fromMap,
    );
  }

  void updateList() {
    medicinesFuture = getMedicinesList();
    setState(() {});
  }

  Future<void> addNewMedicine() async {
    var result = await Get.dialog(
      const AddNewMedicineDialog(),
    );
    if (result == true) {
      SnackBarService.showSuccessSnackbar(
        'تمت العملية بنجاح',
      );
      updateList();
    }
  }
}
