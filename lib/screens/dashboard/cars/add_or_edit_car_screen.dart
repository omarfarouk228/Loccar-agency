import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loccar_agency/models/car.dart';
import 'package:loccar_agency/models/category.dart';
import 'package:loccar_agency/models/country.dart';
import 'package:loccar_agency/models/owner.dart';
import 'package:loccar_agency/services/car.dart';
import 'package:loccar_agency/services/other.dart';
import 'package:loccar_agency/services/owner.dart';
import 'package:loccar_agency/utils/bottom_sheet_helper.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/helpers.dart';
import 'package:loccar_agency/utils/image_picker.dart';
import 'package:loccar_agency/utils/snack_bar_helper.dart';
import 'package:loccar_agency/widgets/cool_stepper/cool_stepper.dart';
import 'package:loccar_agency/widgets/cool_stepper/models/cool_step.dart';
import 'package:loccar_agency/widgets/cool_stepper/models/cool_stepper_config.dart';
import 'package:loccar_agency/widgets/textfields/custom_date_picker.dart';
import 'package:loccar_agency/widgets/textfields/custom_dropdown_field.dart';
import 'package:loccar_agency/widgets/textfields/custom_search_field.dart';
import 'package:loccar_agency/widgets/textfields/custom_text_field.dart';

class AddOrEditCarScreen extends StatefulWidget {
  final CarModel? car;
  const AddOrEditCarScreen({super.key, this.car});

  @override
  State<AddOrEditCarScreen> createState() => _AddOrEditCarScreenState();
}

class _AddOrEditCarScreenState extends State<AddOrEditCarScreen> {
  GlobalKey<FormState> step1KeyForm = GlobalKey();
  GlobalKey<FormState> step2KeyForm = GlobalKey();
  GlobalKey<FormState> step3KeyForm = GlobalKey();
  GlobalKey<FormState> step4KeyForm = GlobalKey();

  List<OwnerModel> owners = [];
  List<CategoryModel> categories = [];
  List<Country> countriesCode = [];
  List<String> carsType = [
    "Petits porteurs",
    "Gros porteurs",
  ];
  List<String> transmissions = [
    "Manuelle",
    "Automatique",
  ];
  List<String> cylinders = [
    "4 cylindres",
    "6 cylindres",
    "8 cylindres",
    "12 cylindres",
  ];

  // General fields
  OwnerModel? selectedOwner;
  CategoryModel? selectedCategory;
  Country? selectedCountry;
  String selectedCarType = "Petits porteurs";
  String selectedTransmission = "Manuelle";
  String selectedCylinder = "4 cylindres";
  TextEditingController placesController = TextEditingController();
  TextEditingController doorsController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  TextEditingController plateSerieController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController seatNumberController = TextEditingController();
  TextEditingController grayCardNumberController = TextEditingController();

  bool isGeoLocationEnabled = false;
  bool isConditionerEnabled = false;
  bool isOnShopEnabled = false;
  bool isOnRentalEnabled = false;
  bool isFeaturedEnabled = false;

  TextEditingController rentFeesController = TextEditingController();
  TextEditingController shopFeesController = TextEditingController();

  bool availableFor2Hours = false;
  bool availableFor6Hours = false;
  bool availableFor12Hours = false;
  bool availableForADay = false;

  TextEditingController descriptionController = TextEditingController();
  File? grayCardFile;
  List<File> carImages = [];

  TextEditingController startDateFeatureController = TextEditingController();
  TextEditingController countDaysFeatureController = TextEditingController();

  // Assurance's fields
  File? assuranceFile;
  TextEditingController assuranceIssueDateController = TextEditingController();
  TextEditingController assuranceExpiryDateController = TextEditingController();

  // Technical visit's fields
  File? technicalVisitFile;
  TextEditingController technicalVisitIssueDateController =
      TextEditingController();
  TextEditingController technicalVisitExpiryDateController =
      TextEditingController();

  // TVM's fields
  File? tvmFile;
  TextEditingController tvmIssueDateController = TextEditingController();
  TextEditingController tvmExpiryDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getData());
  }

  Future<void> _getData() async {
    placesController.text = widget.car?.places.toString() ?? "5";
    doorsController.text = widget.car?.doors.toString() ?? "4";
    owners = await OwnerService().fetchOwners();
    categories = await CarService().fetchCategories();
    countriesCode = await OtherService().fetchCountries();

    if (widget.car != null) {
      selectedOwner =
          owners.firstWhere((element) => element.id == widget.car?.ownerId);
      selectedCategory = categories
          .firstWhere((element) => element.id == widget.car?.categoryId);
      selectedCountry = countriesCode.firstWhere((element) =>
          element.isoCode.toUpperCase() == widget.car?.plateCountry);
      selectedCarType = widget.car?.caracteristique == null
          ? "Petits porteurs"
          : "Gros porteurs";
      selectedTransmission = widget.car?.transmission ?? "Manuelle";
      selectedCylinder = widget.car?.engine ?? "4 cylindres";
      placesController.text = widget.car?.places.toString() ?? "5";
      doorsController.text = widget.car?.doors.toString() ?? "4";
      plateNumberController.text = widget.car?.plateNumber ?? "";
      plateSerieController.text = widget.car?.plateSeries ?? "";
      brandController.text = widget.car?.brand ?? "";
      modelController.text = widget.car?.model ?? "";
      colorController.text = widget.car?.color ?? "";
      yearController.text = widget.car?.year.toString() ?? "";
      seatNumberController.text = widget.car?.chassisNumber.toString() ?? "";
      grayCardNumberController.text = widget.car?.grayCardNumber ?? "";
      isGeoLocationEnabled = widget.car?.geolocation ?? false;
      isConditionerEnabled = widget.car?.airConditioner ?? false;
      isOnShopEnabled = widget.car?.isOnShop ?? false;
      isOnRentalEnabled = widget.car?.isOnLocation ?? false;
      isFeaturedEnabled = widget.car!.popularDays == null ? false : true;
      rentFeesController.text = widget.car?.locationFees.toString() ?? "";
      shopFeesController.text = widget.car?.shopFees.toString() ?? "";
      availableFor2Hours = widget.car?.twoHours ?? false;
      availableFor6Hours = widget.car?.sixHours ?? false;
      availableFor12Hours = widget.car?.twelveHours ?? false;
      availableForADay = widget.car?.days ?? false;
      descriptionController.text =
          widget.car?.comment == null ? "" : widget.car!.comment!;
      // carImages = widget.car?.images ?? [];
      startDateFeatureController.text = widget.car?.popularStartDate == null
          ? ""
          : widget.car?.popularStartDate.toString() ?? "";
      countDaysFeatureController.text = widget.car?.popularDays == null
          ? ""
          : widget.car?.popularDays.toString() ?? "";
      assuranceIssueDateController.text = widget.car?.assuranceIssueDate == null
          ? ""
          : widget.car?.assuranceIssueDate.toString() ?? "";
      assuranceExpiryDateController.text =
          widget.car?.assuranceExpiryDate == null
              ? ""
              : widget.car?.assuranceExpiryDate.toString() ?? "";
      technicalVisitIssueDateController.text =
          widget.car?.technicalVisitIssueDate == null
              ? ""
              : widget.car?.technicalVisitIssueDate.toString() ?? "";
      technicalVisitExpiryDateController.text =
          widget.car?.technicalVisitExpiryDate == null
              ? ""
              : widget.car?.technicalVisitExpiryDate.toString() ?? "";
      tvmIssueDateController.text = widget.car?.tvmIssueDate == null
          ? ""
          : widget.car?.tvmIssueDate.toString() ?? "";
      tvmExpiryDateController.text = widget.car?.tvmExpiryDate == null
          ? ""
          : widget.car?.tvmExpiryDate.toString() ?? "";

      grayCardFile = await Helpers.createFileFromRemoteUrl(
          "${Constants.baseUrl}/${widget.car!.grayCard}");
      for (var photo in widget.car!.carPhotos) {
        carImages.add(await Helpers.createFileFromRemoteUrl(
            "${Constants.baseUrl}/${photo.carPhoto}") as File);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.car == null ? "Ajouter une voiture" : "Editer une voiture"),
      ),
      body: CoolStepper(
          showErrorSnackbar: true,
          onCompleted: () {
            handleCarForm(context);
          },
          config: const CoolStepperConfig(
              backText: "Précédent",
              nextText: "Suivant",
              finalText: "Terminer",
              stepText: "Étape",
              ofText: "sur"),
          steps: [
            CoolStep(
                title: "Étape 1",
                subtitle: "Veuillez renseigner les informations de la voiture",
                content: _buildStep1Form(),
                validation: () {
                  if (!step1KeyForm.currentState!.validate() ||
                      grayCardFile == null ||
                      selectedOwner == null ||
                      selectedCategory == null) {
                    return "Veuillez renseigner tous les champs";
                  }
                  return null;
                }),
            CoolStep(
                title: "Étape 2",
                subtitle: "Veuillez renseigner les informations de l'assurance",
                content: _buildStep2Form(),
                validation: () {
                  if (!step2KeyForm.currentState!.validate()) {
                    return "Veuillez renseigner tous les champs";
                  }

                  return null;
                }),
            CoolStep(
                title: "Étape 3",
                subtitle:
                    "Veuillez renseigner les informations de la visite technique",
                content: _buildStep3Form(),
                validation: () {
                  if (!step3KeyForm.currentState!.validate()) {
                    return "Veuillez renseigner tous les champs";
                  }
                  return null;
                }),
            CoolStep(
                title: "Étape 4",
                subtitle: "Veuillez renseigner les informations de la TVM",
                content: _buildStep4Form(),
                validation: () {
                  if (!step4KeyForm.currentState!.validate()) {
                    return "Veuillez renseigner tous les champs";
                  }
                  return null;
                }),
          ]),
    );
  }

  Widget _buildStep1Form() {
    return Form(
        key: step1KeyForm,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Propriétaire de la voiture*",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomSearchField<OwnerModel>(
            displayStringForOption: (OwnerModel owner) => owner.fullName,
            initialValue: selectedOwner,
            hintText: 'Choisir',
            items: owners,
            onChanged: (OwnerModel value) {
              selectedOwner = value;
              setState(() {});
            },
          ),
          Dimensions.verticalSpacer(15),
          const Text(
            "Type de voiture *",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomDropButton<String>(
            hintText: 'Choisir',
            options: carsType,
            onChanged: (value) {
              setState(() {
                selectedCarType = value.toString();
              });
            },
            height: 60,
            active: true,
            currentValue: selectedCarType,
            displayStringForOption: (String item) => item,
          ),
          Dimensions.verticalSpacer(15),
          const Text(
            "Catégorie de la voiture*",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomSearchField<CategoryModel>(
            displayStringForOption: (CategoryModel category) => category.name,
            initialValue: selectedCategory,
            hintText: 'Choisir',
            items: categories,
            onChanged: (CategoryModel value) {
              selectedCategory = value;
              setState(() {});
            },
          ),
          Dimensions.verticalSpacer(15),
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    "Nombre de places *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Dimensions.verticalSpacer(5),
                  CustomTextField(
                    controller: placesController,
                    value: placesController.text,
                    hintText: 'Saisissez le nombre de places',
                    maxLength: 30,
                    height: 60,
                    keyboardType: TextInputType.number,
                    errorMessage: "Le nombre de places est obligatoire",
                  ),
                ])),
            Dimensions.horizontalSpacer(10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    "Nombre de portières *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Dimensions.verticalSpacer(5),
                  CustomTextField(
                    controller: doorsController,
                    value: doorsController.text,
                    keyboardType: TextInputType.number,
                    hintText: 'Saisissez le nombre de portières',
                    maxLength: 30,
                    height: 60,
                    errorMessage: "Le nombre de portières est obligatoire",
                  ),
                ])),
          ]),
          Dimensions.verticalSpacer(10),
          const Divider(),
          Dimensions.verticalSpacer(10),
          const Center(
              child: Text("Numéro complet de plaque de la voiture",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
          Dimensions.verticalSpacer(10),
          Row(children: [
            SizedBox(
                width: Dimensions.getScreenWidth(context) * 0.25,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pays *",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Dimensions.verticalSpacer(5),
                      CustomSearchField<Country>(
                        displayStringForOption: (Country country) =>
                            country.isoCode.toUpperCase(),
                        initialValue: selectedCountry,
                        hintText: 'Choisir',
                        items: countriesCode,
                        onChanged: (Country value) {
                          selectedCountry = value;
                          setState(() {});
                        },
                      ),
                    ])),
            Dimensions.horizontalSpacer(10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    "Numéro *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Dimensions.verticalSpacer(5),
                  CustomTextField(
                    controller: plateNumberController,
                    value: plateNumberController.text,
                    hintText: 'Saisissez le numéro',
                    maxLength: 10,
                    height: 60,
                    keyboardType: TextInputType.number,
                    errorMessage: "Le numéro est obligatoire",
                  ),
                ])),
            Dimensions.horizontalSpacer(10),
            SizedBox(
                width: Dimensions.getScreenWidth(context) * 0.15,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Série *",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Dimensions.verticalSpacer(5),
                      CustomTextField(
                        controller: plateSerieController,
                        value: plateSerieController.text,
                        hintText: 'AA',
                        height: 60,
                        maxLength: 2,
                        errorMessage: "La série est obligatoire",
                      ),
                    ])),
          ]),
          Dimensions.verticalSpacer(15),
          const Text(
            "Marque de la voiture *",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomTextField(
            controller: brandController,
            value: brandController.text,
            hintText: 'Saisissez la marque de la voiture',
            maxLength: 30,
            height: 60,
            errorMessage: "La marque de la voiture est obligatoire",
          ),
          Dimensions.verticalSpacer(15),
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    "Modèle *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Dimensions.verticalSpacer(5),
                  CustomTextField(
                    controller: modelController,
                    value: modelController.text,
                    hintText: 'BMX',
                    maxLength: 10,
                    height: 60,
                    errorMessage: "Le modèle est obligatoire",
                  ),
                ])),
            Dimensions.horizontalSpacer(10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    "Couleur *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Dimensions.verticalSpacer(5),
                  CustomTextField(
                    controller: colorController,
                    value: colorController.text,
                    hintText: 'Blanc',
                    maxLength: 10,
                    height: 60,
                    errorMessage: "La couleur est obligatoire",
                  ),
                ])),
            Dimensions.horizontalSpacer(10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    "Année *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Dimensions.verticalSpacer(5),
                  CustomTextField(
                    controller: yearController,
                    value: yearController.text,
                    hintText: '2022',
                    height: 60,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    errorMessage: "L'année est obligatoire",
                  ),
                ]))
          ]),
          Dimensions.verticalSpacer(15),
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    "N° de carte grise *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Dimensions.verticalSpacer(5),
                  CustomTextField(
                    controller: grayCardNumberController,
                    value: grayCardNumberController.text,
                    hintText: 'Numéro de carte grise',
                    maxLength: 10,
                    height: 60,
                    errorMessage: "Le numéro de carte grise est obligatoire",
                  ),
                ])),
            Dimensions.horizontalSpacer(10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    "N° de chassis *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Dimensions.verticalSpacer(5),
                  CustomTextField(
                    controller: seatNumberController,
                    value: seatNumberController.text,
                    hintText: 'Numéro de chassis',
                    maxLength: 10,
                    height: 60,
                    errorMessage: "Le numéro de chassis est obligatoire",
                  ),
                ])),
          ]),
          Dimensions.verticalSpacer(15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: isGeoLocationEnabled,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          isGeoLocationEnabled = value!;
                        });
                      }),
                  const Text("Géolocalisation")
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: isConditionerEnabled,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          isConditionerEnabled = value!;
                        });
                      }),
                  const Text("Climatisée")
                ],
              ),
            )
          ]),
          Dimensions.verticalSpacer(5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: isOnShopEnabled,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          isOnShopEnabled = value!;
                        });
                      }),
                  const Text("Vente")
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: isOnRentalEnabled,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          isOnRentalEnabled = value!;
                        });
                      }),
                  const Text("Location")
                ],
              ),
            )
          ]),
          Dimensions.verticalSpacer(5),
          Row(
            children: [
              Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: isFeaturedEnabled,
                  activeColor: AppColors.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      isFeaturedEnabled = value!;
                    });
                  }),
              const Text("Cochez si cette voiture est une voiture populaire.")
            ],
          ),
          Dimensions.verticalSpacer(5),
          isFeaturedEnabled
              ? Column(
                  children: [
                    const Card(
                        margin: EdgeInsets.zero,
                        elevation: 3,
                        color: Colors.green,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Les frais pour ce service est au totale 1000 fcfa pour 1 jours.",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )),
                    Dimensions.verticalSpacer(10),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              const Text(
                                "Début *",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Dimensions.verticalSpacer(5),
                              CustomDatePicker(
                                  controller: startDateFeatureController,
                                  value: startDateFeatureController.text,
                                  hintText: 'JJ/MM/AAAA HH:MM',
                                  enabled: false,
                                  onlyDate: false,
                                  maxLength: 2,
                                  onDatePicked: (value) {
                                    setState(() {
                                      startDateFeatureController.text =
                                          Helpers.formatDateTimeToString(value);
                                    });
                                  }),
                            ])),
                        Dimensions.horizontalSpacer(10),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              const Text(
                                "Nombre de jours *",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Dimensions.verticalSpacer(5),
                              CustomTextField(
                                controller: countDaysFeatureController,
                                value: countDaysFeatureController.text,
                                keyboardType: TextInputType.number,
                                hintText: 'Nombre de jours',
                                errorMessage:
                                    "Le nombre de jours est obligatoire",
                                maxLength: 2,
                              ),
                            ]))
                      ],
                    )
                  ],
                )
              : const Center(),
          Dimensions.verticalSpacer(15),
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    "Transmission *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Dimensions.verticalSpacer(5),
                  CustomDropButton<String>(
                    hintText: 'Choisir',
                    options: transmissions,
                    onChanged: (value) {
                      setState(() {
                        selectedTransmission = value.toString();
                      });
                    },
                    height: 60,
                    active: true,
                    currentValue: selectedTransmission,
                    displayStringForOption: (String item) => item,
                  ),
                ])),
            Dimensions.horizontalSpacer(10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    "Moteur *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Dimensions.verticalSpacer(5),
                  CustomDropButton<String>(
                    hintText: 'Choisir',
                    options: cylinders,
                    onChanged: (value) {
                      setState(() {
                        selectedCylinder = value.toString();
                      });
                    },
                    height: 60,
                    active: true,
                    currentValue: selectedCylinder,
                    displayStringForOption: (String item) => item,
                  ),
                ])),
          ]),
          Dimensions.verticalSpacer(15),
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    "Frais de location",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Dimensions.verticalSpacer(5),
                  CustomTextField(
                      controller: rentFeesController,
                      value: rentFeesController.text,
                      hintText: 'Frais de location',
                      maxLength: 10,
                      height: 60,
                      keyboardType: TextInputType.number),
                ])),
            Dimensions.horizontalSpacer(10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    "Frais de vente",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Dimensions.verticalSpacer(5),
                  CustomTextField(
                      controller: shopFeesController,
                      value: shopFeesController.text,
                      hintText: 'Frais de vente',
                      maxLength: 10,
                      height: 60,
                      keyboardType: TextInputType.number),
                ])),
          ]),
          Dimensions.verticalSpacer(15),
          const Text(
            "Disponible a partir de:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: availableFor2Hours,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          availableFor2Hours = value!;
                        });
                      }),
                  const Text("2H")
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: availableFor6Hours,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          availableFor6Hours = value!;
                        });
                      }),
                  const Text("6H")
                ],
              ),
            )
          ]),
          Dimensions.verticalSpacer(5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: availableFor12Hours,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          availableFor12Hours = value!;
                        });
                      }),
                  const Text("12H")
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: availableForADay,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          availableForADay = value!;
                        });
                      }),
                  const Text("Jour(s)")
                ],
              ),
            )
          ]),
          Dimensions.verticalSpacer(15),
          const Text(
            "Commentaire",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomTextField(
              controller: descriptionController,
              value: descriptionController.text,
              hintText: 'Saisissez le commentaire',
              maxLength: 30,
              height: 60),
          Dimensions.verticalSpacer(15),
          DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              padding: const EdgeInsets.all(6),
              child: Center(
                  child: carImages.isEmpty
                      ? GestureDetector(
                          onTap: () async {
                            final selectedImages =
                                await ImagePickerHelper.choosePhotos();
                            carImages.addAll(selectedImages);
                            setState(() {});
                          },
                          child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(15),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Photos de la voiture",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Dimensions.verticalSpacer(5),
                                  const Text(
                                    "Taille maximale : 5mb",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              )),
                        )
                      : SizedBox(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ...carImages
                                  .map((image) => Card(
                                        child: Container(
                                          height: 80,
                                          width: Dimensions.getScreenWidth(
                                                  context) /
                                              (carImages.length + 1),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: FileImage(image))),
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      carImages.remove(image);
                                                    });
                                                  },
                                                  child: const FaIcon(
                                                    FontAwesomeIcons.xmark,
                                                    color: Colors.white,
                                                    size: 35,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              GestureDetector(
                                onTap: () async {
                                  final selectedImages =
                                      await ImagePickerHelper.choosePhotos();
                                  carImages.addAll(selectedImages);
                                  setState(() {});
                                },
                                child: const CircleAvatar(
                                  radius: 20,
                                  child: FaIcon(FontAwesomeIcons.plus),
                                ),
                              )
                            ],
                          ),
                        ))),
          Dimensions.verticalSpacer(30),
          DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              padding: const EdgeInsets.all(6),
              child: Center(
                  child: grayCardFile == null
                      ? GestureDetector(
                          onTap: () {
                            _showPicker(context, 1);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(15),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Charger la photo de la carte*",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Dimensions.verticalSpacer(5),
                                  const Text(
                                    "Taille maximale : 5mb",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              )),
                        )
                      : Card(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(grayCardFile!))),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Positioned(
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          grayCardFile = null;
                                        });
                                      },
                                      child: const FaIcon(
                                        FontAwesomeIcons.xmark,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ))),
          Dimensions.verticalSpacer(30),
        ]));
  }

  Widget _buildStep2Form() {
    return Form(
        key: step2KeyForm,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Date de délivrance assurance *",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomDatePicker(
              controller: assuranceIssueDateController,
              value: assuranceIssueDateController.text,
              hintText: 'JJ/MM/AAAA',
              enabled: false,
              maxLength: 2,
              onDatePicked: (value) {
                setState(() {
                  assuranceIssueDateController.text =
                      Helpers.formatDateTimeToDate(value!, separator: "/");
                });
              }),
          Dimensions.verticalSpacer(15),
          const Text(
            "Date d'expiration assurance *",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomDatePicker(
              controller: assuranceExpiryDateController,
              value: assuranceExpiryDateController.text,
              hintText: 'JJ/MM/AAAA',
              enabled: false,
              maxLength: 2,
              onDatePicked: (value) {
                setState(() {
                  assuranceExpiryDateController.text =
                      Helpers.formatDateTimeToDate(value!, separator: "/");
                });
              }),
          Dimensions.verticalSpacer(15),
          DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              padding: const EdgeInsets.all(6),
              child: Center(
                  child: assuranceFile == null
                      ? GestureDetector(
                          onTap: () {
                            _showPicker(context, 2);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(15),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Charger la photo de l'assurance",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Dimensions.verticalSpacer(5),
                                  const Text(
                                    "Taille maximale : 5mb",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              )),
                        )
                      : Card(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(assuranceFile!))),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Positioned(
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          assuranceFile = null;
                                        });
                                      },
                                      child: const FaIcon(
                                        FontAwesomeIcons.xmark,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ))),
        ]));
  }

  Widget _buildStep3Form() {
    return Form(
        key: step3KeyForm,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Date de délivrance visite technique *",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomDatePicker(
            controller: technicalVisitIssueDateController,
            value: technicalVisitIssueDateController.text,
            hintText: 'JJ/MM/AAAA',
            enabled: false,
            maxLength: 2,
            onDatePicked: (value) {
              setState(() {
                technicalVisitIssueDateController.text =
                    Helpers.formatDateTimeToDate(value!, separator: "/");
              });
            },
          ),
          Dimensions.verticalSpacer(15),
          const Text(
            "Date d'expiration visite technique *",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomDatePicker(
            controller: technicalVisitExpiryDateController,
            value: technicalVisitExpiryDateController.text,
            hintText: 'JJ/MM/AAAA',
            enabled: false,
            maxLength: 2,
            onDatePicked: (value) {
              setState(() {
                technicalVisitExpiryDateController.text =
                    Helpers.formatDateTimeToDate(value!, separator: "/");
              });
            },
          ),
          Dimensions.verticalSpacer(15),
          DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              padding: const EdgeInsets.all(6),
              child: Center(
                  child: technicalVisitFile == null
                      ? GestureDetector(
                          onTap: () {
                            _showPicker(context, 3);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(15),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Charger la photo de l'assurance",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Dimensions.verticalSpacer(5),
                                  const Text(
                                    "Taille maximale : 5mb",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              )),
                        )
                      : Card(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(technicalVisitFile!))),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Positioned(
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          technicalVisitFile = null;
                                        });
                                      },
                                      child: const FaIcon(
                                        FontAwesomeIcons.xmark,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ))),
        ]));
  }

  Widget _buildStep4Form() {
    return Form(
        key: step4KeyForm,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Date de délivrance TVM *",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomDatePicker(
            controller: tvmIssueDateController,
            value: tvmIssueDateController.text,
            hintText: 'JJ/MM/AAAA',
            enabled: false,
            maxLength: 2,
            onDatePicked: (value) {
              setState(() {
                tvmIssueDateController.text =
                    Helpers.formatDateTimeToDate(value!, separator: "/");
              });
            },
          ),
          Dimensions.verticalSpacer(15),
          const Text(
            "Date d'expiration TVM *",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomDatePicker(
            controller: tvmExpiryDateController,
            value: tvmExpiryDateController.text,
            hintText: 'JJ/MM/AAAA',
            enabled: false,
            maxLength: 2,
            onDatePicked: (value) {
              setState(() {
                tvmExpiryDateController.text =
                    Helpers.formatDateTimeToDate(value!, separator: "/");
              });
            },
          ),
          Dimensions.verticalSpacer(15),
          DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              padding: const EdgeInsets.all(6),
              child: Center(
                  child: tvmFile == null
                      ? GestureDetector(
                          onTap: () {
                            _showPicker(context, 4);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(15),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Charger la photo de l'assurance",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Dimensions.verticalSpacer(5),
                                  const Text(
                                    "Taille maximale : 5mb",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              )),
                        )
                      : Card(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(tvmFile!))),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Positioned(
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          tvmFile = null;
                                        });
                                      },
                                      child: const FaIcon(
                                        FontAwesomeIcons.xmark,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ))),
        ]));
  }

  void _showPicker(context, int type) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Téléverser une photo'),
                    onTap: () {
                      pickImage(ImageSource.gallery, type);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    pickImage(ImageSource.camera, type);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void pickImage(ImageSource source, int type) async {
    final selectedImage = await ImagePickerHelper.choosePhoto(source);
    if (type == 1) {
      grayCardFile = selectedImage;
    } else if (type == 2) {
      assuranceFile = selectedImage;
    } else if (type == 3) {
      technicalVisitFile = selectedImage;
    } else if (type == 4) {
      tvmFile = selectedImage;
    }
    setState(() {});
  }

  Future<void> handleCarForm(context) async {
    BottomSheetHelper.showLoadingModalSheet(context,
        widget.car != null ? "Mise à jour en cours..." : "Ajout en cours...");
    bool isSuccess = await CarService().addOrUpdateCar(
        ownerId: selectedOwner!.id,
        categoryId: selectedCategory!.id,
        plateCountry: selectedCountry!.isoCode.toUpperCase(),
        plateNumber: plateNumberController.text,
        plateSeries: plateSerieController.text,
        brand: brandController.text,
        model: modelController.text,
        color: colorController.text,
        year: yearController.text,
        grayCardNumber: grayCardNumberController.text,
        grayCard: grayCardFile!,
        chassisNumber: seatNumberController.text,
        geolocation: isGeoLocationEnabled ? 1 : 0,
        isOnLocation: isOnRentalEnabled ? 1 : 0,
        transmission: selectedTransmission,
        engine: selectedCylinder,
        places: int.parse(placesController.text),
        doors: int.parse(doorsController.text),
        assuranceIsueDate: assuranceIssueDateController.text,
        assuranceExpiryDate: assuranceExpiryDateController.text,
        assurance: assuranceFile,
        technicalVisitIsueDate: technicalVisitIssueDateController.text,
        technicalVisitExpiryDate: technicalVisitExpiryDateController.text,
        technicalVisit: technicalVisitFile,
        tvmIsueDate: tvmIssueDateController.text,
        tvmExpiryDate: tvmExpiryDateController.text,
        tvm: tvmFile,
        locationFees: rentFeesController.text.isNotEmpty
            ? double.parse(rentFeesController.text)
            : null,
        twoHours: availableFor2Hours ? 1 : 0,
        sixHours: availableFor6Hours ? 1 : 0,
        twelveHours: availableFor12Hours ? 1 : 0,
        days: availableForADay ? 1 : 0,
        shopFees: shopFeesController.text.isNotEmpty
            ? double.parse(rentFeesController.text)
            : null,
        isOnShop: isOnShopEnabled ? 1 : 0,
        isPopular: isFeaturedEnabled ? 1 : 0,
        popularStartDate: startDateFeatureController.text,
        popularDays: countDaysFeatureController.text.isNotEmpty
            ? int.parse(countDaysFeatureController.text)
            : null,
        carId: widget.car?.id,
        carPhotos: carImages);
    Navigator.pop(context);
    if (isSuccess) {
      SnackBarHelper.showCustomSnackBar(
          context,
          widget.car == null
              ? "Nouvelle voiture ajoutée avec succès."
              : "Voiture mise à jour avec succès.",
          backgroundColor: Colors.green);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
        if (widget.car != null) {
          Navigator.pop(context);
        }
      });
    } else {
      SnackBarHelper.showCustomSnackBar(context,
          "Une erreur s'est produite lors de la suppression. Veuillez réessayer.");
    }
  }
}
