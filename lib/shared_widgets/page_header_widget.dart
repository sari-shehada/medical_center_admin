import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../config/theme/app_colors.dart';
import '../core/ui_utils/spacing_utils.dart';

class PageHeaderWidget extends StatelessWidget {
  const PageHeaderWidget({
    super.key,
    required this.iconData,
    required this.title,
    required this.subTitle,
    this.actions = const <Widget>[],
  });

  final IconData iconData;
  final String title;
  final String subTitle;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      child: Row(
        children: [
          FaIcon(
            iconData,
            color: primaryColor,
            size: 50.sp,
          ),
          AddHorizontalSpacing(value: 25.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 30.sp,
                  color: primaryColor,
                ),
              ),
              AddVerticalSpacing(value: 6.h),
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: 22.sp,
                ),
              ),
            ],
          ),
          const Spacer(),
          ...actions
        ],
      ),
    );
  }
}
