import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loccar_agency/models/rent.dart';
import 'package:loccar_agency/screens/dashboard/rents/edit_rent_user_screen.dart';
import 'package:loccar_agency/services/rent.dart';
import 'package:loccar_agency/utils/bottom_sheet_helper.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/helpers.dart';
import 'package:loccar_agency/utils/snack_bar_helper.dart';
import 'package:loccar_agency/widgets/buttons/rounded_button.dart';
import 'package:loccar_agency/widgets/buttons/sized_button.dart';
import 'package:loccar_agency/widgets/custom_cached_network_image.dart';
import 'package:loccar_agency/widgets/textfields/custom_date_picker.dart';
import 'package:loccar_agency/widgets/textfields/custom_text_field.dart';
import 'package:slider_button/slider_button.dart';
import 'package:url_launcher/url_launcher.dart';

class RentDetailsScreen extends StatefulWidget {
  final RentModel rent;
  const RentDetailsScreen({required this.rent, super.key});

  @override
  State<RentDetailsScreen> createState() => _RentDetailsScreenState();
}

class _RentDetailsScreenState extends State<RentDetailsScreen> {
  int rentState = 0;

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController advancePriceController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  GlobalKey<FormState> updateRentKeyForm = GlobalKey();
  GlobalKey<FormState> sendLocationKeyForm = GlobalKey();

  final _controller = Completer<GoogleMapController>();
  LatLng _initialPosition = const LatLng(6.1966342, 1.204565);
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(6.1966342, 1.204565),
    zoom: 17.4746,
  );
  bool locationGot = false;
  MapType mapType = MapType.normal;
  Marker? userMarker;

  int reduction = 0, percent = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    rentState = widget.rent.state;

    startDateController.text =
        Helpers.formatDateTimeToString(widget.rent.startDate, lang: "en");
    endDateController.text =
        Helpers.formatDateTimeToString(widget.rent.endDate, lang: "en");
    daysController.text = widget.rent.days.toString();
    hoursController.text = widget.rent.hours.toString();
    advancePriceController.text = widget.rent.deposit.toString();
    priceController.text = widget.rent.price.toString();

    if (widget.rent.lat != 0.0 && widget.rent.lon != 0.0) {
      userMarker = Marker(
        markerId: const MarkerId('userMarker'),
        infoWindow: InfoWindow(title: widget.rent.user!.userName),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        position: LatLng(widget.rent.lat, widget.rent.lon),
      );
    }

    setState(() {});
  }

  Future<void> _getUserLocation() async {
    Position position = await _getGeoLocationPosition();
    setState(() {
      cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.4746,
      );
      _initialPosition = LatLng(position.latitude, position.longitude);
      locationGot = true;
    });
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Détails de la location"),
        ),
        body: Stack(children: [
          Container(
              height: double.maxFinite,
              margin: const EdgeInsets.only(bottom: 65),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  SizedBox(
                      height: Dimensions.getScreenHeight(context) * 0.3,
                      width: Dimensions.getScreenWidth(context),
                      child: locationGot
                          ? Stack(
                              children: [
                                GoogleMap(
                                  myLocationEnabled: true,
                                  zoomControlsEnabled: false,
                                  myLocationButtonEnabled: false,
                                  trafficEnabled: false,
                                  mapType: mapType,
                                  initialCameraPosition: cameraPosition,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                  },
                                  markers: const {},
                                  onCameraMoveStarted: () {},
                                  onCameraMove: (cameraPosition) {
                                    this.cameraPosition = cameraPosition;
                                    setState(() {
                                      _initialPosition = LatLng(
                                          cameraPosition.target.latitude,
                                          cameraPosition.target.longitude);
                                    });
                                  },
                                  circles: const {},
                                  onCameraIdle: () async {},
                                ),
                                Positioned(
                                    bottom: 20,
                                    right: 10,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              mapType =
                                                  (mapType == MapType.normal)
                                                      ? MapType.satellite
                                                      : MapType.normal;
                                            });
                                          },
                                          child: Card(
                                            margin: EdgeInsets.zero,
                                            elevation: 4,
                                            child: Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              alignment: Alignment.center,
                                              child: const FaIcon(
                                                FontAwesomeIcons.earthAfrica,
                                                color: Colors.black45,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Dimensions.verticalSpacer(10),
                                        GestureDetector(
                                          onTap: () async {
                                            final GoogleMapController
                                                controller =
                                                await _controller.future;
                                            _getUserLocation().then((value) {
                                              controller.animateCamera(
                                                  CameraUpdate
                                                      .newCameraPosition(
                                                CameraPosition(
                                                  bearing: 0,
                                                  target: LatLng(
                                                      _initialPosition.latitude,
                                                      _initialPosition
                                                          .longitude),
                                                  zoom: 17.0,
                                                ),
                                              ));
                                            });
                                          },
                                          child: Card(
                                              margin: EdgeInsets.zero,
                                              elevation: 4,
                                              child: Container(
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                alignment: Alignment.center,
                                                child: const FaIcon(
                                                  FontAwesomeIcons.crosshairs,
                                                  color: Colors.black45,
                                                  size: 20,
                                                ),
                                              )),
                                        ),
                                        Dimensions.verticalSpacer(10),
                                        GestureDetector(
                                          onTap: () {
                                            BottomSheetHelper
                                                .showCustomBottomSheet(
                                                    context,
                                                    "Envoyer la localisation",
                                                    _buildSendLocationForm(
                                                        context),
                                                    heightRatio: 0.3);
                                          },
                                          child: Card(
                                              margin: EdgeInsets.zero,
                                              elevation: 4,
                                              child: Container(
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppColors.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                alignment: Alignment.center,
                                                child: const FaIcon(
                                                  FontAwesomeIcons.paperPlane,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              )),
                                        )
                                      ],
                                    )),
                              ],
                            )
                          : const Center(child: CircularProgressIndicator())),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        _buildUserCardInfos(),
                        Dimensions.verticalSpacer(15),
                        _buildActionsButtons(),
                        Divider(
                          color: AppColors.primaryColor,
                          height: 20,
                        ),
                        _buildLocationForm(),
                      ],
                    ),
                  ),
                ],
              ))),
          Visibility(
            visible: rentState == 2,
            child: Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Course terminée",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.primaryColor),
                    )
                  ],
                )),
          ),
          Visibility(
            visible: rentState != 2 ? true : false,
            child: Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: SliderButton(
                  buttonSize: 50,
                  height: 50,
                  action: () {
                    if (rentState == 0) {
                      BottomSheetHelper.showModalSheetWithConfirmationButton(
                          context,
                          const FaIcon(FontAwesomeIcons.check,
                              color: Colors.white),
                          "Commencer la location",
                          "Voulez-vous vraiment commencer la location?", () {
                        updateRent(context,
                            state: 1,
                            startDate: Helpers.formatDateTimeToString(
                                DateTime.now().toUtc(),
                                lang: "en"));
                      });
                    } else {
                      BottomSheetHelper.showModalSheetWithConfirmationButton(
                          context,
                          const FaIcon(FontAwesomeIcons.check,
                              color: Colors.white),
                          "Terminer la location",
                          "Voulez-vous vraiment terminer la location?", () {
                        updateRent(context,
                            state: 2,
                            endDate: Helpers.formatDateTimeToString(
                                DateTime.now().toUtc(),
                                lang: "en"));
                      });
                    }

                    return Future.value(false);
                  },
                  label: Text(
                    rentState == 0
                        ? "COMMENCER LA LOCATION"
                        : "TERMINER LA LOCATION",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                  icon: Center(
                      child: FaIcon(
                    FontAwesomeIcons.circleArrowRight,
                    color:
                        rentState == 0 ? AppColors.secondaryColor : Colors.red,
                    size: 30,
                  )),
                  boxShadow:
                      const BoxShadow(blurRadius: 0.5, spreadRadius: 0.1),
                  shimmer: true,
                  vibrationFlag: true,
                  width: Dimensions.getScreenWidth(context) * 0.9,
                  radius: 10,
                  buttonColor: Colors.white,
                  backgroundColor:
                      rentState == 0 ? AppColors.secondaryColor : Colors.red,
                  highlightedColor: AppColors.primaryColor,
                  baseColor: Colors.white,
                )),
          )
        ]));
  }

  Widget _buildUserCardInfos() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${widget.rent.user!.userName} ${widget.rent.user!.isSafe ? "🟢" : "🔴"}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              Dimensions.verticalSpacer(5),
              Text(
                "${widget.rent.car!.brand} ${widget.rent.car!.model} ${widget.rent.car!.year}",
              ),
              Dimensions.verticalSpacer(10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "${widget.rent.car!.plateCountry} ${widget.rent.car!.plateNumber} ${widget.rent.car!.plateSeries}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),
                  ),
                  Dimensions.horizontalSpacer(10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditRentUserScreen(
                                  rentUser: widget.rent.user!)));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.file,
                            color: AppColors.primaryColor,
                            size: 14,
                          ),
                          Dimensions.horizontalSpacer(5),
                          const Text("Documents"),
                          Dimensions.horizontalSpacer(5),
                          const FaIcon(
                            FontAwesomeIcons.angleRight,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Dimensions.horizontalSpacer(10),
        widget.rent.car!.carPhotos.isNotEmpty
            ? CustomCachedNetworkImage(
                imageUrl:
                    "${Constants.baseUrl}/${widget.rent.car!.carPhotos.first.carPhoto}",
                height: Dimensions.getScreenWidth(context) * 0.15,
                width: Dimensions.getScreenWidth(context) * 0.15,
                borderRadius: 7.75)
            : Container(
                height: Dimensions.getScreenWidth(context) * 0.15,
                width: Dimensions.getScreenWidth(context) * 0.15,
                decoration: BoxDecoration(
                  color: AppColors.thirdyColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: FaIcon(FontAwesomeIcons.car, color: Colors.white),
                ),
              ),
      ],
    );
  }

  Widget _buildActionsButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedButton(
              width: Dimensions.getScreenWidth(context) * 0.3,
              height: 40,
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();

                var phoneNumber = "tel:${widget.rent.user!.phoneNumber}";
                try {
                  launchUrl(Uri.parse(phoneNumber));
                  // ignore: empty_catches
                } catch (e) {}
              },
              color: AppColors.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.phone,
                      color: Colors.white,
                      size: 16,
                    ),
                    Dimensions.horizontalSpacer(5),
                    const Text("Appeler",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              )),
        ),
        Dimensions.horizontalSpacer(10),
        Expanded(
          child: SizedButton(
              width: Dimensions.getScreenWidth(context) * 0.3,
              height: 40,
              onPressed: () {},
              color: Colors.grey.shade600,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.message,
                      color: Colors.white,
                      size: 16,
                    ),
                    Dimensions.horizontalSpacer(5),
                    const Text("Discussion",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              )),
        ),
        Dimensions.horizontalSpacer(10),
        Expanded(
          child: SizedButton(
              width: Dimensions.getScreenWidth(context) * 0.3,
              height: 40,
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();

                var whatsappUrl =
                    "whatsapp://send?phone=${widget.rent.user!.phoneNumber}";
                try {
                  launchUrl(Uri.parse(whatsappUrl));
                  // ignore: empty_catches
                } catch (e) {}
              },
              color: AppColors.thirdyColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: 16,
                    ),
                    Dimensions.horizontalSpacer(5),
                    const Text("WhatsApp",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildLocationForm() {
    return Form(
      key: updateRentKeyForm,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "Date de début",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Dimensions.verticalSpacer(5),
        CustomDatePicker(
            controller: startDateController,
            value: startDateController.text,
            hintText: 'Choisir la date de début',
            errorMessage: "La date de début est obligatoire",
            enabled: rentState == 0,
            onlyDate: false,
            maxLength: 25,
            onDatePicked: (DateTime? value) {
              if (value != null) {
                setState(() {
                  startDateController.text =
                      Helpers.formatDateTimeToString(value, lang: "en");
                });
                applyDiscount();
              }
            }),
        const Text(
          "Date de fin",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Dimensions.verticalSpacer(10),
        CustomDatePicker(
            controller: endDateController,
            value: endDateController.text,
            hintText: 'Choisir la date de fin',
            errorMessage: "La date de fin est obligatoire",
            enabled: rentState != 2,
            onlyDate: false,
            maxLength: 25,
            onDatePicked: (DateTime? value) {
              if (value != null) {
                setState(() {
                  endDateController.text =
                      Helpers.formatDateTimeToString(value, lang: "en");
                  applyDiscount();
                });
              }
            }),
        Dimensions.verticalSpacer(10),
        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nombre de jours",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Dimensions.verticalSpacer(5),
                CustomTextField(
                  controller: daysController,
                  value: daysController.text,
                  enabled: false,
                  keyboardType: TextInputType.number,
                  hintText: 'Nombre de jours',
                  maxLength: 10,
                ),
              ],
            )),
            Dimensions.horizontalSpacer(10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nombre d'heures",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Dimensions.verticalSpacer(5),
                CustomTextField(
                  controller: hoursController,
                  enabled: false,
                  value: hoursController.text,
                  keyboardType: TextInputType.number,
                  hintText: "Nombre d'heures",
                  maxLength: 10,
                ),
              ],
            )),
          ],
        ),
        Dimensions.verticalSpacer(10),
        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Prix (En Fcfa)",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Dimensions.horizontalSpacer(5),
                    isLoading
                        ? SpinKitSquareCircle(
                            color: AppColors.primaryColor,
                            size: 20,
                          )
                        : const Center(),
                  ],
                ),
                Dimensions.verticalSpacer(5),
                CustomTextField(
                  controller: priceController,
                  value: priceController.text,
                  keyboardType: TextInputType.number,
                  enabled: false,
                  hintText: 'Prix',
                  errorMessage: "Le prix est obligatoire",
                  maxLength: 10,
                ),
              ],
            )),
            Dimensions.horizontalSpacer(10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Caution ou avance",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Dimensions.verticalSpacer(5),
                CustomTextField(
                  controller: advancePriceController,
                  value: advancePriceController.text,
                  keyboardType: TextInputType.number,
                  hintText: 'Caution ou avance',
                  errorMessage: "La caution ou avance est obligatoire",
                  maxLength: 10,
                ),
              ],
            )),
          ],
        ),
        Dimensions.verticalSpacer(10),
        Visibility(
          visible: rentState == 0,
          child: RoundedButton(
            isActive: true,
            color: AppColors.primaryColor,
            textColor: Colors.white,
            text: 'Mettre à jour',
            onPressed: () {
              if (updateRentKeyForm.currentState!.validate()) {
                updateRent(context,
                    state: rentState,
                    endDate: endDateController.text,
                    startDate: startDateController.text,
                    deposit: int.parse(advancePriceController.text));
              }
            },
          ),
        )
      ]),
    );
  }

  Future<void> applyDiscount() async {
    if (startDateController.text.isNotEmpty &&
        endDateController.text.isNotEmpty) {
      DateTime startDate = DateTime.parse(startDateController.text);
      DateTime endDate = DateTime.parse(endDateController.text);
      Duration difference = endDate.difference(startDate);

      int countDays = difference.inDays;
      int countHours = difference.inHours - (countDays * 24);

      if (countDays == 0) {
        countDays = 1;
      }

      int pricePerDay = widget.rent.car!.locationFees;
      int priceStandard = widget.rent.price;

      if (countHours > 12) {
        countDays = countDays + 1;

        priceStandard = pricePerDay * countDays;
      } else if (countHours > 0) {
        double pricePerHour = (pricePerDay / 24) * countHours;

        priceStandard = (pricePerDay * countDays) + pricePerHour.toInt();
      } else {
        priceStandard = pricePerDay * countDays;
      }

      setState(() {
        daysController.text = countDays.toString();
        hoursController.text = countHours.toString();
        isLoading = true;
      });

      // Calculate discount
      final (reduction, percent) = await RentService()
          .calculateRentDiscount(price: priceStandard, days: countDays);

      setState(() {
        isLoading = false;
        priceController.text = (priceStandard - reduction).toString();
      });
    }
  }

  Future<void> updateRent(context,
      {String? startDate,
      String? endDate,
      int? deposit,
      required int state}) async {
    BottomSheetHelper.showLoadingModalSheet(context, "Traitement en cours...");
    bool isSuccess = await RentService().updateRent(
      rentId: widget.rent.id,
      endDate: endDate,
      startDate: startDate,
      state: state,
      deposit: deposit,
      carId: widget.rent.car!.id,
    );
    Navigator.pop(context);
    if (isSuccess) {
      SnackBarHelper.showCustomSnackBar(
          context, "Location mise à jour avec succès.",
          backgroundColor: Colors.green);
      setState(() {
        rentState = state;
      });
    } else {
      SnackBarHelper.showCustomSnackBar(context,
          "Une erreur s'est produite lors de la mise à jour. Veuillez réessayer.");
    }
  }

  Widget _buildSendLocationForm(context) {
    return Form(
      key: sendLocationKeyForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Dimensions.verticalSpacer(5),
          const Text(
            "Numéro de téléphone *",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomTextField(
            controller: phoneController,
            value: phoneController.text,
            keyboardType: TextInputType.number,
            hintText: 'Numéro de téléphone',
            errorMessage: "Le numéro de téléphone est obligatoire",
            maxLength: 10,
          ),
          Dimensions.verticalSpacer(10),
          RoundedButton(
            isActive: true,
            color: AppColors.primaryColor,
            textColor: Colors.white,
            text: 'Envoyer',
            onPressed: () {
              if (sendLocationKeyForm.currentState!.validate()) {}
            },
          )
        ],
      ),
    );
  }
}
