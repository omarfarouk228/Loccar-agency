import 'package:custom_accordion/custom_accordion.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/models/car.dart';
import 'package:loccar_agency/models/payment.dart';
import 'package:loccar_agency/screens/dashboard/cars/add_or_edit_car_screen.dart';
import 'package:loccar_agency/services/car.dart';
import 'package:loccar_agency/utils/assets.dart';
import 'package:loccar_agency/utils/bottom_sheet_helper.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/helpers.dart';
import 'package:loccar_agency/utils/snack_bar_helper.dart';
import 'package:loccar_agency/widgets/buttons/rounded_button.dart';
import 'package:loccar_agency/widgets/custom_cached_network_image.dart';
import 'package:loccar_agency/widgets/floating_action_buttons.dart';
import 'package:loccar_agency/widgets/textfields/custom_dropdown_field.dart';
import 'package:loccar_agency/widgets/textfields/custom_text_field.dart';

class CarDetailsScreen extends StatefulWidget {
  final CarModel car;
  const CarDetailsScreen({super.key, required this.car});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  GlobalKey<FormState> keyForm = GlobalKey();
  TextEditingController amountController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  List<String> sourceEntries = [
    "Location",
    "Course",
    "Vente",
  ];
  String selectedSource = "Location";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${widget.car.brand} ${widget.car.model} ${widget.car.year}"),
      ),
      body: Stack(
        children: [
          Container(
            height: double.maxFinite,
            margin: const EdgeInsets.only(bottom: 65),
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      BottomSheetHelper.showCustomBottomSheet(context,
                          "Historique des paiements", _buildHistory(context),
                          heightRatio: 0.6);
                    },
                    child: Card(
                      color: Colors.grey.shade300,
                      child: const ListTile(
                        title: Text("Historique"),
                        subtitle: Text("Voir l'historique des paiements"),
                        trailing: FaIcon(
                          FontAwesomeIcons.angleRight,
                        ),
                      ),
                    ),
                  ),
                  Dimensions.verticalSpacer(5),
                  _buildCarDetails(),
                  _buildOwnerDetails(),
                  _buildAssuranceSection(),
                  _buildTechnicalVisitSection(),
                  _buildTvmSection(),
                ],
              ),
            )),
          ),
          Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: CustomFloatingActionButtons(
                iconsData: [Icons.edit, Icons.delete, AppAssets.depositIcon],
                callbacks: [
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddOrEditCarScreen(car: widget.car)));
                  },
                  () {
                    showDeleteDialog(context);
                  },
                  () {
                    BottomSheetHelper.showCustomBottomSheet(
                        context, "Faire un dépôt", _buildDepositForm(context),
                        heightRatio: 0.6);
                  }
                ],
                colors: [
                  AppColors.secondaryColor,
                  Colors.red,
                  AppColors.thirdyColor
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildCarDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAccordionItem(
                label: 'Carte grise',
                value: widget.car.grayCardNumber.toString()),
            Dimensions.verticalSpacer(10),
            _buildAccordionItem(
                label: 'En location',
                value: widget.car.isOnLocation ? 'Oui' : 'Non'),
            Dimensions.verticalSpacer(10),
            _buildAccordionItem(
                label: 'En vente', value: widget.car.isOnShop ? 'Oui' : 'Non'),
            Dimensions.verticalSpacer(10),
            _buildAccordionItem(
                label: 'En course', value: widget.car.isOnRace ? 'Oui' : 'Non'),
            Dimensions.verticalSpacer(10),
            _buildAccordionItem(
                label: 'Localisation',
                value: widget.car.geolocation ? 'Oui' : 'Non'),
            Dimensions.verticalSpacer(10),
            SizedBox(
              height: 100,
              width: Dimensions.getScreenWidth(context),
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  Visibility(
                    visible: widget.car.grayCard != null,
                    child: CustomCachedNetworkImage(
                        imageUrl: "${Constants.baseUrl}/${widget.car.grayCard}",
                        height: 50,
                        width: 50,
                        borderRadius: 7.75),
                  ),
                  ...widget.car.carPhotos.map((photo) {
                    return CustomCachedNetworkImage(
                        imageUrl: "${Constants.baseUrl}/${photo.carPhoto}",
                        height: 50,
                        width: 50,
                        borderRadius: 7.75);
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerDetails() {
    return CustomAccordion(
        title: 'Propriétaire',
        subTitle: 'Informations du propriétaire',
        headerBackgroundColor: AppColors.thirdyColor,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        subTitleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        toggleIconOpen: Icons.keyboard_arrow_down_sharp,
        toggleIconClose: Icons.keyboard_arrow_up_sharp,
        headerIconColor: Colors.white,
        accordionElevation: 2,
        widgetItems: Column(
          children: [
            _buildAccordionItem(
                label: "Type de compte",
                value: widget.car.owner!.accountType == "personal"
                    ? "personnel"
                    : "professionnel"),
            Dimensions.verticalSpacer(10),
            _buildAccordionItem(
                label: "E-mail", value: widget.car.owner!.email),
            Dimensions.verticalSpacer(10),
            _buildAccordionItem(
                label: "Nom complet", value: widget.car.owner!.fullName),
            Dimensions.verticalSpacer(10),
            _buildAccordionItem(
                label: "Numéro de carte",
                value: widget.car.owner!.idCardNumber),
            Dimensions.verticalSpacer(10),
            Visibility(
              visible: widget.car.owner!.idCard.isNotEmpty,
              child: CustomCachedNetworkImage(
                  imageUrl: "${Constants.baseUrl}/${widget.car.owner!.idCard}",
                  height: 200,
                  width: double.infinity,
                  borderRadius: 7.75),
            ),
          ],
        ));
  }

  Widget _buildAssuranceSection() {
    return CustomAccordion(
      title: 'Assurance',
      subTitle:
          Helpers.getDiffBetweenDates(widget.car.assurances.first.expiryDate)
                      .$2 ==
                  0
              ? 'Expirée'
              : 'Informations de la dernière assurance',
      headerBackgroundColor: AppColors.thirdyColor,
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      subTitleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color:
            Helpers.getDiffBetweenDates(widget.car.assurances.first.expiryDate)
                        .$2 ==
                    0
                ? AppColors.secondaryColor
                : Colors.white,
      ),
      toggleIconOpen: Icons.keyboard_arrow_down_sharp,
      toggleIconClose: Icons.keyboard_arrow_up_sharp,
      headerIconColor: Colors.white,
      accordionElevation: 2,
      widgetItems: widget.car.assurances.isNotEmpty
          ? Column(
              children: [
                _buildAccordionItem(
                    label: "Status",
                    value: Helpers.getDiffBetweenDates(
                            widget.car.assurances.first.expiryDate)
                        .$1,
                    color: Helpers.getDiffBetweenDates(
                            widget.car.assurances.first.expiryDate)
                        .$3),
                Dimensions.verticalSpacer(10),
                _buildAccordionItem(
                    label: "Date de délivrance",
                    value: Helpers.formatDateTimeToDate(
                        widget.car.assurances.first.issueDate)),
                Dimensions.verticalSpacer(10),
                _buildAccordionItem(
                    label: "Date d'expiration",
                    value: Helpers.formatDateTimeToDate(
                        widget.car.assurances.first.expiryDate)),
                Dimensions.verticalSpacer(10),
                Visibility(
                  visible: widget.car.assurances.first.file.isNotEmpty,
                  child: CustomCachedNetworkImage(
                      imageUrl:
                          "${Constants.baseUrl}/${widget.car.assurances.first.file}",
                      height: 200,
                      width: double.infinity,
                      borderRadius: 7.75),
                ),
              ],
            )
          : const Text("Aucune assurance"),
    );
  }

  Widget _buildTechnicalVisitSection() {
    return CustomAccordion(
        title: 'Visite technique',
        subTitle: Helpers.getDiffBetweenDates(
                        widget.car.technicalVisits.first.expiryDate)
                    .$2 ==
                0
            ? 'Expirée'
            : 'Informations de la dernière visite',
        headerBackgroundColor: AppColors.thirdyColor,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        subTitleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Helpers.getDiffBetweenDates(
                          widget.car.technicalVisits.first.expiryDate)
                      .$2 ==
                  0
              ? AppColors.secondaryColor
              : Colors.white,
        ),
        toggleIconOpen: Icons.keyboard_arrow_down_sharp,
        toggleIconClose: Icons.keyboard_arrow_up_sharp,
        headerIconColor: Colors.white,
        accordionElevation: 2,
        widgetItems: widget.car.technicalVisits.isNotEmpty
            ? Column(
                children: [
                  _buildAccordionItem(
                      label: "Status",
                      value: Helpers.getDiffBetweenDates(
                              widget.car.technicalVisits.first.expiryDate)
                          .$1,
                      color: Helpers.getDiffBetweenDates(
                              widget.car.technicalVisits.first.expiryDate)
                          .$3),
                  Dimensions.verticalSpacer(10),
                  _buildAccordionItem(
                      label: "Date de délivrance",
                      value: Helpers.formatDateTimeToDate(
                          widget.car.technicalVisits.first.issueDate)),
                  Dimensions.verticalSpacer(10),
                  _buildAccordionItem(
                      label: "Date d'expiration",
                      value: Helpers.formatDateTimeToDate(
                          widget.car.technicalVisits.first.expiryDate)),
                  Dimensions.verticalSpacer(10),
                  Visibility(
                    visible: widget.car.technicalVisits.first.file.isNotEmpty,
                    child: CustomCachedNetworkImage(
                        imageUrl:
                            "${Constants.baseUrl}/${widget.car.technicalVisits.first.file}",
                        height: 200,
                        width: double.infinity,
                        borderRadius: 7.75),
                  ),
                ],
              )
            : const Text("Aucune visite technique"));
  }

  Widget _buildTvmSection() {
    return CustomAccordion(
        title: 'TVM',
        subTitle:
            Helpers.getDiffBetweenDates(widget.car.assurances.first.expiryDate)
                        .$2 ==
                    0
                ? 'Expirée'
                : 'Informations de la dernière TVM',
        headerBackgroundColor: AppColors.thirdyColor,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        subTitleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Helpers.getDiffBetweenDates(
                          widget.car.assurances.first.expiryDate)
                      .$2 ==
                  0
              ? AppColors.secondaryColor
              : Colors.white,
        ),
        toggleIconOpen: Icons.keyboard_arrow_down_sharp,
        toggleIconClose: Icons.keyboard_arrow_up_sharp,
        headerIconColor: Colors.white,
        accordionElevation: 2,
        widgetItems: widget.car.tvms.isNotEmpty
            ? Column(
                children: [
                  _buildAccordionItem(
                      label: "Status",
                      value: Helpers.getDiffBetweenDates(
                              widget.car.tvms.first.expiryDate)
                          .$1,
                      color: Helpers.getDiffBetweenDates(
                              widget.car.tvms.first.expiryDate)
                          .$3),
                  Dimensions.verticalSpacer(10),
                  _buildAccordionItem(
                      label: "Date de délivrance",
                      value: Helpers.formatDateTimeToDate(
                          widget.car.tvms.first.issueDate)),
                  Dimensions.verticalSpacer(10),
                  _buildAccordionItem(
                      label: "Date d'expiration",
                      value: Helpers.formatDateTimeToDate(
                          widget.car.tvms.first.expiryDate)),
                  Dimensions.verticalSpacer(10),
                  Visibility(
                    visible: widget.car.tvms.first.file.isNotEmpty,
                    child: CustomCachedNetworkImage(
                        imageUrl:
                            "${Constants.baseUrl}/${widget.car.tvms.first.file}",
                        height: 200,
                        width: double.infinity,
                        borderRadius: 7.75),
                  ),
                ],
              )
            : const Text("Aucune TVM"));
  }

  /* Widget _buildPaymentsSection() {
    return CustomAccordion(
        title: 'Historique de Paiements',
        subTitle: "Consultez l'historique des paiements de la voiture",
        headerBackgroundColor: AppColors.thirdyColor,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        subTitleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        toggleIconOpen: Icons.keyboard_arrow_down_sharp,
        toggleIconClose: Icons.keyboard_arrow_up_sharp,
        headerIconColor: Colors.white,
        accordionElevation: 2,
        widgetItems: Column(
          children: widget.car.payments
              .map((PaymentModel payment) => Card(
                    child: ListTile(
                      title: Text(
                        "${payment.entrySource} - ${payment.amount} FCFA",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(payment.wording),
                      trailing:
                          Text(Helpers.formatDateTimeToDate(payment.createdAt)),
                    ),
                  ))
              .toList(),
        ));
  }*/

  Widget _buildAccordionItem({
    required String label,
    required String value,
    Color color = Colors.black,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label: ',
        ),
        Text(value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  void showDeleteDialog(context) {
    BottomSheetHelper.showModalSheetWithConfirmationButton(
        context,
        const FaIcon(FontAwesomeIcons.trash, color: Colors.white),
        "Suppression",
        "Voulez-vous vraiment supprimer la voiture ${widget.car.brand} ${widget.car.model} ${widget.car.year}?",
        () async {
      BottomSheetHelper.showLoadingModalSheet(context,
          "Suppression de la voiture ${widget.car.brand} ${widget.car.model} ${widget.car.year} en cours...");
      bool isDeleted = await CarService().deleteCar(widget.car.id);
      Navigator.pop(context);
      if (isDeleted) {
        SnackBarHelper.showCustomSnackBar(
            context, "Voiture supprimée avec succès.",
            backgroundColor: Colors.green);
        Navigator.pop(context);
      } else {
        SnackBarHelper.showCustomSnackBar(context,
            "Une erreur s'est produite lors de la suppression. Veuillez réessayer.");
      }
    });
  }

  Widget _buildDepositForm(context) {
    return Form(
      key: keyForm,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Dimensions.verticalSpacer(15),
        const Text(
            "Renseignez les informations du dépôt d'argent que vous voulez effectuer."),
        Dimensions.verticalSpacer(15),
        const Text(
          "Montant à déposer *",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Dimensions.verticalSpacer(5),
        CustomTextField(
          controller: amountController,
          value: amountController.text,
          hintText: 'Saisissez le montant',
          maxLength: 30,
          keyboardType: TextInputType.number,
          errorMessage: "Le montant est obligatoire",
        ),
        Dimensions.verticalSpacer(15),
        const Text(
          "Source d'entrée *",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Dimensions.verticalSpacer(5),
        CustomDropButton<String>(
          hintText: 'Choisir',
          options: sourceEntries,
          onChanged: (value) {
            setState(() {
              selectedSource = value.toString();
            });
          },
          active: true,
          currentValue: selectedSource,
          displayStringForOption: (String item) => item,
        ),
        Dimensions.verticalSpacer(15),
        const Text(
          "Motif du dépôt *",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Dimensions.verticalSpacer(5),
        CustomTextField(
          controller: reasonController,
          value: reasonController.text,
          hintText: 'Saisissez le motif',
          maxLength: 100,
          errorMessage: "Le motif est obligatoire",
        ),
        Dimensions.verticalSpacer(15),
        RoundedButton(
          isActive: true,
          color: AppColors.primaryColor,
          textColor: Colors.white,
          text: 'Confirmer le dépôt',
          onPressed: () async {
            if (keyForm.currentState!.validate()) {
              Navigator.pop(context);
              BottomSheetHelper.showLoadingModalSheet(
                  context, "Traitement du dépôt en cours...");
              bool isSuccess = await CarService().makeDeposit(
                amount: double.parse(amountController.text),
                carId: widget.car.id,
                entrySource: selectedSource,
                wording: reasonController.text,
                plateCountry: widget.car.plateCountry!,
                plateSeries: widget.car.plateSeries!,
                plateNumber: widget.car.plateNumber!,
                ownerId: widget.car.ownerId!,
              );
              Navigator.pop(context);
              if (isSuccess) {
                SnackBarHelper.showCustomSnackBar(
                    context, "Dépôt effectué avec succès.",
                    backgroundColor: Colors.green);
              } else {
                SnackBarHelper.showCustomSnackBar(context,
                    "Une erreur s'est produite lors du dépôt. Veuillez réessayer.");
              }
            }
          },
        )
      ]),
    );
  }

  Widget _buildHistory(context) {
    return widget.car.payments.isNotEmpty
        ? Column(
            children: widget.car.payments
                .map((PaymentModel payment) => Card(
                      child: ListTile(
                        title: Text(
                          "${payment.entrySource} - ${payment.amount} FCFA",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(payment.wording),
                        trailing: Text(
                            Helpers.formatDateTimeToDate(payment.createdAt)),
                      ),
                    ))
                .toList())
        : SizedBox(
            height: Dimensions.getScreenHeight(context) / 2,
            child: const Center(
                child: Text(
              "Aucun historique",
              style: TextStyle(color: Colors.black54, fontSize: 20),
            )),
          );
  }
}
