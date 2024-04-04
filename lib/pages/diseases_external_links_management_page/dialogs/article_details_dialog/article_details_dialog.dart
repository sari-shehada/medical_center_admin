import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_center_admin/config/theme/app_colors.dart';
import 'package:medical_center_admin/core/services/http_service.dart';
import 'package:medical_center_admin/core/services/snackbar_service.dart';
import 'package:medical_center_admin/core/services/url_launcher_service.dart';
import 'package:medical_center_admin/core/ui_utils/buttons/custom_filled_button.dart';
import 'package:medical_center_admin/core/ui_utils/spacing_utils.dart';
import 'package:medical_center_admin/models/external_link.dart';
import 'package:medical_center_admin/pages/medicine_management_page/medicine_management_page.dart';

class ArticleDetailsDialog extends StatelessWidget {
  const ArticleDetailsDialog({super.key, required this.link});

  final ExternalLink link;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: screenSize.width * .7,
          height: screenSize.height * .3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.cancel,
                      size: 25.sp,
                    ),
                  ),
                  AddHorizontalSpacing(value: 20.w),
                  Text(
                    link.title,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  const Spacer(),
                  CustomFilledButton(
                    width: 250.w,
                    height: 45.h,
                    backgroundColor: Colors.red,
                    onTap: () => deleteLink(),
                    child: 'حذف المقال',
                  ),
                ],
              ),
              AddVerticalSpacing(value: 20.h),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 30,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.r),
                          child: Image.network(
                            link.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      AddHorizontalSpacing(value: 30.w),
                      Expanded(
                        flex: 70,
                        child: Column(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  link.brief,
                                  maxLines: 6,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 19.sp,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            AddVerticalSpacing(value: 15.h),
                            InkWell(
                              onTap: () => UrlLauncherService.launchUrl(
                                url: link.link,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    link.link,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      color: primaryColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(Icons.link,
                                      size: 25.sp, color: primaryColor),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteLink() async {
    var futureResult = await Get.showOverlay(
      loadingWidget: const FullScreenLoader(),
      asyncFunction: () async {
        var result = await HttpService.rawFullResponsePost(
          endPoint: 'externalLinks/${link.id}/delete/',
        );
        if (result.statusCode == 200) {
          return true;
        }
        return false;
      },
    );
    if (futureResult == true) {
      Get.back(result: true);
      return;
    }
    SnackBarService.showErrorSnackbar(
      'حدث خطأ اثناء تنفيذ الاجراء',
    );
  }
}
