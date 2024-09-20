import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sixam_mart/features/home/widgets/brands_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/highlight_widget.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/features/flash_sale/widgets/flash_sale_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/bad_weather_widget.dart';
import 'package:sixam_mart/features/home/widgets/views/product_with_categories_view.dart';
import 'package:sixam_mart/features/home/widgets/views/featured_categories_view.dart';
import 'package:sixam_mart/features/home/widgets/views/popular_store_view.dart';
import 'package:sixam_mart/features/home/widgets/views/item_that_you_love_view.dart';
import 'package:sixam_mart/features/home/widgets/views/just_for_you_view.dart';
import 'package:sixam_mart/features/home/widgets/views/most_popular_item_view.dart';
import 'package:sixam_mart/features/home/widgets/views/new_on_mart_view.dart';
import 'package:sixam_mart/features/home/widgets/views/middle_section_banner_view.dart';
import 'package:sixam_mart/features/home/widgets/views/special_offer_view.dart';
import 'package:sixam_mart/features/home/widgets/views/promotional_banner_view.dart';
import 'package:sixam_mart/features/home/widgets/views/visit_again_view.dart';
import 'package:sixam_mart/features/home/widgets/banner_view.dart';
import 'package:sixam_mart/features/home/widgets/views/category_view.dart';

import '../../../../util/dimensions.dart';
import '../../../banner/controllers/banner_controller.dart';

class ShopHomeScreen extends StatelessWidget {
  const ShopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      GetBuilder<BannerController>(
        builder: (bannerController) {
          // Check if promotionalBanner is null
          if (bannerController.promotionalBanner == null) {
            return const PromotionalBannerShimmerView();
          }

          // Check if bottomSectionBannerFullUrl is null
          var sbgurl =
              bannerController.promotionalBanner!.bottomSectionBannerFullUrl;
          if (sbgurl == null) {
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
                  image: CachedNetworkImageProvider(sbgurl),
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

      Container(
        width: MediaQuery.of(context).size.width,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(Images.shopModuleBannerBg),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: const Column(
          children: [


            BadWeatherWidget(),


            // SizedBox(height: 12),
          ],
        ),
      ),
      const CategoryView(),

      BannerView(isFeatured: false),

      // isLoggedIn ? const VisitAgainView() : const SizedBox(),
      const MostPopularItemView(isFood: false, isShop: true),
      const FlashSaleViewWidget(),
      const MiddleSectionBannerView(),
      const HighlightWidget(),
      const PopularStoreView(),
      const BrandsViewWidget(),
      const SpecialOfferView(isFood: false, isShop: true),
      const ProductWithCategoriesView(fromShop: true),
      const JustForYouView(),
      const FeaturedCategoriesView(),
      // const StoreWiseBannerView(),
      const ItemThatYouLoveView(forShop: true,),
      const NewOnMartView(isShop: true,isPharmacy: false),
      // const PromotionalBannerView(),
    ]);
  }
}
