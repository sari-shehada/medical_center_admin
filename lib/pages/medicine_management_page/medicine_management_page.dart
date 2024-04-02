import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_center_admin/config/theme/app_colors.dart';
import 'package:medical_center_admin/core/ui_utils/buttons/custom_filled_button.dart';
import 'package:medical_center_admin/core/widgets/custom_future_builder.dart';
import 'package:medical_center_admin/models/medicine.dart';

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
              CustomFilledButton(
                width: 240.w,
                onTap: () => updateList(),
                child: 'تحديث القائمة',
              ),
            ],
          ),
        ),
        Expanded(
          child: CustomFutureBuilder(
            future: medicinesFuture,
            builder: (context, medicines) => Text('data'),
          ),
        ),
      ],
    );
  }

  Future<List<Medicine>> getMedicinesList() async {
    return [];
  }

  void updateList() {
    medicinesFuture = getMedicinesList();
    setState(() {});
  }
}
