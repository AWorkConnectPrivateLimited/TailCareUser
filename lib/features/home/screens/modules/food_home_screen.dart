import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/controllers/theme_controller.dart';
import 'package:sixam_mart/features/home/widgets/highlight_widget.dart';
import 'package:sixam_mart/features/home/widgets/views/category_view.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/features/home/widgets/bad_weather_widget.dart';
import 'package:sixam_mart/features/home/widgets/views/best_reviewed_item_view.dart';
import 'package:sixam_mart/features/home/widgets/views/best_store_nearby_view.dart';
import 'package:sixam_mart/features/home/widgets/views/item_that_you_love_view.dart';
import 'package:sixam_mart/features/home/widgets/views/just_for_you_view.dart';
import 'package:sixam_mart/features/home/widgets/views/most_popular_item_view.dart';
import 'package:sixam_mart/features/home/widgets/views/new_on_mart_view.dart';
import 'package:sixam_mart/features/home/widgets/views/special_offer_view.dart';
import 'package:sixam_mart/features/home/widgets/views/visit_again_view.dart';
import 'package:sixam_mart/features/home/widgets/banner_view.dart';

import '../../../../util/dimensions.dart';
import '../../../banner/controllers/banner_controller.dart';
import '../../widgets/views/promotional_banner_view.dart';

class FoodHomeScreen extends StatelessWidget {
  const FoodHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    return  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //
      // Container(
      //   width: MediaQuery.of(context).size.width,
      //   decoration: Get.find<ThemeController>().darkTheme ? null : const BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage(Images.foodModuleBannerBg),
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      //   child: const Column(
      //     children: [
      //       BadWeatherWidget(),
      //
      //
      //       SizedBox(height: 12),
      //     ],
      //   ),
      // ),

      // GetBuilder<BannerController>(
      //   builder: (bannerController) {
      //     // Check if promotionalBanner is null
      //     if (bannerController.promotionalBanner == null) {
      //       return const PromotionalBannerShimmerView();
      //     }
      //
      //     // Check if bottomSectionBannerFullUrl is null
      //     var sbgurl =
      //         bannerController.promotionalBanner!.basicSectionNearbyFullUrl;
      //     if (sbgurl == null) {
      //       return const SizedBox();
      //     }
      //
      //     return ClipRRect(
      //       borderRadius: const BorderRadius.only(
      //         bottomLeft: Radius.circular(16.0),
      //         bottomRight: Radius.circular(16.0),
      //       ),
      //       child: Container(
      //         // height: 350,
      //         width: double.infinity,
      //         decoration: BoxDecoration(
      //           color: Theme.of(context).cardColor,
      //           image: DecorationImage(
      //             image: CachedNetworkImageProvider(sbgurl),
      //             fit: BoxFit.fitWidth,
      //           ),
      //           borderRadius:
      //           BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
      //         ),
      //         child: const Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             SizedBox(height: 190),
      //
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),


      BannerView(isFeatured: false),

      BadWeatherWidget(),
      CategoryView(),

      // isLoggedIn ? const VisitAgainView(fromFood: true) : const SizedBox(),
      SpecialOfferView(isFood: true, isShop: false),
      HighlightWidget(),
      BestReviewItemView(),
      BestStoreNearbyView(),
      ItemThatYouLoveView(forShop: false),
      MostPopularItemView(isFood: true, isShop: false),
      JustForYouView(),
      NewOnMartView(isNewStore: true, isPharmacy: false, isShop: false),
    ]);
  }
}
