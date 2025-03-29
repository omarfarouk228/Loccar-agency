import 'package:flutter/material.dart';
import 'package:loccar_agency/models/owner.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/dimensions.dart';

class OwnerDetailsScreen extends StatefulWidget {
  final OwnerModel owner;
  const OwnerDetailsScreen({super.key, required this.owner});

  @override
  State<OwnerDetailsScreen> createState() => _OwnerDetailsScreenState();
}

class _OwnerDetailsScreenState extends State<OwnerDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.owner.fullName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Compte ${widget.owner.accountType == "personal" ? "personnel" : "professionnel"}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 16),
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: Constants.secondFontFamily,
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
                  )),
              Dimensions.verticalSpacer(10),
              /*CustomAccordion(
                title: 'Informations',
                subTitle: 'Voir toutes les informations',
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
                widgetItems: 
              ),*/
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildAccordionItem(
                          label: 'Nom', value: widget.owner.fullName),
                      Dimensions.verticalSpacer(10),
                      _buildAccordionItem(
                          label: 'Téléphone', value: widget.owner.phoneNumber),
                      Dimensions.verticalSpacer(10),
                      _buildAccordionItem(
                          label: 'N° de carte',
                          value: widget.owner.idCardNumber),
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
              ),
            ],
          ),
        ),
      ),
    );
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
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
