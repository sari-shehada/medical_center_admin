import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import '../../shared_widgets/page_header_widget.dart';
import '../../core/ui_utils/custom_divider.dart';
import '../../core/ui_utils/gender_icon_widget.dart';
import '../../core/ui_utils/title_details_spaced_widget.dart';
import '../../shared_widgets/refresh_list_button.dart';
import '../../config/theme/app_colors.dart';
import '../../core/extensions/date_time_extensions.dart';
import '../../core/services/http_service.dart';
import '../../core/services/snackbar_service.dart';
import '../../core/ui_utils/buttons/custom_filled_button.dart';
import '../../core/ui_utils/spacing_utils.dart';
import '../../core/widgets/custom_future_builder.dart';
import '../../managers/account_manager.dart';
import 'models/doctor.dart';

class PendingDoctorApplicationsPage extends StatefulWidget {
  const PendingDoctorApplicationsPage({super.key});

  @override
  State<PendingDoctorApplicationsPage> createState() =>
      _PendingDoctorApplicationsPageState();
}

class _PendingDoctorApplicationsPageState
    extends State<PendingDoctorApplicationsPage> {
  late Future<List<Doctor>> pendingDocs;

  Doctor? selectedDoctor;
  @override
  void initState() {
    pendingDocs = getPendingDoctors();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeaderWidget(
          iconData: FontAwesomeIcons.userDoctor,
          title: 'طلبات انضمام الأطباء الجديدة',
          subTitle:
              'قم بعرض طلبات انتساب الأطباء الجديدة والموافقة عليها أو رفضها',
          actions: [
            RefreshListButton(
              refreshCallback: () => updateList(),
            ),
          ],
        ),
        Expanded(
          child: CustomFutureBuilder(
            future: pendingDocs,
            builder: (context, doctors) => doctors.isEmpty
                ? const NoPendingDoctorsWidget()
                : Row(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: doctors.length,
                          itemBuilder: (context, index) {
                            var doctor = doctors[index];
                            return ListTile(
                              onTap: () => selectDoctor(doctor),
                              title: Text(
                                doctor.fullName,
                                style: TextStyle(
                                  fontSize: 23.sp,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              leading: GenderIconWidget(
                                isMale: doctor.isMale,
                              ),
                              selected: selectedDoctor == doctor,
                              subtitle: Row(
                                children: [
                                  const Text(
                                    'تاريخ بدء مزاولة المهنة',
                                  ),
                                  const Spacer(),
                                  Text(
                                    doctor.careerStartDate.getDateOnly(),
                                    style: const TextStyle(
                                      color: secondary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const CustomDivider(),
                        ),
                      ),
                      VerticalDivider(
                        endIndent: 20.h,
                        color: Colors.grey.shade400,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          child: selectedDoctor == null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.monitor_heart,
                                        size: 200.sp,
                                      ),
                                      AddVerticalSpacing(value: 50.h),
                                      Text(
                                        'قم باختيار أحد الأطباد لعرض التفاصيل',
                                        style: TextStyle(
                                          fontSize: 25.sp,
                                        ),
                                      ),
                                      AddVerticalSpacing(value: 100.h),
                                    ],
                                  ),
                                )
                              : DoctorDetailsWindow(
                                  doctor: selectedDoctor!,
                                  updateListCallback: () => updateList(),
                                ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<List<Doctor>> getPendingDoctors() async {
    return await HttpService.parsedMultiGet(
      endPoint: 'doctors/pending/',
      mapper: Doctor.fromMap,
    );
  }

  void updateList() {
    selectedDoctor = null;
    pendingDocs = getPendingDoctors();
    setState(() {});
  }

  void selectDoctor(Doctor doctor) {
    if (doctor == selectedDoctor) {
      selectedDoctor = null;
      setState(() {});
      return;
    }
    selectedDoctor = doctor;
    setState(() {});
  }
}

class NoPendingDoctorsWidget extends StatelessWidget {
  const NoPendingDoctorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.check,
            size: 200.sp,
          ),
          AddVerticalSpacing(value: 20.h),
          Text(
            'ما من طلبات انتساب جديدة',
            style: TextStyle(
              fontSize: 25.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorDetailsWindow extends StatefulWidget {
  const DoctorDetailsWindow({
    super.key,
    required this.doctor,
    required this.updateListCallback,
  });

  final Doctor doctor;
  final VoidCallback updateListCallback;
  @override
  State<DoctorDetailsWindow> createState() => _DoctorDetailsWindowState();
}

class _DoctorDetailsWindowState extends State<DoctorDetailsWindow> {
  Doctor get doctor => widget.doctor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 50.sp,
            child: GenderIconWidget(
              isMale: doctor.isMale,
              color: primaryColor,
              size: 50.sp,
            ),
          ),
          AddVerticalSpacing(value: 20.h),
          Text(
            doctor.fullName,
            style: TextStyle(
              fontSize: 25.sp,
              color: primaryColor,
            ),
          ),
          AddVerticalSpacing(value: 15.h),
          TitleDetailsSpacedWidget(
            icon: Icons.cake,
            title: 'تاريخ الميلاد',
            details: doctor.dateOfBirth.getDateOnly(),
          ),
          TitleDetailsSpacedWidget(
            icon: Icons.history,
            title: 'تاريخ بدء مزاولة المهنة',
            details: doctor.careerStartDate.getDateOnly(),
          ),
          AddVerticalSpacing(value: 25.h),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'صورة الشهادة',
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          AddVerticalSpacing(value: 5.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.sp),
              child: Image.network(
                doctor.certificateUrl,
              ),
            ),
          ),
          AddVerticalSpacing(value: 25.h),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'الاجرائات',
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          AddVerticalSpacing(value: 25.h),
          Row(
            children: [
              Expanded(
                child: CustomFilledButton(
                  onTap: () => acceptDoctor(),
                  child: 'الموافقة على الطلب',
                  buttonStatus: buttonStatus,
                ),
              ),
              AddHorizontalSpacing(value: 10.w),
              Expanded(
                child: CustomFilledButton(
                  onTap: () => rejectDoctor(),
                  child: 'رفض الطلب',
                  buttonStatus: buttonStatus,
                  backgroundColor: Colors.red.shade400,
                ),
              ),
            ],
          ),
          AddVerticalSpacing(value: 15.h),
          if (isExecutingAction)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: const LinearProgressIndicator(),
            ),
          AddVerticalSpacing(value: 35.h),
        ],
      ),
    );
  }

  void setIsExecutingAction(bool value) {
    isExecutingAction = value;
    if (isExecutingAction) {
      buttonStatus.value = CustomButtonStatus.disabled;
    } else {
      buttonStatus.value = CustomButtonStatus.enabled;
    }
    setState(() {});
  }

  Future<void> acceptDoctor() async {
    setIsExecutingAction(true);
    var response = await HttpService.rawFullResponsePost(
        endPoint: 'doctors/${doctor.id}/approveApplication/',
        body: {
          'adminId': AccountManager.instance.user!.id,
        });
    if (response.statusCode == 200) {
      SnackBarService.showNeutralSnackbar(
        'تم قبول طلب الانضمام',
      );
      widget.updateListCallback();
      return;
    }
    if (response.statusCode == 400) {
      SnackBarService.showSuccessSnackbar(
        'لقد قام مشرف اخر بقبول الطلب',
      );
      widget.updateListCallback();
      return;
    }
    if (response.statusCode == 404) {
      SnackBarService.showNeutralSnackbar(
        'لقد قام مشرف اخر برفض الطلب',
      );
      widget.updateListCallback();
    }
  }

  Future<void> rejectDoctor() async {
    setIsExecutingAction(true);
    var response = await HttpService.rawFullResponsePost(
      endPoint: 'doctors/${doctor.id}/rejectApplication/',
    );
    if (response.statusCode == 200) {
      SnackBarService.showNeutralSnackbar(
        'تم رفض طلب الانضمام',
      );
      widget.updateListCallback();
      return;
    }
    if (response.statusCode == 400) {
      SnackBarService.showNeutralSnackbar(
        'لقد قام مشرف اخر بقبول الطلب',
      );
      widget.updateListCallback();
      return;
    }
    if (response.statusCode == 404) {
      SnackBarService.showNeutralSnackbar(
        'لقد قام مشرف اخر برفض الطلب',
      );
      widget.updateListCallback();
    }
  }

  bool isExecutingAction = false;
  Rx<CustomButtonStatus> buttonStatus = CustomButtonStatus.enabled.obs;
}
