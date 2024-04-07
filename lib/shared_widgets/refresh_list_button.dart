import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/ui_utils/buttons/custom_filled_button.dart';

class RefreshListButton extends StatelessWidget {
  const RefreshListButton({super.key, required this.refreshCallback});

  final VoidCallback refreshCallback;
  @override
  Widget build(BuildContext context) {
    return CustomFilledButton(
      width: 240.w,
      onTap: () => refreshCallback(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'تحديث القائمة',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
