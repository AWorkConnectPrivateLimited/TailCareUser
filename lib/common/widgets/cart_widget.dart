import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/cart/controllers/cart_controller.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../util/images.dart';

class CartWidget extends StatelessWidget {
  final Color? color;
  final double size;
  final bool fromStore;

  const CartWidget(
      {super.key,
      required this.color,
      required this.size,
      this.fromStore = false});

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Image.asset(
        Images
            .shoppingCart,
        height: 0,
        width: 0,
      ),
      GetBuilder<CartController>(builder: (cartController) {
        return cartController.cartList.isNotEmpty
            ? Positioned(
                top: -30,
                right: -45,
                child: Container(
                  height: size < 20 ? 10 : size / 2,
                  width: size < 20 ? 10 : size / 2,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: fromStore
                        ?Color(0xFFf0f2f5)
                        : Color(0xFFf0f2f5),
                    border: Border.all(
                        width: size < 20 ? 0.7 : 1,
                        color: fromStore
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor),
                  ),
                  child: Text(
                    cartController.cartList.length.toString(),
                    style: robotoBold.copyWith(
                      fontSize: size < 20 ? size / 3 : size / 3,
                      color: fromStore
                          ? Theme.of(context).primaryColor
                          : const Color(0xFF3f3871),
                    ),
                  ),
                ),
              )
            : const SizedBox();
      }),
    ]);
  }
}
