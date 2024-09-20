import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/home/widgets/highlight_widget.dart';
import 'package:sixam_mart/features/home/widgets/views/best_store_nearby_view.dart';
import 'package:sixam_mart/features/home/widgets/views/category_view.dart';
import 'package:sixam_mart/features/home/widgets/views/common_condition_view.dart';
import 'package:sixam_mart/features/home/widgets/views/just_for_you_view.dart';
import 'package:sixam_mart/features/home/widgets/views/new_on_mart_view.dart';
import 'package:sixam_mart/features/home/widgets/views/product_with_categories_view.dart';
import 'package:sixam_mart/features/home/widgets/views/promotional_banner_view.dart';
import 'package:sixam_mart/helper/auth_helper.dart';

import '../../../../util/dimensions.dart';
import '../../../banner/controllers/banner_controller.dart';
import '../../../item/controllers/campaign_controller.dart';
import '../../widgets/bad_weather_widget.dart';
import '../../widgets/banner_view.dart';
import '../../widgets/views/middle_section_banner_view.dart';

class PharmacyHomeScreen extends StatelessWidget {
  const PharmacyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Container(
      //   width: MediaQuery.of(context).size.width,
      //   color: //Colors.white,
      //       Theme.of(context).disabledColor.withOpacity(0.1),
      //   child: const Column(
      //     children: [
      //       const MiddleSectionBannerView(),
      //       BadWeatherWidget(),
      //       // SizedBox(height: 12),
      //     ],
      //   ),
      // ),

      GetBuilder<BannerController>(
        builder: (bannerController) {
          // Check if promotionalBanner is null
          if (bannerController.promotionalBanner == null) {
            return const PromotionalBannerShimmerView();
          }

          // Check if bottomSectionBannerFullUrl is null
          var bgurl =
              bannerController.promotionalBanner!.bottomSectionBannerFullUrl;
          if (bgurl == null) {
            return const SizedBox();
          }

          return ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
            ),
            child: Container(
              // height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(bgurl),
                  fit: BoxFit.fitWidth,
                ),
                borderRadius:
                    BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 190),

                ],
              ),
            ),
          );
        },
      ),

      GetBuilder<CampaignController>(
        builder: (campaignController) {
          if (campaignController.basicCampaignList != null && campaignController.basicCampaignList!.isNotEmpty) {
            return const Padding(
              padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: MiddleSectionBannerView(),
            );
          } else {
            return  const SizedBox(height: 10); // Return an empty widget if the list is null or empty
          }
        },
      ),


      // GetBuilder<CampaignController>(builder: (campaignController) {campaignController.basicCampaignList != null
      //     ? campaignController.basicCampaignList!.isNotEmpty
      //     ?  const MiddleSectionBannerView(),})
      const BadWeatherWidget(),
      const CategoryView(),
      const BannerView(isFeatured: false),
      // isLoggedIn ? const VisitAgainView() : const SizedBox(),
      const ProductWithCategoriesView(),
      const HighlightWidget(),

      const BestStoreNearbyView(),
      const JustForYouView(),
      const NewOnMartView(isShop: false, isPharmacy: true, isNewStore: true),
      const CommonConditionView(),
      // const PromotionalBannerView(),
    ]);
  }
}
