import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LinearLoadingIndicatorWidget extends StatelessWidget {
  const LinearLoadingIndicatorWidget({
    super.key,
    this.color,
    this.size,
  });

  final Color? color;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.waveDots(
      color: color ?? Theme.of(context).colorScheme.primary,
      size: size ?? 55.sp,
    );
  }
}
