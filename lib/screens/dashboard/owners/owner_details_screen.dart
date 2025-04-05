import 'package:custom_accordion/custom_accordion.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/models/car.dart';
import 'package:loccar_agency/models/owner.dart';
import 'package:loccar_agency/models/payment.dart';
import 'package:loccar_agency/screens/dashboard/owners/add_or_edit_owner_screen.dart';
import 'package:loccar_agency/services/owner.dart';
import 'package:loccar_agency/utils/bottom_sheet_helper.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/helpers.dart';
import 'package:loccar_agency/utils/snack_bar_helper.dart';
import 'package:loccar_agency/widgets/buttons/rounded_button.dart';
import 'package:loccar_agency/widgets/floating_action_buttons.dart';
import 'package:loccar_agency/widgets/textfields/custom_text_field.dart';

class OwnerDetailsScreen extends StatefulWidget {
  final OwnerModel owner;
  const OwnerDetailsScreen({super.key, required this.owner});

  @override
  State<OwnerDetailsScreen> createState() => _OwnerDetailsScreenState();
}

class _OwnerDetailsScreenState extends State<OwnerDetailsScreen> {
  GlobalKey<FormState> keyForm = GlobalKey();
  TextEditingController amountController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.owner.fullName),
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
                    _buildWalletSection(),
                    Dimensions.verticalSpacer(10),
                    //if (widget.owner.payments.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        BottomSheetHelper.showCustomBottomSheet(context,
                            "Historique des retraits", _buildHistory(context),
                            heightRatio: 0.6);
                      },
                      child: Card(
                        color: Colors.grey.shade300,
                        child: const ListTile(
                          title: Text("Historique"),
                          subtitle: Text("Voir l'historique des retraits"),
                          trailing: FaIcon(
                            FontAwesomeIcons.angleRight,
                          ),
                        ),
                      ),
                    ),
                    Dimensions.verticalSpacer(10),
                    _buildInfosSection(),
                    Dimensions.verticalSpacer(10),
                    if (widget.owner.cars.isNotEmpty) _buildCarsSection(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: CustomFloatingActionButtons(
                iconsData: const [Icons.edit, Icons.delete],
                callbacks: [
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddOrEditOwnerScreen(owner: widget.owner)));
                  },
                  () {
                    showDeleteDialog(context);
                  }
                ],
                colors: [AppColors.secondaryColor, Colors.red],
              ))
        ],
      ),
    );
  }

  Widget _buildWalletSection() {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Compte ${widget.owner.accountType == "personal" ? "personnel" : "professionnel"}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Text(
                      widget.owner.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.owner.balance.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Dimensions.horizontalSpacer(5),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            'F CFA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          'Solde du compte',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
                child: VerticalDivider(
                  color: Colors.white,
                  width: 10,
                  thickness: 1,
                ),
              ),
              GestureDetector(
                onTap: () {
                  BottomSheetHelper.showCustomBottomSheet(context,
                      "Faire un retrait", _buildWithdrawalForm(context));
                },
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "Faire un retrait",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildInfosSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAccordionItem(label: 'Nom', value: widget.owner.fullName),
            Dimensions.verticalSpacer(10),
            _buildAccordionItem(
                label: 'Téléphone', value: widget.owner.phoneNumber),
            Dimensions.verticalSpacer(10),
            _buildAccordionItem(
                label: 'N° de carte', value: widget.owner.idCardNumber),
            Dimensions.verticalSpacer(10),
            Visibility(
                visible: widget.owner.idCard.isNotEmpty,
                child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "${Constants.baseUrl}/${widget.owner.idCard}"))))),
          ],
        ),
      ),
    );
  }

  Widget _buildCarsSection() {
    return CustomAccordion(
        title: 'Liste des voitures',
        subTitle: "Consultez les voitures de ${widget.owner.fullName}",
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
          children: widget.owner.cars
              .map((CarModel car) => Card(
                    child: ListTile(
                      title: Text(
                        "${car.brand} - ${car.model} - ${car.year}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          "${car.plateCountry} - ${car.plateNumber} - ${car.plateSeries}"),
                    ),
                  ))
              .toList(),
        ));
  }

  Widget _buildAccordionItem({
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label: ',
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildHistory(context) {
    return widget.owner.payments.isNotEmpty
        ? Column(
            children: widget.owner.payments
                .map((PaymentModel payment) => Card(
                      child: ListTile(
                        title: Text(
                          "${payment.amount} FCFA",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(payment.wording),
                        trailing: Text(
                            Helpers.formatDateTimeToDate(payment.createdAt)),
                      ),
                    ))
                .toList(),
          )
        : SizedBox(
            height: Dimensions.getScreenHeight(context) / 2,
            child: const Center(
                child: Text(
              "Aucun historique",
              style: TextStyle(color: Colors.black54, fontSize: 20),
            )),
          );
  }

  void showDeleteDialog(context) {
    BottomSheetHelper.showModalSheetWithConfirmationButton(
        context,
        const FaIcon(FontAwesomeIcons.trash, color: Colors.white),
        "Suppression",
        "Voulez-vous vraiment supprimer le propriétaire ${widget.owner.fullName}?",
        () async {
      BottomSheetHelper.showLoadingModalSheet(context,
          "Suppression du propriétaire ${widget.owner.fullName} en cours...");
      bool isDeleted = await OwnerService().deleteOwner(widget.owner.id);
      Navigator.pop(context);
      if (isDeleted) {
        SnackBarHelper.showCustomSnackBar(
            context, "Propriétaire supprimé avec succès.",
            backgroundColor: Colors.green);
        Navigator.pop(context);
      } else {
        SnackBarHelper.showCustomSnackBar(context,
            "Une erreur s'est produite lors de la suppression. Veuillez réessayer.");
      }
    });
  }

  Widget _buildWithdrawalForm(context) {
    return Form(
      key: keyForm,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Dimensions.verticalSpacer(15),
        const Text(
            "Renseignez les informations du retrait d'argent que vous voulez effectuer."),
        Dimensions.verticalSpacer(15),
        const Text(
          "Montant à retirer *",
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
          "Motif ou raison du retrait *",
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
          text: 'Confirmer le retrait',
          onPressed: () async {
            if (keyForm.currentState!.validate()) {
              Navigator.pop(context);
              BottomSheetHelper.showLoadingModalSheet(
                  context, "Traitement du retrait en cours...");
              bool isSuccess = await OwnerService().makeWithdrawal(
                amount: double.parse(amountController.text),
                ownerId: widget.owner.id,
                wording: reasonController.text,
              );
              Navigator.pop(context);
              if (isSuccess) {
                SnackBarHelper.showCustomSnackBar(
                    context, "Demande de retrait effectuée avec succès.",
                    backgroundColor: Colors.green);
              } else {
                SnackBarHelper.showCustomSnackBar(context,
                    "Une erreur s'est produite lors de la demande de retrait. Veuillez réessayer.");
              }
            }
          },
        )
      ]),
    );
  }
}
