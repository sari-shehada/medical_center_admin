import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../shared_widgets/page_header_widget.dart';
import '../../config/theme/app_colors.dart';
import '../../core/services/http_service.dart';
import '../../core/services/snackbar_service.dart';
import '../../core/ui_utils/buttons/custom_filled_button.dart';
import '../../core/ui_utils/loaders/linear_loading_indicator_widget.dart';
import '../../core/ui_utils/spacing_utils.dart';
import '../../core/widgets/custom_future_builder.dart';
import '../../models/medicine.dart';
import 'add_medicine_dialog/add_medicine_dialog.dart';
import 'medicine_card_widget.dart';
import '../../shared_widgets/refresh_list_button.dart';

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
        PageHeaderWidget(
          iconData: FontAwesomeIcons.syringe,
          title: 'إدارة الأدوية',
          subTitle: 'قم بعرض الأدوية المتاحة في النظام واضافة او حذف أدوية',
          actions: [
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
        AddVerticalSpacing(value: 15.h),
        Expanded(
          child: CustomFutureBuilder(
            future: medicinesFuture,
            builder: (context, medicines) => GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              itemCount: medicines.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 0.8,
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 20.w,
              ),
              itemBuilder: (context, index) {
                return MedicineCardWidget(
                  deleteMedicineCallback: () => deleteMedicine(
                    medicines[index].id,
                  ),
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

  Future<void> deleteMedicine(int medicineId) async {
    var result = await Get.dialog(
      const DeleteSomethingConfirmationDialog(thingName: 'دواء'),
    );
    if (result == true) {
      Get.showOverlay(
        loadingWidget: const FullScreenLoader(),
        asyncFunction: () async {
          var response = await HttpService.rawFullResponsePost(
            endPoint: 'medicines/$medicineId/delete/',
          );
          if (response.statusCode == 200) {
            updateList();
          }
        },
      );
    }
  }
}

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Colors.transparent,
      child: Center(
        child: LinearLoadingIndicatorWidget(),
      ),
    );
  }
}

class DeleteSomethingConfirmationDialog extends StatelessWidget {
  const DeleteSomethingConfirmationDialog({super.key, required this.thingName});

  final String thingName;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: MediaQuery.sizeOf(context).width * .4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'تأكيد عملية الحذف',
                style: TextStyle(
                  fontSize: 30.sp,
                  color: primaryColor,
                ),
              ),
              AddVerticalSpacing(value: 15.h),
              Text(
                'انت على وشك حذف $thingName, هذا الإجراء نهائي ولا يمكن التراجع عنه',
              ),
              AddVerticalSpacing(value: 25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton(
                    onPressed: () => Get.back(result: true),
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red),
                    ),
                    child: const Text(
                      'متابعة',
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => Get.back(result: false),
                    child: const Text(
                      'الغاء العملية',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
