import 'dart:async';
import 'dart:collection';

import 'package:geolocator/geolocator.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sixam_mart/common/controllers/theme_controller.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/location/widgets/permission_dialog_widget.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/chat/domain/models/conversation_model.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/features/order/domain/models/order_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/marker_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/features/order/widgets/track_details_view_widget.dart';
import 'package:sixam_mart/features/order/widgets/tracking_stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../../../helper/date_converter.dart';
import '../../../util/styles.dart';
import '../../parcel/widgets/details_widget.dart';
import '../widgets/order_info_widget.dart';
import '../widgets/order_item_widget.dart';
import 'order_details_screen.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String? orderID;
  final String? contactNumber;
  const OrderTrackingScreen({super.key, required this.orderID, this.contactNumber});

  @override
  OrderTrackingScreenState createState() => OrderTrackingScreenState();
}

class OrderTrackingScreenState extends State<OrderTrackingScreen> {
  GoogleMapController? _controller;
  bool _isLoading = true;
  Set<Marker> _markers = HashSet<Marker>();
  Set<Polyline> _polylines = {};
  Timer? _timer;
  bool showChatPermission = true;

  void _loadData() async {
    await Get.find<OrderController>().trackOrder(widget.orderID, null, true, contactNumber: widget.contactNumber);
    await Get.find<LocationController>().getCurrentLocation(true, notify: false, defaultLatLng: LatLng(
      double.parse(AddressHelper.getUserAddressFromSharedPref()!.latitude!),
      double.parse(AddressHelper.getUserAddressFromSharedPref()!.longitude!),
    ));
  }

  void _startApiCall(){
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      Get.find<OrderController>().timerTrackOrder(widget.orderID.toString(), contactNumber: widget.contactNumber);
    });
  }

  @override
  void initState() {
    super.initState();

    _loadData();
    _startApiCall();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _timer?.cancel();
  }
  String mapStyleJson = '''
   [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]
  ''';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'order_tracking'.tr,),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<OrderController>(builder: (orderController) {
        OrderModel? track;
        bool parcel = false;
        bool prescriptionOrder = false;
        bool ongoing = false;
        if(orderController.trackModel != null) {
          track = orderController.trackModel;

          if(track!.orderType != 'parcel') {
            if (track.store!.storeBusinessModel == 'commission') {
              showChatPermission = true;
            } else if (track.store!.storeSubscription != null && track.store!.storeBusinessModel == 'subscription') {
              showChatPermission = track.store!.storeSubscription!.chat == 1;
            } else {
              showChatPermission = false;
            }
          }
        }

        return track != null ? Center(child: SizedBox(width: Dimensions.webMaxWidth, child: Column(children: [


           Expanded(
             flex: 2,
            child:  Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(target: LatLng(
                    double.parse(track.deliveryAddress!.latitude!), double.parse(track.deliveryAddress!.longitude!),
                  ), zoom: 50),
                 // minMaxZoomPreference: const MinMaxZoomPreference(0, 50),
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,

                  style:mapStyleJson,




                  buildingsEnabled: true,
                  indoorViewEnabled: false,
                  markers: _markers,
                  polylines: _polylines, // Add this line to display polylines
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    _isLoading = false;
                    setMarker(
                      track!.orderType == 'parcel' ? Store(latitude: track.receiverDetails!.latitude, longitude: track.receiverDetails!.longitude,
                          address: track.receiverDetails!.address, name: track.receiverDetails!.contactPersonName) : track.store, track.deliveryMan,
                      track.orderType == 'take_away' ? Get.find<LocationController>().position.latitude == 0 ? track.deliveryAddress : AddressModel(
                        latitude: Get.find<LocationController>().position.latitude.toString(),
                        longitude: Get.find<LocationController>().position.longitude.toString(),
                        address: Get.find<LocationController>().address,
                      ) : track.deliveryAddress, track.orderType == 'take_away', track.orderType == 'parcel', track.moduleType == 'food',
                    );

                    setPolyline(
                      track, // Pass the entire track object
                      track.store,
                      track.deliveryMan,
                      track.deliveryAddress,
                      track.orderType == 'take_away',
                      track.orderType == 'parcel',
                      track.moduleType == 'food',
                    );
                  },
                  // style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                ),

                _isLoading ? const Center(child: CircularProgressIndicator()) : const SizedBox(),

                Positioned(
                  top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
                  child: TrackingStepperWidget(status: track.orderStatus, takeAway: track.orderType == 'take_away'),
                ),

                Positioned(
                  right: 15, bottom: track.orderType != 'take_away' && track.deliveryMan == null ? 150 : 190,
                  child: InkWell(
                    onTap: () => _checkPermission(() async {
                      AddressModel address = await Get.find<LocationController>().getCurrentLocation(false, mapController: _controller);
                      setMarker(
                        track!.orderType == 'parcel' ? Store(latitude: track.receiverDetails!.latitude, longitude: track.receiverDetails!.longitude,
                            address: track.receiverDetails!.address, name: track.receiverDetails!.contactPersonName) : track.store, track.deliveryMan,
                        track.orderType == 'take_away' ? Get.find<LocationController>().position.latitude == 0 ? track.deliveryAddress : AddressModel(
                          latitude: Get.find<LocationController>().position.latitude.toString(),
                          longitude: Get.find<LocationController>().position.longitude.toString(),
                          address: Get.find<LocationController>().address,
                        ) : track.deliveryAddress, track.orderType == 'take_away', track.orderType == 'parcel', track.moduleType == 'food',
                        currentAddress: address, fromCurrentLocation: true,
                      );
                    }),
                    child: Container(
                      padding: const EdgeInsets.all( Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.white),
                      child: Icon(Icons.my_location_outlined, color: Theme.of(context).primaryColor, size: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),


          Expanded(
            flex: 2,
            child: Positioned(
              bottom: Dimensions.paddingSizeSmall,
              left: Dimensions.paddingSizeSmall,
              right: Dimensions.paddingSizeSmall,
              child: SingleChildScrollView( //Wrap with SingleChildScrollView
                child: Column(
                  children: [

                    TrackDetailsViewWidget(
                      status: track.orderStatus,
                      track: track,
                      showChatPermission: showChatPermission,
                      callback: () async {
                        _timer?.cancel();
                        await Get.toNamed(RouteHelper.getChatRoute(
                          notificationBody: NotificationBodyModel(deliverymanId: track!.deliveryMan!.id, orderId: int.parse(widget.orderID!)),
                          user: User(id: track.deliveryMan!.id, fName: track.deliveryMan!.fName, lName: track.deliveryMan!.lName, imageFullUrl: track.deliveryMan!.imageFullUrl),
                        ));
                        _startApiCall();
                      },
                    ),


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [

                          // Text('general_info'.tr, style: robotoMedium),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Get.find<SplashController>().configModel!.orderDeliveryVerification! ? Row(children: [
                              Text('${'delivery_verification_code'.tr}:', style: robotoRegular),
                              const Expanded(child: SizedBox()),
                              Text(track.otp!, style: robotoMedium),
                            ]) : const SizedBox(),
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Row(children: [
                            Text(parcel ? 'delivery_id'.tr : 'order_id'.tr, style: robotoRegular),
                            const Expanded(child: SizedBox()),

                            Text('#${track.id}', style: robotoBold),
                          ]),
                          Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withOpacity(0.30)),

                          Row(children: [
                            Text('order_date'.tr, style: robotoRegular),
                            const Expanded(child: SizedBox()),

                            Text(
                              DateConverter.dateTimeStringToDateTime(track.createdAt!),
                              style: robotoRegular,
                            ),
                          ]),
                          Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withOpacity(0.30)),
                          Row(children: [
                            Text(track.orderType!.tr, style: robotoMedium),
                            const Expanded(child: SizedBox()),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Text( track.paymentMethod == 'cash_on_delivery' ? 'cash_on_delivery'.tr
                                  : track.paymentMethod == 'wallet' ? 'wallet_payment'.tr
                                  : track.paymentMethod == 'partial_payment' ? 'partial_payment'.tr
                                  : track.paymentMethod == 'offline_payment' ? 'offline_payment'.tr : 'digital_payment'.tr,
                                style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall),
                              ),
                            ),
                          ]),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 120.0,vertical: 20),
                            child: InkWell(
                              onTap: () async{
                                _timer?.cancel();
                                await Get.toNamed(RouteHelper.getOrderDetailsRoute(track?.id))?.whenComplete(() {
                                  _startApiCall();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeSmall : Dimensions.paddingSizeExtraSmall),
                                decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  color: Theme.of(context).primaryColor,
                                ) : BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                ),
                                child: Row(children: [
                                  Image.asset(Images.tracking, height: 15, width: 15, color: ResponsiveHelper.isDesktop(context) ? Colors.white : Theme.of(context).primaryColor),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Text('View All Details', style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall, color: ResponsiveHelper.isDesktop(context) ? Colors.white : Theme.of(context).primaryColor,
                                  )),
                                ]),
                              ),
                            ),
                          )



                        ],
                      ),
                    ),





                  ],
                ),
              ),
            ),
          ),








        ]))) : const Center(child: CircularProgressIndicator());
      }),
    );
  }

  void setMarker(Store? store, DeliveryMan? deliveryMan, AddressModel? addressModel, bool takeAway, bool parcel, bool isRestaurant, {AddressModel? currentAddress, bool fromCurrentLocation = false}) async {
    try {

      BitmapDescriptor restaurantImageData = await MarkerHelper.convertAssetToBitmapDescriptor(
        width: (isRestaurant || parcel) ? 100 : 150,
        imagePath: parcel ? Images.userMarker : isRestaurant ? Images.restaurantMarker : Images.markerStore,
      );

      BitmapDescriptor deliveryBoyImageData = await MarkerHelper.convertAssetToBitmapDescriptor(
        width: 100, imagePath: Images.deliveryManMarker,
      );
      BitmapDescriptor destinationImageData = await MarkerHelper.convertAssetToBitmapDescriptor(
        width: 100, imagePath: takeAway ? Images.myLocationMarker : Images.userMarker,
      );

      /// Animate to coordinate
      LatLngBounds? bounds;
      double rotation = 0;
      if(_controller != null) {
        if (double.parse(addressModel!.latitude!) < double.parse(store!.latitude!)) {
          bounds = LatLngBounds(
            southwest: LatLng(double.parse(addressModel.latitude!), double.parse(addressModel.longitude!)),
            northeast: LatLng(double.parse(store.latitude!), double.parse(store.longitude!)),
          );
          rotation = 0;
        }else {
          bounds = LatLngBounds(
            southwest: LatLng(double.parse(store.latitude!), double.parse(store.longitude!)),
            northeast: LatLng(double.parse(addressModel.latitude!), double.parse(addressModel.longitude!)),
          );
          rotation = 180;
        }
      }
      LatLng centerBounds = LatLng(
        (bounds!.northeast.latitude + bounds.southwest.latitude)/2,
        (bounds.northeast.longitude + bounds.southwest.longitude)/2,
      );

      if(fromCurrentLocation && currentAddress != null) {
        LatLng currentLocation = LatLng(
          double.parse(currentAddress.latitude!),
          double.parse(currentAddress.longitude!),
        );
        _controller!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: currentLocation, zoom: GetPlatform.isWeb ? 7 : 15)));
      }

      if(!fromCurrentLocation) {
        _controller!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: centerBounds, zoom: GetPlatform.isWeb ? 10 : 17)));
        if(!ResponsiveHelper.isWeb()) {
          zoomToFit(_controller, bounds, centerBounds, padding: GetPlatform.isWeb ? 15 : 3);
        }
      }

      /// user for normal order , but sender for parcel order
      _markers = HashSet<Marker>();

      ///current location marker set
      if(currentAddress != null) {
        _markers.add(Marker(
          markerId: const MarkerId('current_location'),
          visible: true,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          position: LatLng(
            double.parse(currentAddress.latitude!),
            double.parse(currentAddress.longitude!),
          ),
          icon: destinationImageData,
        ));
        setState(() {});
      }

      if(currentAddress == null){
        addressModel != null ? _markers.add(Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(double.parse(addressModel.latitude!), double.parse(addressModel.longitude!)),
          infoWindow: InfoWindow(
            title: parcel ? 'Sender' : 'Destination',
            snippet: addressModel.address,
          ),
          icon: destinationImageData,
        )) : const SizedBox();
      }

      ///store for normal order , but receiver for parcel order
      store != null ? _markers.add(Marker(
        markerId: const MarkerId('store'),
        position: LatLng(double.parse(store.latitude!), double.parse(store.longitude!)),
        infoWindow: InfoWindow(
          title: parcel ? 'Receiver' : Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'store'.tr : 'store'.tr,
          snippet: store.address,
        ),
        icon: restaurantImageData,
      )) : const SizedBox();

      deliveryMan != null ? _markers.add(Marker(
        markerId: const MarkerId('delivery_boy'),
        position: LatLng(double.parse(deliveryMan.lat ?? '0'), double.parse(deliveryMan.lng ?? '0')),
        infoWindow: InfoWindow(
          title: 'delivery_man'.tr,
          snippet: deliveryMan.location,
        ),
        rotation: rotation,
        icon: deliveryBoyImageData,
      )) : const SizedBox();

    }catch(_) {}
    setState(() {});
  }
  Future<void> setPolyline(OrderModel? track, Store? store, DeliveryMan? deliveryMan, AddressModel? addressModel, bool takeAway, bool parcel, bool isRestaurant, {AddressModel? currentAddress, bool fromCurrentLocation = false}) async {
    String apiKey = 'AIzaSyC7aWM0FKpPSbBGkRf2UDCA19Y0aMbjmJA'; // Replace with your actual API key

    // Handle 'picked_up' status (using Directions API)
    if (track?.orderStatus == 'picked_up') {
      LatLng originForDirections = LatLng(double.parse(addressModel?.latitude ?? '0'), double.parse(addressModel?.longitude ?? '0'));
      LatLng destinationForDirections = LatLng(double.parse(deliveryMan?.lat ?? '0'), double.parse(deliveryMan?.lng ?? '0'));

      String url = 'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${originForDirections.latitude},${originForDirections.longitude}&'
          'destination=${destinationForDirections.latitude},${destinationForDirections.longitude}&'
          'key=$apiKey';

      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var routes = decodedResponse['routes'] as List;
        if (routes.isNotEmpty) {
          var overviewPolyline = routes[0]['overview_polyline']['points'];

          PolylinePoints polylinePoints = PolylinePoints();
          List<LatLng> result = polylinePoints.decodePolyline(overviewPolyline).map((point) => LatLng(point.latitude, point.longitude)).toList();

          Polyline polyline = Polyline(
            polylineId: const PolylineId("polyline_id_pickedup"),
            points: result,
            color: const Color(0xFF4C4C80),
            width: 5,
          );

          setState(() {
            _polylines.add(polyline);
          });
        }
      }
    }

    // Handle 'processing', 'pending', or 'accepted' status (concurrent API requests)
    if (track?.orderStatus == 'processing' || track?.orderStatus == 'pending' || track?.orderStatus == 'accepted' && store != null) {
      LatLng storeOrigin = LatLng(double.parse(store!.latitude! as String), double.parse(store.longitude! as String));
      LatLng deliveryManLocation = LatLng(double.parse(deliveryMan?.lat ?? '0'), double.parse(deliveryMan?.lng ?? '0'));
      LatLng origin = LatLng(double.parse(addressModel?.latitude ?? '0'), double.parse(addressModel?.longitude ?? '0'));

      // Fetch routes concurrently using Future.wait
      List<Future<http.Response>> futures = [
        http.get(Uri.parse('https://maps.googleapis.com/maps/api/directions/json?origin=${deliveryManLocation.latitude},${deliveryManLocation.longitude}&destination=${storeOrigin.latitude},${storeOrigin.longitude}&key=$apiKey')),
        http.get(Uri.parse('https://maps.googleapis.com/maps/api/directions/json?origin=${storeOrigin.latitude},${storeOrigin.longitude}&destination=${origin.latitude},${origin.longitude}&key=$apiKey')),
      ];

      List<http.Response> responses = await Future.wait(futures);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        var decodedResponse1 = jsonDecode(responses[0].body);
        var decodedResponse2 = jsonDecode(responses[1].body);

        var routes1 = decodedResponse1['routes'] as List;
        var routes2 = decodedResponse2['routes'] as List;

        if (routes1.isNotEmpty && routes2.isNotEmpty) {
          var overviewPolyline1 = routes1[0]['overview_polyline']['points'];
          var overviewPolyline2 = routes2[0]['overview_polyline']['points'];

          PolylinePoints polylinePoints = PolylinePoints();
          List<LatLng> result1 = polylinePoints.decodePolyline(overviewPolyline1).map((point) => LatLng(point.latitude, point.longitude)).toList();
          List<LatLng> result2 = polylinePoints.decodePolyline(overviewPolyline2).map((point) => LatLng(point.latitude, point.longitude)).toList();

          Polyline polyline1 = Polyline(
            polylineId: const PolylineId("polyline_id_initial_1"),
            points: result1,
            color: const Color(0xFF4C4C80),
            width: 5,
          );

          Polyline polyline2 = Polyline(
            polylineId: const PolylineId("polyline_id_initial_2"),
            points: result2,
            color: const Color(0xFF4C4C80),
            width: 5,
          );

          setState(() {
            _polylines.add(polyline1);
            _polylines.add(polyline2);
          });
        }
      }
    }
  }

  Future<void> zoomToFit(GoogleMapController? controller, LatLngBounds? bounds, LatLng centerBounds, {double padding = 0.5}) async {
    bool keepZoomingOut = true;

    while(keepZoomingOut) {
      final LatLngBounds screenBounds = await controller!.getVisibleRegion();
      if(fits(bounds!, screenBounds)){
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - padding;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      }
      else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck = screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck = screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck = screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck = screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck && northEastLongitudeCheck && southWestLatitudeCheck && southWestLongitudeCheck;
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialogWidget());
    }else {
      onTap();
    }
  }

}
