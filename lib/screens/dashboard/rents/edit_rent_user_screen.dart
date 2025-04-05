import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loccar_agency/models/rent_user.dart';
import 'package:loccar_agency/services/rent.dart';
import 'package:loccar_agency/utils/bottom_sheet_helper.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/helpers.dart';
import 'package:loccar_agency/utils/image_picker.dart';
import 'package:loccar_agency/utils/snack_bar_helper.dart';
import 'package:loccar_agency/widgets/buttons/rounded_button.dart';
import 'package:loccar_agency/widgets/textfields/custom_date_picker.dart';
import 'package:loccar_agency/widgets/textfields/custom_text_field.dart';

class EditRentUserScreen extends StatefulWidget {
  final RentUserModel rentUser;
  const EditRentUserScreen({super.key, required this.rentUser});

  @override
  State<EditRentUserScreen> createState() => _EditRentUserScreenState();
}

class _EditRentUserScreenState extends State<EditRentUserScreen> {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController cniController = TextEditingController();
  TextEditingController driverLicenseExpiryDateController =
      TextEditingController();

  File? cniFile;
  File? driverLicenseFile;

  GlobalKey<FormState> keyForm = GlobalKey();

  @override
  void initState() {
    super.initState();

    fullnameController.text = widget.rentUser.userName;
    cniController.text = widget.rentUser.nicNumber ?? "";
    driverLicenseExpiryDateController.text =
        widget.rentUser.driverLicenseExpiryDate ?? "";
    setState(() {});
    loadFiles();
  }

  Future<void> loadFiles() async {
    if (widget.rentUser.nicFile != null) {
      cniFile = await Helpers.createFileFromRemoteUrl(
          "${Constants.baseUrl}/${widget.rentUser.nicFile}");
    }
    if (widget.rentUser.driverLicense != null) {
      cniFile = await Helpers.createFileFromRemoteUrl(
          "${Constants.baseUrl}/${widget.rentUser.driverLicense}");
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editer les documents"),
      ),
      body: Form(
        key: keyForm,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nom complet du locataire *",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Dimensions.verticalSpacer(5),
                CustomTextField(
                  controller: fullnameController,
                  value: fullnameController.text,
                  hintText: 'Saisissez le nom complet du locataire',
                  maxLength: 30,
                  errorMessage: "Le nom complet du locataire est obligatoire",
                ),
                Dimensions.verticalSpacer(10),
                const Text(
                  "Numéro de la pièce d'identité *",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Dimensions.verticalSpacer(5),
                CustomTextField(
                  controller: cniController,
                  value: cniController.text,
                  hintText: "Saisissez le numéro de la pièce d'identité",
                  maxLength: 30,
                ),
                Dimensions.verticalSpacer(10),
                DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    child: Center(
                        child: cniFile == null
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Photo de la pièce",
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
                                          image: FileImage(cniFile!))),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Positioned(
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                cniFile = null;
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
                Dimensions.verticalSpacer(10),
                DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    child: Center(
                        child: driverLicenseFile == null
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Photo du permis de conduire",
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
                                              FileImage(driverLicenseFile!))),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Positioned(
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                driverLicenseFile = null;
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
                Dimensions.verticalSpacer(10),
                const Text(
                  "Date d'expiration du permis",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Dimensions.verticalSpacer(10),
                CustomDatePicker(
                    controller: driverLicenseExpiryDateController,
                    value: driverLicenseExpiryDateController.text,
                    hintText: "Choisir la date d'expiration",
                    enabled: true,
                    onlyDate: true,
                    maxLength: 25,
                    onDatePicked: (DateTime? value) {
                      if (value != null) {
                        setState(() {
                          driverLicenseExpiryDateController.text =
                              Helpers.formatDateTimeToDate(value, lang: "en");
                        });
                      }
                    }),
                Visibility(
                    visible: driverLicenseExpiryDateController.text.isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Dimensions.verticalSpacer(10),
                        const Text(
                          "Date d'expiration du permis",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Dimensions.verticalSpacer(5),
                        Text(
                          Helpers.getDiffBetweenDates(DateTime.parse(
                                  driverLicenseExpiryDateController.text))
                              .$1,
                          style: TextStyle(
                              fontSize: 18,
                              color: Helpers.getDiffBetweenDates(DateTime.parse(
                                      driverLicenseExpiryDateController.text))
                                  .$3),
                        )
                      ],
                    )),
                Dimensions.verticalSpacer(10),
                RoundedButton(
                  isActive: true,
                  color: AppColors.primaryColor,
                  textColor: Colors.white,
                  text: 'Mettre à jour',
                  onPressed: () {
                    if (keyForm.currentState!.validate()) {
                      updateDocuments(context);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
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
      cniFile = selectedImage;
    } else {
      driverLicenseFile = selectedImage;
    }

    setState(() {});
  }

  Future<void> updateDocuments(context) async {
    BottomSheetHelper.showLoadingModalSheet(context, "Mise à jour en cours...");
    bool isSuccess = await RentService().updateUserRent(
      userId: widget.rentUser.id,
      userName: fullnameController.text,
      nicNumber: cniController.text,
      driverLicenseExpiryDate: driverLicenseExpiryDateController.text,
      nicFile: cniFile,
      driverLicense: driverLicenseFile,
    );
    Navigator.pop(context);
    if (isSuccess) {
      SnackBarHelper.showCustomSnackBar(
          context, "Documents mis à jour avec succès.",
          backgroundColor: Colors.green);
    } else {
      SnackBarHelper.showCustomSnackBar(context,
          "Une erreur s'est produite lors de la mise à jour. Veuillez réessayer.");
    }
  }
}
