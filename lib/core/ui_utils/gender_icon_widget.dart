import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenderIconWidget extends StatelessWidget {
  const GenderIconWidget(
      {super.key, required this.isMale, this.size, this.color});

  final bool isMale;
  final double? size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Icon(
      isMale ? Icons.male : Icons.female,
      size: size ?? 30.sp,
      color: color,
    );
  }
}
