import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/features/category/controllers/category_controller.dart';
import 'package:sixam_mart/features/home/widgets/category_pop_up.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../cached_image_widget.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return GetBuilder<SplashController>(builder: (splashController) {
      bool isPharmacy = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.pharmacy;
      bool isFood = splashController.module != null &&
          splashController.module!.moduleType.toString() == AppConstants.food;
      bool isGrocery = splashController.module != null &&
          splashController.module!.moduleType.toString() == AppConstants.grocery;

      return GetBuilder<CategoryController>(builder: (categoryController) {
        return (categoryController.categoryList != null &&
                categoryController.categoryList!.isEmpty)
            ? const SizedBox()
            : isPharmacy
                ? PharmacyCategoryView(categoryController: categoryController)
                : isFood
                    ? PharmacyCategoryView(categoryController: categoryController)
                    : isGrocery
            ?GPharmacyCategoryView(categoryController: categoryController)
                   :PharmacyCategoryView(categoryController: categoryController);
      });
    });
  }
}

class PharmacyCategoryView extends StatelessWidget {
  final CategoryController categoryController;

  const PharmacyCategoryView({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        LayoutBuilder(
        builder: (context, constraints) {
      final itemCount = categoryController.categoryList?.length ?? 0;
      final rows = (itemCount / 3).ceil(); // Assuming 3 items per row
      final gridHeight = rows * 150.0; // Adjust the item height as needed

      return SizedBox(
        height: gridHeight,
        child: categoryController.categoryList != null
            ? GridView.builder(
                // controller: scrollController,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of columns in the grid
                    mainAxisSpacing: Dimensions.paddingSizeSmall,
                    crossAxisSpacing: Dimensions.paddingSizeSmall,
                    childAspectRatio: (1 /
                        1.2) // Adjust the aspect ratio of grid items as needed
                    ),
                padding: const EdgeInsets.all(8.0),

                itemCount: categoryController.categoryList!.length,
                // No need to limit items for grid
                itemBuilder: (context, index) {
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
                  Color backgroundColor = colors[index % colors.length];
                  return Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: InkWell(
                      onTap: () {
                        if (index == 9 &&
                            categoryController.categoryList!.length > 1) {
                          Get.toNamed(RouteHelper.getCategoryRoute());
                        } else {
                          Get.toNamed(RouteHelper.getCategoryItemRoute(
                            categoryController.categoryList![index].id,
                            categoryController.categoryList![index].name!,
                          ));
                        }
                      },
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      child: Container(
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: backgroundColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft:Radius.circular(20),
                                      bottomRight:Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),

                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child:
                                        // CustomImage(
                                        //   image:
                                        //       '${categoryController.categoryList![index].imageFullUrl}',
                                        //   height: 70,
                                        //   width: double.infinity,
                                        //   fit: BoxFit.cover,
                                        // ),

                                        // Image.network(
                                        //   image:${categoryController.categoryList![index].imageFullUrl}',
                                        //   height: 70,
                                        //   width: double.infinity,
                                        //   fit: BoxFit.cover,
                                        // ),

                                        CachedImageWidget(
                                      url:
                                          '${categoryController.categoryList![index].imageFullUrl}',
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // (index == 9 &&
                                //         categoryController
                                //                 .categoryList!.length >
                                //             10)
                                //     ? Positioned(
                                //         right: 0,
                                //         left: 0,
                                //         top: 0,
                                //         bottom: 0,
                                //         child: Container(
                                //             decoration: BoxDecoration(
                                //               borderRadius:
                                //                   const BorderRadius.only(
                                //                       topLeft:
                                //                           Radius.circular(100),
                                //                       topRight:
                                //                           Radius.circular(100)),
                                //               gradient: LinearGradient(
                                //                 begin: Alignment.topCenter,
                                //                 end: Alignment.bottomCenter,
                                //                 colors: [
                                //                   Theme.of(context)
                                //                       .primaryColor
                                //                       .withOpacity(0.4),
                                //                   Theme.of(context)
                                //                       .primaryColor
                                //                       .withOpacity(0.6),
                                //                   Theme.of(context)
                                //                       .primaryColor
                                //                       .withOpacity(0.4),
                                //                 ],
                                //               ),
                                //             ),
                                //             child: Center(
                                //               child: Text(
                                //                 '+${categoryController.categoryList!.length - 10}',
                                //                 style: robotoMedium.copyWith(
                                //                     fontSize: Dimensions
                                //                         .fontSizeExtraLarge,
                                //                     color: Theme.of(context)
                                //                         .cardColor),
                                //                 maxLines: 2,
                                //                 overflow: TextOverflow.ellipsis,
                                //                 textAlign: TextAlign.center,
                                //               ),
                                //             )),
                                //       )
                                //     : const SizedBox(),
                              ],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Expanded(
                                child: Text(
                              // (index == 9 &&
                              //         categoryController.categoryList!.length > 10)
                              //     ? 'see_all'.tr
                              //     :
                              categoryController.categoryList![index].name!,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color:
                                      // (index == 9 &&
                                      //         categoryController
                                      //                 .categoryList!.length >
                                      //             10)
                                      //     ? Theme.of(context).primaryColor
                                      //     :
                                      Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            )),
                          ]),
                        ),
                      ),
                    ),
                  );
                },
              )
            : PharmacyCategoryShimmer(categoryController: categoryController),
      );}),
    ]);
  }
}

class GPharmacyCategoryView extends StatelessWidget {
  final CategoryController categoryController;

  const GPharmacyCategoryView({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LayoutBuilder(
          builder: (context, constraints) {
            final itemCount = categoryController.categoryList?.length ?? 0;
            final rows = (itemCount / 3).ceil(); // Assuming 3 items per row
            final gridHeight = rows * 150.0; // Adjust the item height as needed

            return SizedBox(
              height: gridHeight,
              child: categoryController.categoryList != null
                  ? GridView.builder(
                // controller: scrollController,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of columns in the grid
                    mainAxisSpacing: Dimensions.paddingSizeSmall,
                    crossAxisSpacing: Dimensions.paddingSizeSmall,
                    childAspectRatio: (1 /
                        1.2) // Adjust the aspect ratio of grid items as needed
                ),
                padding: const EdgeInsets.all(8.0),

                itemCount: categoryController.categoryList!.length,
                // No need to limit items for grid
                itemBuilder: (context, index) {
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
                  Color backgroundColor = colors[index % colors.length];
                  return Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: InkWell(
                      onTap: () {
                        if (index == 9 &&
                            categoryController.categoryList!.length > 1) {
                          Get.toNamed(RouteHelper.getCategoryRoute());
                        } else {
                          Get.toNamed(RouteHelper.getCategoryItemRoute(
                            categoryController.categoryList![index].id,
                            categoryController.categoryList![index].name!,
                          ));
                        }
                      },
                      borderRadius:
                      BorderRadius.circular(Dimensions.radiusSmall),
                      child:  Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft:Radius.circular(20),
                                      bottomRight:Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),

                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child:
                                    // CustomImage(
                                    //   image:
                                    //       '${categoryController.categoryList![index].imageFullUrl}',
                                    //   height: 70,
                                    //   width: double.infinity,
                                    //   fit: BoxFit.cover,
                                    // ),

                                    // Image.network(
                                    //   image:${categoryController.categoryList![index].imageFullUrl}',
                                    //   height: 70,
                                    //   width: double.infinity,
                                    //   fit: BoxFit.cover,
                                    // ),

                                    CachedImageWidget(
                                      url:
                                      '${categoryController.categoryList![index].imageFullUrl}',
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // (index == 9 &&
                                //         categoryController
                                //                 .categoryList!.length >
                                //             10)
                                //     ? Positioned(
                                //         right: 0,
                                //         left: 0,
                                //         top: 0,
                                //         bottom: 0,
                                //         child: Container(
                                //             decoration: BoxDecoration(
                                //               borderRadius:
                                //                   const BorderRadius.only(
                                //                       topLeft:
                                //                           Radius.circular(100),
                                //                       topRight:
                                //                           Radius.circular(100)),
                                //               gradient: LinearGradient(
                                //                 begin: Alignment.topCenter,
                                //                 end: Alignment.bottomCenter,
                                //                 colors: [
                                //                   Theme.of(context)
                                //                       .primaryColor
                                //                       .withOpacity(0.4),
                                //                   Theme.of(context)
                                //                       .primaryColor
                                //                       .withOpacity(0.6),
                                //                   Theme.of(context)
                                //                       .primaryColor
                                //                       .withOpacity(0.4),
                                //                 ],
                                //               ),
                                //             ),
                                //             child: Center(
                                //               child: Text(
                                //                 '+${categoryController.categoryList!.length - 10}',
                                //                 style: robotoMedium.copyWith(
                                //                     fontSize: Dimensions
                                //                         .fontSizeExtraLarge,
                                //                     color: Theme.of(context)
                                //                         .cardColor),
                                //                 maxLines: 2,
                                //                 overflow: TextOverflow.ellipsis,
                                //                 textAlign: TextAlign.center,
                                //               ),
                                //             )),
                                //       )
                                //     : const SizedBox(),
                              ],
                            ),
                            // const SizedBox(height: Dimensions.paddingSizeSmall),
                            // Expanded(
                            //     child: Text(
                            //       // (index == 9 &&
                            //       //         categoryController.categoryList!.length > 10)
                            //       //     ? 'see_all'.tr
                            //       //     :
                            //       categoryController.categoryList![index].name!,
                            //       style: robotoMedium.copyWith(
                            //           fontSize: Dimensions.fontSizeSmall,
                            //           color:
                            //           // (index == 9 &&
                            //           //         categoryController
                            //           //                 .categoryList!.length >
                            //           //             10)
                            //           //     ? Theme.of(context).primaryColor
                            //           //     :
                            //           Theme.of(context)
                            //               .textTheme
                            //               .bodyMedium!
                            //               .color),
                            //       maxLines: 2,
                            //       overflow: TextOverflow.ellipsis,
                            //       textAlign: TextAlign.center,
                            //     )),
                          ]),
                        ),

                    ),
                  );
                },
              )
                  : PharmacyCategoryShimmer(categoryController: categoryController),
            );}),
    ]);
  }
}

// class PharmacyCategoryView extends StatelessWidget {
//   final CategoryController categoryController;
//
//   const PharmacyCategoryView({super.key, required this.categoryController});
//
//   @override
//   Widget build(BuildContext context) {
//     final ScrollController scrollController = ScrollController();
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       categoryController.categoryList != null
//           ? GridView.builder(
//               controller: scrollController,
//               physics: const BouncingScrollPhysics(),
//               shrinkWrap: true,
//               scrollDirection: Axis.vertical,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3, // Number of columns in the grid
//                   mainAxisSpacing: Dimensions.paddingSizeSmall,
//                   crossAxisSpacing: Dimensions.paddingSizeSmall,
//                   childAspectRatio: (1 /
//                       1.5) // Adjust the aspect ratio of grid items as needed
//                   ),
//               padding: const EdgeInsets.only(
//                   left: Dimensions.paddingSizeDefault,
//                   top: Dimensions.paddingSizeDefault),
//               itemCount: categoryController.categoryList!.length,
//               // No need to limit items for grid
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.only(
//                       bottom: Dimensions.paddingSizeDefault,
//                       right: Dimensions.paddingSizeSmall,
//                       top: Dimensions.paddingSizeDefault),
//                   child: InkWell(
//                     onTap: () {
//                       if (index == 9 &&
//                           categoryController.categoryList!.length > 1) {
//                         Get.toNamed(RouteHelper.getCategoryRoute());
//                       } else {
//                         Get.toNamed(RouteHelper.getCategoryItemRoute(
//                           categoryController.categoryList![index].id,
//                           categoryController.categoryList![index].name!,
//                         ));
//                       }
//                     },
//                     borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//                     child: Container(
//                       width: 70,
//                       decoration: const BoxDecoration(
//                         borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Color(0xFFffedd7),
//                             Color(0xFFffedd7),
//                           ],
//                         ),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(children: [
//                           Stack(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(5),
//                                     topRight: Radius.circular(15)),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(1.0),
//                                   child: CustomImage(
//                                     image:
//                                         '${categoryController.categoryList![index].imageFullUrl}',
//                                     height: 80,
//                                     width: double.infinity,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               (index == 9 &&
//                                       categoryController.categoryList!.length >
//                                           10)
//                                   ? Positioned(
//                                       right: 0,
//                                       left: 0,
//                                       top: 0,
//                                       bottom: 0,
//                                       child: Container(
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 const BorderRadius.only(
//                                                     topLeft:
//                                                         Radius.circular(100),
//                                                     topRight:
//                                                         Radius.circular(100)),
//                                             gradient: LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 Theme.of(context)
//                                                     .primaryColor
//                                                     .withOpacity(0.4),
//                                                 Theme.of(context)
//                                                     .primaryColor
//                                                     .withOpacity(0.6),
//                                                 Theme.of(context)
//                                                     .primaryColor
//                                                     .withOpacity(0.4),
//                                               ],
//                                             ),
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               '+${categoryController.categoryList!.length - 10}',
//                                               style: robotoMedium.copyWith(
//                                                   fontSize: Dimensions
//                                                       .fontSizeExtraLarge,
//                                                   color: Theme.of(context)
//                                                       .cardColor),
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           )),
//                                     )
//                                   : const SizedBox(),
//                             ],
//                           ),
//                           const SizedBox(height: Dimensions.paddingSizeSmall),
//                           Expanded(
//                               child: Text(
//                             // (index == 9 &&
//                             //         categoryController.categoryList!.length > 10)
//                             //     ? 'see_all'.tr
//                             //     :
//                             categoryController.categoryList![index].name!,
//                             style: robotoMedium.copyWith(
//                                 fontSize: Dimensions.fontSizeSmall,
//                                 color: (index == 9 &&
//                                         categoryController
//                                                 .categoryList!.length >
//                                             10)
//                                     ? Theme.of(context).primaryColor
//                                     : Theme.of(context)
//                                         .textTheme
//                                         .bodyMedium!
//                                         .color),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             textAlign: TextAlign.center,
//                           )),
//                         ]),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             )
//           : PharmacyCategoryShimmer(categoryController: categoryController),
//     ]);
//   }
// }

class FoodCategoryView extends StatelessWidget {
  final CategoryController categoryController;

  const FoodCategoryView({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 160,
          child: categoryController.categoryList != null
              ? ListView.builder(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeDefault,
                      top: Dimensions.paddingSizeDefault),
                  itemCount: categoryController.categoryList!.length > 10
                      ? 10
                      : categoryController.categoryList!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: Dimensions.paddingSizeDefault,
                          right: Dimensions.paddingSizeDefault,
                          top: Dimensions.paddingSizeDefault),
                      child: InkWell(
                        onTap: () {
                          if (index == 9 &&
                              categoryController.categoryList!.length > 10) {
                            Get.toNamed(RouteHelper.getCategoryRoute());
                          } else {
                            Get.toNamed(RouteHelper.getCategoryItemRoute(
                              categoryController.categoryList![index].id,
                              categoryController.categoryList![index].name!,
                            ));
                          }
                        },
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        child: SizedBox(
                          width: 60,
                          child: Column(children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  child: CustomImage(
                                    image:
                                        '${categoryController.categoryList![index].imageFullUrl}',
                                    height: 60,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                (index == 9 &&
                                        categoryController
                                                .categoryList!.length >
                                            10)
                                    ? Positioned(
                                        right: 0,
                                        left: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(100)),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.4),
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.6),
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.4),
                                                ],
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '+${categoryController.categoryList!.length - 10}',
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraLarge,
                                                    color: Theme.of(context)
                                                        .cardColor),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Expanded(
                                child: Text(
                              (index == 9 &&
                                      categoryController.categoryList!.length >
                                          10)
                                  ? 'see_all'.tr
                                  : categoryController
                                          .categoryList![index].name ??
                                      '',
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: (index == 9 &&
                                          categoryController
                                                  .categoryList!.length >
                                              10)
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            )),
                          ]),
                        ),
                      ),
                    );
                  },
                )
              : FoodCategoryShimmer(categoryController: categoryController),
        ),
      ]),
    ]);
  }
}

class CategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;

  const CategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      padding: const EdgeInsets.only(
          left: Dimensions.paddingSizeSmall,
          top: Dimensions.paddingSizeDefault),
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 1, vertical: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: SizedBox(
              width: 80,
              child: Column(children: [
                Container(
                    height: 75,
                    width: 75,
                    margin: EdgeInsets.only(
                      left: index == 0 ? 0 : Dimensions.paddingSizeExtraSmall,
                      right: Dimensions.paddingSizeExtraSmall,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      color: Colors.grey[300],
                    )),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Padding(
                  padding: EdgeInsets.only(
                      right: index == 0 ? Dimensions.paddingSizeExtraSmall : 0),
                  child: Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey[300],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class FoodCategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;

  const FoodCategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
              bottom: Dimensions.paddingSizeDefault,
              left: Dimensions.paddingSizeDefault,
              top: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: SizedBox(
              width: 60,
              child: Column(children: [
                Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      color: Colors.grey[300],
                    )),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey[300],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class PharmacyCategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;

  const PharmacyCategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
              bottom: Dimensions.paddingSizeDefault,
              left: Dimensions.paddingSizeDefault,
              top: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: Container(
              width: 70,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100)),
              ),
              child: Column(children: [
                Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(100)),
                      color: Colors.grey[300],
                    )),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey[300],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
