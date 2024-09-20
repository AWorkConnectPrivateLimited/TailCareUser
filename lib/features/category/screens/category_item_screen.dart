import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/cart_widget.dart';
import 'package:sixam_mart/common/widgets/item_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/veg_filter_widget.dart';
import 'package:sixam_mart/common/widgets/web_menu_bar.dart';
import 'package:sixam_mart/features/category/controllers/category_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../../util/images.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/cached_image_widget.dart';
import '../../store/widgets/bottom_cart_widget.dart';

class CategoryItemScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;

  const CategoryItemScreen(
      {super.key, required this.categoryID, required this.categoryName});

  @override
  CategoryItemScreenState createState() => CategoryItemScreenState();
}

class CategoryItemScreenState extends State<CategoryItemScreen>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController storeScrollController = ScrollController();
  TabController? _tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryItemList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryItemList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList![
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
    storeScrollController.addListener(() {
      if (storeScrollController.position.pixels ==
              storeScrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryStoreList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize =
            (Get.find<CategoryController>().restPageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryStoreList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList![
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (catController) {
      List<Item>? item;
      List<Store>? stores;
      if (catController.isSearching
          ? catController.searchItemList != null
          : catController.categoryItemList != null) {
        item = [];
        if (catController.isSearching) {
          item.addAll(catController.searchItemList!);
        } else {
          item.addAll(catController.categoryItemList!);
        }
      }
      if (catController.isSearching
          ? catController.searchStoreList != null
          : catController.categoryStoreList != null) {
        stores = [];
        if (catController.isSearching) {
          stores.addAll(catController.searchStoreList!);
        } else {
          stores.addAll(catController.categoryStoreList!);
        }
      }

      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) async {
          if (catController.isSearching) {
            catController.toggleSearch();
          } else {
            return;
          }
        },
        child: Scaffold(
          appBar: (ResponsiveHelper.isDesktop(context)
              ? const WebMenuBar()
              : AppBar(
                  title: catController.isSearching
                      ? TextField(
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge),
                          onSubmitted: (String query) {
                            catController.searchData(
                              query,
                              catController.subCategoryIndex == 0
                                  ? widget.categoryID
                                  : catController
                                      .subCategoryList![
                                          catController.subCategoryIndex]
                                      .id
                                      .toString(),
                              catController.type,
                            );
                          })
                      : Row(
                          children: [
                            Text(widget.categoryName,
                                style: robotoRegular.copyWith(
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                )),
                          ],
                        ),
                  centerTitle: false,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    onPressed: () {
                      if (catController.isSearching) {
                        catController.toggleSearch();
                      } else {
                        Get.back();
                      }
                    },
                  ),
                  backgroundColor: Theme.of(context).cardColor,
                  elevation: 0,
                  actions: [
                    IconButton(
                      onPressed: () => catController.toggleSearch(),
                      icon: Icon(
                        catController.isSearching
                            ? Icons.close_sharp
                            : Icons.search,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),


                    Stack(
                        clipBehavior: Clip.none,
                        children: [

                          InkWell( // Wrap the Image in InkWell for tap functionality
                            onTap: () => Get.toNamed(RouteHelper.getCartRoute()),
                            child: Image.asset(
                              color: Colors.black,
                              Images.shoppingCart,
                              height:20, // Provide a size for the image
                              width: 20,
                            ),
                          ),

                          GetBuilder<CartController>(builder: (cartController) {
                            if (cartController.cartList.isEmpty) {
                              return const SizedBox.shrink(); // Use SizedBox.shrink() for empty case
                            }
                            return Positioned(
                              top: -15, // Adjust position as needed
                              right: -5,
                              child: Badge( // Use a Badge widget for better appearance
                                label: Text(
                                  cartController.cartList.length.toString(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                ),
                                backgroundColor: const Color(0xFFf0f2f5),
                                // borderColor: Theme.of(context).primaryColor,
                                // borderWidth: 2.dp,
                              ),
                            );
                          }),
                        ]
                    ),

                        // const CartWidget(
                        //     color: Colors.black,
                        //     size: 20),
                        // IconButton(
                        //   onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                        //   icon: Icon(
                        //     Icons.shopping_cart,
                        //     color: Theme.of(context).textTheme.bodyLarge!.color,
                        //   ),
                        // ),

                    IconButton(
                      onPressed: () =>
                          Get.toNamed(RouteHelper.getMembershipRoute()),
                      icon: Image.asset(
                        'assets/image/care.png',
                        height: 30,
                        width: 30,
                      ),
                    ),
                    VegFilterWidget(
                        type: catController.type,
                        fromAppBar: true,
                        onSelected: (String type) {
                          if (catController.isSearching) {
                            catController.searchData(
                              catController.subCategoryIndex == 0
                                  ? widget.categoryID
                                  : catController
                                      .subCategoryList![
                                          catController.subCategoryIndex]
                                      .id
                                      .toString(),
                              '1',
                              type,
                            );
                          } else {
                            if (catController.isStore) {
                              catController.getCategoryStoreList(
                                catController.subCategoryIndex == 0
                                    ? widget.categoryID
                                    : catController
                                        .subCategoryList![
                                            catController.subCategoryIndex]
                                        .id
                                        .toString(),
                                1,
                                type,
                                true,
                              );
                            } else {
                              catController.getCategoryItemList(
                                catController.subCategoryIndex == 0
                                    ? widget.categoryID
                                    : catController
                                        .subCategoryList![
                                            catController.subCategoryIndex]
                                        .id
                                        .toString(),
                                1,
                                type,
                                true,
                              );
                            }
                          }
                        }),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                  ],
                )),
          endDrawer: const MenuDrawer(),
          endDrawerEnableOpenDragGesture: false,
          body: Center(
              child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Row(
              children: [
                if (catController.subCategoryList != null &&
                    !catController.isSearching)
                  Flexible(
                    child: Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 1,
                        width: Dimensions.webMaxWidth,
                        color: Theme.of(context).cardColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeExtraSmall),
                        child: ListView.builder(
                          key: scaffoldKey,
                          scrollDirection: Axis.vertical,
                          itemCount: catController.subCategoryList!.length,
                          padding: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => catController.setSubCategoryIndex(
                                  index, widget.categoryID),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall,
                                    vertical: Dimensions.paddingSizeExtraSmall),
                                margin: const EdgeInsets.only(
                                    right: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  color: index == catController.subCategoryIndex
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1)
                                      : Colors.transparent,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (catController.subCategoryList![index]
                                            .imageFullUrl?.isNotEmpty ??
                                        false)
                                      CachedImageWidget(
                                        url: catController
                                            .subCategoryList![index].imageFullUrl!,
                                        width: 55,
                                        // Consider adjusting the width as needed
                                        fit: BoxFit.cover,
                                      )
                                    else
                                       Image.network(
                                         'https://i.ibb.co/C8gN8mV/images.png',
                                        width: 40,
                                        // Consider adjusting the width as needed
                                        //fit: BoxFit.cover,
                                      ),
                                    Center(
                                      child: Text(
                                        catController
                                            .subCategoryList![index].name!,
                                        style: index ==
                                                catController.subCategoryIndex
                                            ? robotoBold.copyWith(
                                                fontSize: 9,
                                                color: Theme.of(context)
                                                    .primaryColor)
                                            : robotoBold.copyWith(
                                                fontSize: 9,
                                                                  color: Theme.of(context)
                                                                      .primaryColor.withOpacity(0.5),
                                              ),
                                        maxLines: 3,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(),

                // Your Column with TabBar and TabBarView goes here
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: Dimensions.webMaxWidth,
                          color: Theme.of(context).cardColor,
                          child: TabBar(
                            controller: _tabController,
                            indicatorColor: Theme.of(context).primaryColor,
                            indicatorWeight: 3,
                            labelColor: Theme.of(context).primaryColor,
                            unselectedLabelColor:
                                Theme.of(context).disabledColor,
                            unselectedLabelStyle: robotoRegular.copyWith(
                              color: Theme.of(context).disabledColor,
                              fontSize: Dimensions.fontSizeSmall,
                            ),
                            labelStyle: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).primaryColor,
                            ),
                            tabs: [
                              Tab(text: 'item'.tr),
                              (stores != null && stores.length > 1 )
                                  ? Tab(
                                text: Get.find<SplashController>()
                                    .configModel!
                                    .moduleConfig!
                                    .module!
                                    .showRestaurantText!
                                    ? 'Clinic'.tr
                                    : 'stores'.tr,
                              )
                                  : SizedBox()
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: NotificationListener(
                          onNotification: (dynamic scrollNotification) {
                            if (scrollNotification is ScrollEndNotification) {
                              if ((_tabController!.index == 1 &&
                                      !catController.isStore) ||
                                  _tabController!.index == 0 &&
                                      catController.isStore) {
                                catController
                                    .setRestaurant(_tabController!.index == 1);
                                if (catController.isSearching) {
                                  catController.searchData(
                                    catController.searchText,
                                    catController.subCategoryIndex == 0
                                        ? widget.categoryID
                                        : catController
                                            .subCategoryList![
                                                catController.subCategoryIndex]
                                            .id
                                            .toString(),
                                    catController.type,
                                  );
                                } else {
                                  if (_tabController!.index == 1) {
                                    catController.getCategoryStoreList(
                                      catController.subCategoryIndex == 0
                                          ? widget.categoryID
                                          : catController
                                              .subCategoryList![catController
                                                  .subCategoryIndex]
                                              .id
                                              .toString(),
                                      1,
                                      catController.type,
                                      false,
                                    );
                                  } else {
                                    catController.getCategoryItemList(
                                      catController.subCategoryIndex == 0
                                          ? widget.categoryID
                                          : catController
                                              .subCategoryList![catController
                                                  .subCategoryIndex]
                                              .id
                                              .toString(),
                                      1,
                                      catController.type,
                                      false,
                                    );
                                  }
                                }
                              }
                            }
                            return false;
                          },
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              SingleChildScrollView(
                                controller: scrollController,
                                child: ItemsView(
                                  isStore: false,
                                  items: item,
                                  stores: null,
                                  noDataText: 'no_category_item_found'.tr,
                                ),
                              ),
                              SingleChildScrollView(
                                controller: storeScrollController,
                                child: ItemsView(
                                  isStore: true,
                                  items: null,
                                  stores: stores,
                                  noDataText: Get.find<SplashController>()
                                          .configModel!
                                          .moduleConfig!
                                          .module!
                                          .showRestaurantText!
                                      ? 'no_category_restaurant_found'.tr
                                      : 'no_category_store_found'.tr,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      catController.isLoading
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeSmall),
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor)),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          )),

            bottomNavigationBar:
            GetBuilder<CartController>(builder: (cartController) {
              return cartController.cartList.isNotEmpty &&
                  !ResponsiveHelper.isDesktop(context)
                  ? const BottomCartWidget()
                  : const SizedBox();
            })
        ),
      );
    });
  }
}
