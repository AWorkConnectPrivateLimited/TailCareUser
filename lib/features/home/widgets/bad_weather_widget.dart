import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class BadWeatherWidget extends StatefulWidget {
  final bool inParcel;

  const BadWeatherWidget({super.key, this.inParcel = false});

  @override
  State<BadWeatherWidget> createState() => _BadWeatherWidgetState();
}

class _BadWeatherWidgetState extends State<BadWeatherWidget> {
  bool _showAlert = true;
  String? _message;

  @override
  void initState() {
    super.initState();

    ZoneData? zoneData;
    for (var data in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
      if (data.id == AddressHelper.getUserAddressFromSharedPref()!.zoneId) {
        if (data.increaseDeliveryFeeStatus == 1 &&
            data.increaseDeliveryFeeMessage != null) {
          zoneData = data;
        }
      }
    }

    if (zoneData != null) {
      _showAlert = zoneData.increaseDeliveryFeeStatus == 1;
      _message = zoneData.increaseDeliveryFeeMessage;
    } else {
      _showAlert = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _showAlert && _message != null && _message!.isNotEmpty
        ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: const Color(0xFFF3F6F8),
              ),
              padding: const EdgeInsets.only(
                  left: 10,bottom: 5, top: 5,right: 10
                  ),

              child: Row(
                children: [
                  Lottie.asset(
                    height: 30,
                    'assets/lottie/weather.json', // Replace with your Lottie file path
                    fit: BoxFit.cover,
                  ),
                  Lottie.asset(
                    height: 30,
                    'assets/lottie/weather2.json', // Replace with your Lottie file path
                    fit: BoxFit.cover,
                  ),

                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(
                      child: Text(
                    _message!,
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Color(0xFF3f3871)),
                  )),
                ],
              ),
            ),
        )
        : const SizedBox();
  }
}
