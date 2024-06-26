import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/ui_utils/buttons/custom_filled_button.dart';
import '../../managers/account_manager.dart';
import '../diseases_external_links_management_page/diseases_external_links_management_page.dart';
import '../diseases_medicines_management_page/diseases_medicines_management_page.dart';
import '../medicine_management_page/medicine_management_page.dart';
import '../../config/string_constants.dart';
import '../../config/theme/app_colors.dart';
import '../../core/ui_utils/app_logo_widget.dart';
import '../../core/ui_utils/spacing_utils.dart';
import '../pending_doctor_applications_page/pending_doctor_applications_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Row(
          children: [
            _DashboardNavigationRailWidget(
              currentIndex: currentIndex,
              onIndexChanged: (int newIndex) {
                currentIndex = newIndex;
                setState(() {});
              },
            ),
            Expanded(
              child: IndexedStack(
                index: currentIndex,
                children: const [
                  PendingDoctorApplicationsPage(),
                  MedicineManagementPage(),
                  DiseasesExternalLinksManagementPage(),
                  DiseaseMedicinesManagementPage(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _DashboardNavigationRailWidget extends StatelessWidget {
  const _DashboardNavigationRailWidget({
    required this.onIndexChanged,
    required this.currentIndex,
  });

  final void Function(int newIndex) onIndexChanged;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryContainer.withOpacity(.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -10),
          ),
          const BoxShadow(
            color: Colors.white,
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          AddVerticalSpacing(value: 20.h),
          AppLogoWidget(
            size: 150.sp,
          ),
          AddVerticalSpacing(value: 20.h),
          Text(
            StringConstants.appName,
            style: TextStyle(
              fontSize: 22.sp,
              color: Colors.grey.shade800,
            ),
          ),
          AddVerticalSpacing(value: 25.h),
          Expanded(
            child: NavigationRail(
              onDestinationSelected: (value) => onIndexChanged(value),
              backgroundColor: Colors.transparent,
              extended: true,
              indicatorColor: primaryColor,
              selectedIconTheme: const IconThemeData(
                color: Colors.white,
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: FaIcon(FontAwesomeIcons.userDoctor),
                  label: Text(
                    'طلبات انضمام الأطباء الجديدة',
                  ),
                ),
                NavigationRailDestination(
                  icon: FaIcon(FontAwesomeIcons.syringe),
                  label: Text(
                    'إدارة الأدوية',
                  ),
                ),
                NavigationRailDestination(
                  icon: FaIcon(FontAwesomeIcons.bookMedical),
                  label: Text(
                    'إدارة مقالات الأمراض',
                  ),
                ),
                NavigationRailDestination(
                  icon: FaIcon(FontAwesomeIcons.pills),
                  label: Text(
                    'إدارة أدوية الأمراض',
                  ),
                ),
              ],
              selectedIndex: currentIndex,
            ),
          ),
          AddVerticalSpacing(value: 20.h),
          Text(
            AccountManager.instance.user!.fullName,
            style: TextStyle(
              fontSize: 30.sp,
              color: primaryColor,
            ),
          ),
          AddVerticalSpacing(value: 20.h),
          CustomFilledButton(
            width: 250.w,
            height: 50.h,
            onTap: () => AccountManager.instance.logOut(),
            child: 'تسجيل الخروج',
          ),
          AddVerticalSpacing(value: 30.h),
        ],
      ),
    );
  }
}
