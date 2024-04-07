import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/theme/app_colors.dart';
import 'spacing_utils.dart';

class TitleDetailsSpacedWidget extends StatelessWidget {
  const TitleDetailsSpacedWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.details,
  });

  final IconData icon;
  final String title;
  final String details;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey.shade700,
          ),
          AddHorizontalSpacing(value: 6.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.grey.shade700,
            ),
          ),
          const Spacer(),
          Text(
            details,
            style: TextStyle(
              fontSize: 20.sp,
              color: secondary,
            ),
          ),
        ],
      ),
    );
  }
}
