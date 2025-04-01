import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loccar_agency/models/card_type.dart';
import 'package:loccar_agency/models/owner.dart';
import 'package:loccar_agency/models/user.dart';
import 'package:loccar_agency/services/other.dart';
import 'package:loccar_agency/services/owner.dart';
import 'package:loccar_agency/utils/bottom_sheet_helper.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/helpers.dart';
import 'package:loccar_agency/utils/image_picker.dart';
import 'package:loccar_agency/utils/preferences.dart';
import 'package:loccar_agency/utils/snack_bar_helper.dart';
import 'package:loccar_agency/widgets/cool_stepper/cool_stepper.dart';
import 'package:loccar_agency/widgets/cool_stepper/models/cool_step.dart';
import 'package:loccar_agency/widgets/cool_stepper/models/cool_stepper_config.dart';
import 'package:loccar_agency/widgets/textfields/custom_dropdown_field.dart';
import 'package:loccar_agency/widgets/textfields/custom_text_field.dart';

class AddOrEditOwnerScreen extends StatefulWidget {
  final OwnerModel? owner;
  const AddOrEditOwnerScreen({super.key, this.owner});

  @override
  State<AddOrEditOwnerScreen> createState() => _AddOrEditOwnerScreenState();
}

class _AddOrEditOwnerScreenState extends State<AddOrEditOwnerScreen> {
  GlobalKey<FormState> step1KeyForm = GlobalKey();
  GlobalKey<FormState> step2KeyForm = GlobalKey();
  GlobalKey<FormState> step3KeyForm = GlobalKey();
  GlobalKey<FormState> step4KeyForm = GlobalKey();
  TextEditingController cardNumberController = TextEditingController();
  List<CardTypeModel> cardsType = [];

  CardTypeModel? selectedCardType;
  File? cardImage;

  List<String> accountTypes = [
    "Compte personnel",
    "Compte entreprise",
  ];
  List<TextEditingController> additionalEmails = [];
  String selectedAccountType = "Compte personnel";
  TextEditingController fullNameController = TextEditingController();
  TextEditingController nifController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  File? companyCardImage;

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

  TextEditingController geolocationController = TextEditingController();

  UserModel? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getUser());
  }

  void _getUser() async {
    user = await SharedPreferencesHelper.getObject(
        "user", (json) => UserModel.fromJson2(json));
    countryCodeController.text = user!.countryCode!;
    cardsType = await OtherService().fetchCardTypes();

    if (widget.owner != null) {
      cardNumberController.text = widget.owner!.idCardNumber;
      selectedCardType = cardsType
          .firstWhere((element) => element.id == widget.owner!.cardTypeId);
      fullNameController.text = widget.owner!.fullName;
      cardImage = await Helpers.createFileFromRemoteUrl(
          "${Constants.baseUrl}/${widget.owner!.idCard}");

      emailController.text = widget.owner!.email;
      phoneNumberController.text = widget.owner!.phoneNumber;
      geolocationController.text = widget.owner!.geolocalisation ?? "";

      if (widget.owner!.accountType == "enterprise") {
        nifController.text = widget.owner!.professionalCardNumber!;
        fullNameController.text = widget.owner!.responsibleFullName!;
        companyNameController.text = widget.owner!.socialReason!;
        companyCardImage = await Helpers.createFileFromRemoteUrl(
            "${Constants.baseUrl}/${widget.owner!.professionalCard}");
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.owner == null
            ? "Ajouter un propriétaire"
            : "Editer un propriétaire"),
      ),
      body: CoolStepper(
        showErrorSnackbar: true,
        onCompleted: () {
          handleOwnerForm(context);
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
              subtitle: "Veuillez renseigner vos informations personnelles",
              content: _buildStep1Form(),
              validation: () {
                debugPrint("number : ${cardNumberController.text}");
                if (!step1KeyForm.currentState!.validate() ||
                    cardImage == null) {
                  return "Veuillez renseigner tous les champs";
                }
                return null;
              }),
          CoolStep(
              title: "Étape 2",
              subtitle: "Veuillez renseigner les informations du compte",
              content: _buildStep2Form(),
              validation: () {
                if (selectedAccountType == "Compte entreprise") {
                  if (!step2KeyForm.currentState!.validate() ||
                      companyCardImage == null) {
                    return "Veuillez renseigner tous les champs";
                  }
                } else {
                  if (!step2KeyForm.currentState!.validate()) {
                    return "Veuillez renseigner tous les champs";
                  }
                }

                return null;
              }),
          CoolStep(
              title: "Étape 3",
              subtitle: "Veuillez renseigner les informations de connexion",
              content: _buildStep3Form(),
              validation: () {
                if (!step3KeyForm.currentState!.validate()) {
                  return "Veuillez renseigner tous les champs";
                }
                return null;
              }),
          CoolStep(
              title: "Étape 4",
              subtitle:
                  "Veuillez renseigner les informations de géolocalisation",
              content: _buildStep4Form(),
              validation: () {
                if (!step4KeyForm.currentState!.validate()) {
                  return "Veuillez renseigner tous les champs";
                }
                return null;
              }),
        ],
      ),
    );
  }

  _buildStep1Form() {
    return Form(
      key: step1KeyForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Type de carte *",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomDropButton<CardTypeModel>(
            hintText: 'Choisir',
            options: cardsType,
            onChanged: (value) {
              setState(() {
                selectedCardType = value;
              });
            },
            active: true,
            currentValue: selectedCardType,
            displayStringForOption: (CardTypeModel card) => card.name,
          ),
          Dimensions.verticalSpacer(15),
          const Text(
            "Numéro de carte *",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomTextField(
            controller: cardNumberController,
            value: cardNumberController.text,
            hintText: 'Saisissez le numéro',
            maxLength: 30,
            errorMessage: "Le numéro est obligatoire",
          ),
          Dimensions.verticalSpacer(15),
          DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              padding: const EdgeInsets.all(6),
              child: Center(
                  child: cardImage == null
                      ? GestureDetector(
                          onTap: () {
                            _showPicker(context);
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
                                    "Charger la photo de la carte",
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
                                    image: FileImage(cardImage!))),
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
                                          cardImage = null;
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
                        )))
        ],
      ),
    );
  }

  _buildStep2Form() {
    return Form(
      key: step2KeyForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Type de compte *",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomDropButton<String>(
            hintText: 'Choisir',
            options: accountTypes,
            onChanged: (value) {
              setState(() {
                selectedAccountType = value.toString();
              });
            },
            active: true,
            currentValue: selectedAccountType,
            displayStringForOption: (String item) => item,
          ),
          Dimensions.verticalSpacer(15),
          selectedAccountType == "Compte personnel"
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nom et prénoms *",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Dimensions.verticalSpacer(5),
                    CustomTextField(
                      controller: fullNameController,
                      value: fullNameController.text,
                      hintText: 'Saisissez le nom du propriétaire',
                      maxLength: 30,
                      errorMessage: "Le nom complet est obligatoire",
                    ),
                  ],
                )
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text(
                    "Raison sociale *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Dimensions.verticalSpacer(5),
                  CustomTextField(
                    controller: companyNameController,
                    value: companyNameController.text,
                    hintText: 'Saisissez la raison sociale',
                    maxLength: 30,
                    errorMessage: "La raison sociale est obligatoire",
                  ),
                  Dimensions.verticalSpacer(15),
                  const Text(
                    "Nom et prénoms du responsable *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Dimensions.verticalSpacer(5),
                  CustomTextField(
                    controller: fullNameController,
                    value: fullNameController.text,
                    hintText: 'Saisissez le nom du responsable',
                    maxLength: 30,
                    errorMessage: "Le nom complet est obligatoire",
                  ),
                  Dimensions.verticalSpacer(15),
                  const Text(
                    "N° d'identification de l'entreprise *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Dimensions.verticalSpacer(5),
                  CustomTextField(
                    controller: nifController,
                    value: nifController.text,
                    hintText: 'Saisissez le n° d\'identification ',
                    maxLength: 30,
                    errorMessage: "Le n° d'identification est obligatoire",
                  ),
                  Dimensions.verticalSpacer(15),
                  DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      padding: const EdgeInsets.all(6),
                      child: Center(
                          child: companyCardImage == null
                              ? GestureDetector(
                                  onTap: () {
                                    _showPicker(context);
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.all(15),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Charger la photo de la carte professionnelle",
                                            textAlign: TextAlign.center,
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
                                            image:
                                                FileImage(companyCardImage!))),
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        Positioned(
                                            right: 5,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  companyCardImage = null;
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
                  Dimensions.verticalSpacer(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "E-mail(s) addionnel(s) *",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            additionalEmails.add(TextEditingController());
                          });
                        },
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: AppColors.secondaryColor,
                          child: const FaIcon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      )
                    ],
                  ),
                  Dimensions.verticalSpacer(5),
                  ...additionalEmails
                      .map(
                        (TextEditingController controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: controller,
                                  value: controller.text,
                                  hintText: 'Saisissez l\'e-mail',
                                  maxLength: 30,
                                  keyboardType: TextInputType.emailAddress,
                                  errorMessage:
                                      "L'e-mail addionnel est obligatoire",
                                ),
                              ),
                              Dimensions.horizontalSpacer(10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    additionalEmails.remove(controller);
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.red,
                                  child: FaIcon(
                                    FontAwesomeIcons.minus,
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                      .toList()
                ])
        ],
      ),
    );
  }

  Widget _buildStep3Form() {
    return Form(
        key: step3KeyForm,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "E-mail *",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomTextField(
            controller: emailController,
            value: emailController.text,
            hintText: "Saisissez l'e-mail",
            maxLength: 30,
            keyboardType: TextInputType.emailAddress,
            errorMessage: "L'e-mail est obligatoire",
          ),
          Dimensions.verticalSpacer(15),
          Row(
            children: [
              SizedBox(
                width: Dimensions.getScreenWidth(context) * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Code",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Dimensions.verticalSpacer(5),
                    CustomTextField(
                      controller: countryCodeController,
                      value: countryCodeController.text,
                      hintText: '',
                      enabled: false,
                      maxLength: 30,
                    ),
                  ],
                ),
              ),
              Dimensions.horizontalSpacer(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Numéro de téléphone",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Dimensions.verticalSpacer(5),
                    CustomTextField(
                      controller: phoneNumberController,
                      value: phoneNumberController.text,
                      keyboardType: TextInputType.phone,
                      hintText: 'Saisissez le numéro de téléphone',
                      maxLength: 30,
                      errorMessage: "Le numéro de téléphone est obligatoire",
                    ),
                  ],
                ),
              )
            ],
          )
        ]));
  }

  Widget _buildStep4Form() {
    return Form(
        key: step4KeyForm,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Géolocalisation *",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Dimensions.verticalSpacer(5),
          CustomTextField(
              controller: geolocationController,
              value: geolocationController.text,
              hintText: "Saisissez le lien de géolocalisation",
              maxLength: 30),
        ]));
  }

  void _showPicker(context) {
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
                      pickImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void pickImage(ImageSource source) async {
    final selectedImage = await ImagePickerHelper.choosePhoto(source);
    setState(() {
      cardImage = selectedImage;
    });
  }

  Future<void> handleOwnerForm(context) async {
    BottomSheetHelper.showLoadingModalSheet(context,
        widget.owner != null ? "Mise à jour en cours..." : "Ajout en cours...");
    bool isSuccess = await OwnerService().addOrUpdateOwner(
      cardTypeId: selectedCardType!.id,
      cardNumber: cardNumberController.text,
      cardFile: cardImage!,
      accountType: selectedAccountType,
      fullName: fullNameController.text,
      companyName: companyNameController.text,
      companyNif: nifController.text,
      companyCardFile: companyCardImage,
      additionalEmails: additionalEmails.map((e) => e.text).toList(),
      email: emailController.text,
      phoneNumber: phoneNumberController.text,
      geolocationLink: geolocationController.text,
      ownerId: widget.owner?.id,
    );
    Navigator.pop(context);
    if (isSuccess) {
      SnackBarHelper.showCustomSnackBar(
          context,
          widget.owner == null
              ? "Nouveau propriétaire ajouté avec succès."
              : "Propriétaire mis à jour avec succès.",
          backgroundColor: Colors.green);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
        if (widget.owner != null) {
          Navigator.pop(context);
        }
      });
    } else {
      SnackBarHelper.showCustomSnackBar(context,
          "Une erreur s'est produite lors de la suppression. Veuillez réessayer.");
    }
  }
}
