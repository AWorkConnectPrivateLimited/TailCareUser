import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';
import 'package:sixam_mart/features/banner/controllers/banner_controller.dart';
import 'package:sixam_mart/features/home/widgets/banner_view.dart';
import 'package:sixam_mart/features/home/widgets/popular_store_view.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:universal_html/html.dart' as html;

import '../../../util/styles.dart';
import '../../profile/controllers/profile_controller.dart';
import '../cached_image_widget.dart';

class ModuleView extends StatelessWidget {
  final SplashController splashController;

  const ModuleView({super.key, required this.splashController});

  @override
  Widget build(BuildContext context) {
    // Define your color array

    // Define a list of colors for each module
    final List<Color> colors = [
      const Color(0xFFffedd7),
      const Color(0xFFd6ffd2),
      const Color(0xFFf0d2d2),
      const Color(0xFFd8dbff),
      const Color(0xFFf7d9fd),
      const Color(0xFFe8e8e8),
      const Color(0xFFc3f8fd),
      const Color(0xFFffe7b6),
      // Colors.cyan,
      // Colors.amber,
    ];
    ProfileController profileController = Get.find<ProfileController>();

    BannerController bannerController = Get.find<BannerController>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // splashController.moduleList != null
      //     ? splashController.moduleList!.isNotEmpty
      //         ? GridView.builder(
      //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //               crossAxisCount: 2,
      //               mainAxisSpacing: 2,
      //               crossAxisSpacing: 0,
      //               childAspectRatio: 1,
      //             ),
      //             padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      //             itemCount: splashController.moduleList!.length,
      //             shrinkWrap: true,
      //             physics: const NeverScrollableScrollPhysics(),
      //             itemBuilder: (context, index) {
      //               return CustomInkWell(
      //                 onTap: () => splashController.switchModule(index, true),
      //                 // radius: Dimensions.radiusDefault,
      //                 child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     children: [
      //                       ClipRRect(
      //                         borderRadius:
      //                             BorderRadius.circular(Dimensions.radiusSmall),
      //                         child: CustomImage(
      //                           image:
      //                               '${splashController.moduleList![index].iconFullUrl}',
      //                           height: 113,
      //                           width: 171,
      //                         ),
      //                       ),
      //                       // const SizedBox(height: Dimensions.paddingSizeSmall),
      //                       Center(
      //                           child: Text(
      //                         splashController.moduleList![index].moduleName!,
      //                         textAlign: TextAlign.center,
      //                         maxLines: 2,
      //                         overflow: TextOverflow.ellipsis,
      //                         style: robotoMedium.copyWith(
      //                             fontSize: Dimensions.fontSizeSmall),
      //                       )),
      //                     ]),
      //               );
      //             },
      //           )
      //         : Center(
      //             child: Padding(
      //             padding:
      //                 const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      //             child: Text('no_module_found'.tr),
      //           ))
      //     : ModuleShimmer(isEnabled: splashController.moduleList == null),
      // Padding(
      //   padding: const EdgeInsets.only(bottom: 8.0),
      //   child: Image.network(
      //     "https://i.ibb.co/f2wdRxQ/fest.png",
      //     width: double.infinity,
      //     height: 200,
      //     fit: BoxFit.cover,
      //   ),
      // ),
      Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          bottom: 16.0,
          top: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          // Center content vertically
          children: [


            Text(
              'Hello, ${profileController.userInfoModel != null ? '${profileController.userInfoModel!.fName} ${profileController.userInfoModel!.lName}' : ''.tr} 👋',
              style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeOverLarge,
                  color: const Color(0xFF3d4152)),
            ),
            Text(
              "How's your pets health going on?",
              style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: const Color(0xFF3d4152)),
            ),
          ],
        ),
      ),
      splashController.moduleList != null
          ? splashController.moduleList!.isNotEmpty
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: Dimensions.paddingSizeSmall,
                    crossAxisSpacing: Dimensions.paddingSizeSmall,
                    childAspectRatio: (2 / 1),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  itemCount: splashController.moduleList!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    // Select color based on the index
                    Color backgroundColor = colors[index % colors.length];
                    return CustomInkWell(
                      onTap: () => splashController.switchModule(index, true),
                      // radius: Dimensions.radiusDefault,
                      child: Column(
                        children: [
                          GetBuilder<SplashController>(
                              builder: (splashController) {
                            return Container(
                              width: 500,
                              height: 88.5,
                              decoration: BoxDecoration(
                                // image: DecorationImage(
                                //   image: NetworkImage(
                                //       '${splashController.moduleList![index].thumbnailFullUrl}'),
                                //   fit: BoxFit
                                //       .contain, // Adjust BoxFit as needed (cover, fill, etc.)
                                // ),
                                color:
                                    backgroundColor, // Apply the selected color
                                borderRadius: BorderRadius.circular(
                                    16.0), // Add rounded corners
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          // Adjust the radius as needed
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Image.network(
                                              '${splashController.moduleList![index].iconFullUrl}',
                                              width: 60,
                                            ),
                                          ))),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            splashController
                                                .moduleList![index].moduleName!,
                                            style: robotoBold.copyWith(
                                                color: const Color(0xFF000000),
                                                fontSize: 12),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            html.DocumentFragment.html(
                                                        '<div>${splashController.moduleList![index].description!}</div>')
                                                    .querySelector('div')
                                                    ?.text ??
                                                '', // Handle potential null
                                            style: robotoMedium.copyWith(
                                                color: const Color(0xFF3d4152),
                                                fontSize: 10),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          // CachedImageWidget(
                          //   url:
                          //       '${splashController.moduleList![index].iconFullUrl}',
                          //   width: Get.width * 3 - 20,
                          //   height: 80,
                          //   fit: BoxFit.cover,
                          //   radius: defaultRadius,
                          // ),
                          // Marquee(
                          //   directionMarguee: DirectionMarguee.oneDirection,
                          //   child: Text(
                          //     splashController
                          //         .moduleList![index].moduleName!,
                          //     style: robotoMedium.copyWith(
                          //         color: const Color(0xFF3d4152),
                          //         fontSize: 12.8),
                          //     textAlign: TextAlign.center,
                          //     maxLines: 1,
                          //     overflow: TextOverflow.ellipsis,
                          //   ),
                          //
                          //   // Text(
                          //   //   splashController.moduleList![index].moduleName!,
                          //   //   style: robotoMedium.copyWith(color: const Color(0xFF3d4152), fontSize: 12.8),
                          //   //   textAlign: TextAlign.center,
                          //   //   maxLines: 1,
                          //   //   overflow: TextOverflow.ellipsis,
                          //   // ),
                          // ).paddingSymmetric(vertical: 8, horizontal: 8),
                        ],
                      ),

                      // Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      //
                      //   ClipRRect(
                      //     borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      //     child: CustomImage(
                      //       image: '${splashController.moduleList![index].iconFullUrl}',
                      //       height: 50, width: 50,
                      //     ),
                      //   ),
                      //   const SizedBox(height: Dimensions.paddingSizeSmall),
                      //
                      //   Center(child: Text(
                      //     splashController.moduleList![index].moduleName!,
                      //     textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                      //     style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      //   )),
                      //
                      // ]),
                    );
                  },
                )
              : Center(
                  child: Padding(
                  padding:
                      const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: Text('no_module_found'.tr),
                ))
          : ModuleShimmer(isEnabled: splashController.moduleList == null),

      GetBuilder<BannerController>(builder: (bannerController) {
        return const BannerView(isFeatured: true);
      }),
      // GetBuilder<AddressController>(builder: (locationController) {
      //   List<AddressModel?> addressList = [];
      //   if (AuthHelper.isLoggedIn() && locationController.addressList != null) {
      //     addressList = [];
      //     bool contain = false;
      //     if (AddressHelper.getUserAddressFromSharedPref()!.id != null) {
      //       for (int index = 0;
      //           index < locationController.addressList!.length;
      //           index++) {
      //         if (locationController.addressList![index].id ==
      //             AddressHelper.getUserAddressFromSharedPref()!.id) {
      //           contain = true;
      //           break;
      //         }
      //       }
      //     }
      //     if (!contain) {
      //       addressList.add(AddressHelper.getUserAddressFromSharedPref());
      //     }
      //     addressList.addAll(locationController.addressList!);
      //   }
      //   return (!AuthHelper.isLoggedIn() ||
      //           locationController.addressList != null)
      //       ? addressList.isNotEmpty
      //           ? Column(
      //               children: [
      //                 const SizedBox(height: Dimensions.paddingSizeLarge),
      //                 Padding(
      //                   padding: const EdgeInsets.symmetric(
      //                       horizontal: Dimensions.paddingSizeSmall),
      //                   child: TitleWidget(title: 'deliver_to'.tr),
      //                 ),
      //                 const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      //                 SizedBox(
      //                   height: 80,
      //                   child: ListView.builder(
      //                     physics: const BouncingScrollPhysics(),
      //                     itemCount: addressList.length,
      //                     scrollDirection: Axis.horizontal,
      //                     padding: const EdgeInsets.only(
      //                         left: Dimensions.paddingSizeSmall,
      //                         right: Dimensions.paddingSizeSmall,
      //                         top: Dimensions.paddingSizeExtraSmall),
      //                     itemBuilder: (context, index) {
      //                       return Container(
      //                         width: 300,
      //                         padding: const EdgeInsets.only(
      //                             right: Dimensions.paddingSizeSmall),
      //                         child: AddressWidget(
      //                           address: addressList[index],
      //                           fromAddress: false,
      //                           onTap: () {
      //                             if (AddressHelper
      //                                         .getUserAddressFromSharedPref()!
      //                                     .id !=
      //                                 addressList[index]!.id) {
      //                               Get.dialog(const CustomLoaderWidget(),
      //                                   barrierDismissible: false);
      //                               Get.find<LocationController>()
      //                                   .saveAddressAndNavigate(
      //                                 addressList[index],
      //                                 false,
      //                                 null,
      //                                 false,
      //                                 ResponsiveHelper.isDesktop(context),
      //                               );
      //                             }
      //                           },
      //                         ),
      //                       );
      //                     },
      //                   ),
      //                 ),
      //               ],
      //             )
      //           : const SizedBox()
      //       : AddressShimmer(
      //           isEnabled: AuthHelper.isLoggedIn() &&
      //               locationController.addressList == null);
      // }),
      const PopularStoreView(isPopular: false, isFeatured: true),

      CachedImageWidget(
        url: 'assets/image/BBG.png',
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),

      // const SizedBox(height: 120),
    ]);
  }
}

class ModuleShimmer extends StatelessWidget {
  final bool isEnabled;

  const ModuleShimmer({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: Dimensions.paddingSizeSmall,
        crossAxisSpacing: Dimensions.paddingSizeSmall,
        childAspectRatio: (1 / 1),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).cardColor,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)
            ],
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: isEnabled,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Colors.grey[300]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Center(
                  child: Container(
                      height: 15, width: 50, color: Colors.grey[300])),
            ]),
          ),
        );
      },
    );
  }
}

class AddressShimmer extends StatelessWidget {
  final bool isEnabled;

  const AddressShimmer({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Dimensions.paddingSizeLarge),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall),
          child: TitleWidget(title: 'deliver_to'.tr),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        SizedBox(
          height: 70,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                padding:
                    const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                child: Container(
                  padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
                      ? Dimensions.paddingSizeDefault
                      : Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 5, spreadRadius: 1)
                    ],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      Icons.location_on,
                      size: ResponsiveHelper.isDesktop(context) ? 50 : 40,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: isEnabled,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 15,
                                  width: 100,
                                  color: Colors.grey[300]),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                              Container(
                                  height: 10,
                                  width: 150,
                                  color: Colors.grey[300]),
                            ]),
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
