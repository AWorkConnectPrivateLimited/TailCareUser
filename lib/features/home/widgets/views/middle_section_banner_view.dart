import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/features/item/controllers/campaign_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';

class MiddleSectionBannerView extends StatelessWidget {
  const MiddleSectionBannerView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isPharmacy = Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.pharmacy;

    return GetBuilder<CampaignController>(builder: (campaignController) {
      var itemCount = campaignController.basicCampaignList?.length ?? 0;
      int crossAxisCount =
          itemCount > 3 ? 3 : itemCount; // Dynamic crossAxisCount

      return campaignController.basicCampaignList != null
          ? campaignController.basicCampaignList!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: Dimensions.paddingSizeSmall,
                      crossAxisSpacing: Dimensions.paddingSizeSmall,
                      childAspectRatio: 1.7,
                    ),
                    itemCount: itemCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Get.toNamed(
                          RouteHelper.getBasicCampaignRoute(
                            campaignController.basicCampaignList![index],
                          ),
                        ),
                        child: Container(
                          // decoration: BoxDecoration(
                          //   color: Theme.of(context).cardColor,
                          //   borderRadius:
                          //       BorderRadius.circular(Dimensions.radiusSmall),
                          // ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            child: CustomImage(
                              image:
                                  '${campaignController.basicCampaignList![index].imageFullUrl}',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox()
          : MiddleSectionBannerShimmerView(
              isPharmacy: isPharmacy,
              itemCount: itemCount, // Pass itemCount to ShimmerView
            );
    });
  }
}

class MiddleSectionBannerShimmerView extends StatelessWidget {
  final bool isPharmacy;
  final int itemCount; // Add itemCount property

  const MiddleSectionBannerShimmerView(
      {super.key, required this.isPharmacy, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    int crossAxisCount =
        itemCount > 3 ? 3 : itemCount; // Dynamic crossAxisCount

    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: Dimensions.paddingSizeSmall,
            crossAxisSpacing: Dimensions.paddingSizeSmall,
            childAspectRatio: 1.7,
          ),
          itemCount: itemCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
            );
          },
        ),
      ),
    );
  }
}
