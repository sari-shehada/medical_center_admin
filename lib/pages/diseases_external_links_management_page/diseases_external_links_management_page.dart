import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../shared_widgets/page_header_widget.dart';
import '../../config/theme/app_colors.dart';
import '../../core/services/http_service.dart';
import '../../core/services/snackbar_service.dart';
import '../../core/ui_utils/buttons/custom_filled_button.dart';
import '../../core/ui_utils/custom_divider.dart';
import '../../core/ui_utils/spacing_utils.dart';
import '../../core/widgets/custom_future_builder.dart';
import '../../managers/diseases_repository.dart';
import '../../models/disease.dart';
import '../../models/external_link.dart';
import 'dialogs/add_article_to_disease_dialog/add_article_to_disease_dialog.dart';
import 'dialogs/article_details_dialog/article_details_dialog.dart';

class DiseasesExternalLinksManagementPage extends StatefulWidget {
  const DiseasesExternalLinksManagementPage({super.key});

  @override
  State<DiseasesExternalLinksManagementPage> createState() =>
      _DiseasesExternalLinksManagementPageState();
}

class _DiseasesExternalLinksManagementPageState
    extends State<DiseasesExternalLinksManagementPage> {
  Disease? selectedDisease;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeaderWidget(
          iconData: FontAwesomeIcons.bookMedical,
          title: 'إدارة مقالات الأمراض',
          subTitle:
              'قم بعرض المقالات المتعلقة بكل مرض في النظام وإضافة مقالات جديدة',
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 35,
                child: CustomFutureBuilder(
                  future: DiseasesRepository.diseases,
                  builder: (context, diseases) => ListView.separated(
                    itemCount: diseases.length,
                    itemBuilder: (context, index) {
                      Disease disease = diseases[index];
                      return ListTile(
                        leading: Text(
                          (disease.id).toString(),
                          style: TextStyle(
                            fontSize: 25.sp,
                          ),
                        ),
                        selected: disease == selectedDisease,
                        onTap: () => selectDisease(disease),
                        title: Text(disease.name),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: Colors.grey.shade400,
                      endIndent: 10.w,
                      indent: 20.w,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 65,
                child: SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: selectedDisease == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.find_replace,
                                size: 200.sp,
                              ),
                              AddVerticalSpacing(value: 50.h),
                              Text(
                                'قم باختيار أحد الأمراض لعرض التفاصيل',
                                style: TextStyle(
                                  fontSize: 25.sp,
                                ),
                              ),
                              AddVerticalSpacing(value: 100.h),
                            ],
                          ),
                        )
                      : DiseaseExternalLinksWindow(
                          key: Key(
                            selectedDisease!.id.toString(),
                          ),
                          disease: selectedDisease!,
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void selectDisease(Disease disease) {
    setState(() {
      if (selectedDisease == disease) {
        selectedDisease = null;
      } else {
        selectedDisease = disease;
      }
    });
  }
}

class DiseaseExternalLinksWindow extends StatefulWidget {
  const DiseaseExternalLinksWindow({super.key, required this.disease});

  final Disease disease;

  @override
  State<DiseaseExternalLinksWindow> createState() =>
      _DiseaseExternalLinksWindowState();
}

class _DiseaseExternalLinksWindowState
    extends State<DiseaseExternalLinksWindow> {
  late Future<List<ExternalLink>> externalLinksFuture;

  @override
  void initState() {
    externalLinksFuture = getExternalLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.disease.name,
                style: TextStyle(
                  fontSize: 28.sp,
                  color: primaryColor,
                ),
              ),
              const Spacer(),
              CustomFilledButton(
                width: 300.w,
                height: 50.h,
                onTap: updateList,
                child: 'تحديث القائمة',
              ),
            ],
          ),
          AddVerticalSpacing(value: 20.h),
          Expanded(
            child: CustomFutureBuilder(
              future: externalLinksFuture,
              builder: (context, externalLinks) {
                if (externalLinks.isEmpty) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article,
                          size: 200.sp,
                        ),
                        AddVerticalSpacing(value: 20.h),
                        Text(
                          'لم يتم العثور على مقالات لهذا المرض',
                          style: TextStyle(
                            fontSize: 22.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: externalLinks.length,
                  itemBuilder: (context, index) {
                    ExternalLink link = externalLinks[index];
                    return ListTile(
                      onTap: () => deleteArticle(link),
                      minLeadingWidth: 70.w,
                      leading: Image.network(link.imageUrl),
                      title: Text(link.title),
                      subtitle: Text(link.brief),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const CustomDivider();
                  },
                );
              },
            ),
          ),
          CustomFilledButton(
            onTap: addArticle,
            child: 'إضافة مقال جديد',
          ),
          AddVerticalSpacing(value: 20.h),
        ],
      ),
    );
  }

  Future<void> deleteArticle(ExternalLink link) async {
    if (await Get.dialog(
          ArticleDetailsDialog(
            link: link,
          ),
        ) ==
        true) {
      updateList();
    }
  }

  Future<List<ExternalLink>> getExternalLinks() async {
    return await HttpService.parsedMultiGet(
      endPoint: 'disease/${widget.disease.id}/externalLinks/',
      mapper: ExternalLink.fromMap,
    );
  }

  Future<void> addArticle() async {
    var result = await Get.dialog(
      AddArticleToDiseaseDialog(
        diseaseId: widget.disease.id,
      ),
    );
    if (result == true) {
      SnackBarService.showSuccessSnackbar(
        'تم إضافة مقال جديد',
      );
      updateList();
    }
  }

  void updateList() {
    externalLinksFuture = getExternalLinks();
    setState(() {});
  }
}
