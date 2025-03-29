import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/models/rent.dart';
import 'package:loccar_agency/screens/dashboard/rents/rent_details_screen.dart';
import 'package:loccar_agency/services/rent.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/helpers.dart';
import 'package:loccar_agency/utils/shimmer_helper.dart';

import '../../../utils/dimensions.dart';

class RentsListScreen extends StatefulWidget {
  const RentsListScreen({super.key});

  @override
  State<RentsListScreen> createState() => _RentsListScreenState();
}

class _RentsListScreenState extends State<RentsListScreen> {
  List<RentModel> rents = [];
  List<RentModel> rentsFiltered = [];
  List dates = [];
  bool isLoading = false;
  bool isFiltered = false;
  final _filterFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getRents());
    _filterFieldController.addListener(() {
      if (_filterFieldController.text.isNotEmpty) {
        String contact = _filterFieldController.text.toString().trim();

        rentsFiltered = rents
            .where((item) =>
                (item.car!.brand
                    .toString()
                    .toLowerCase()
                    .contains(contact.toLowerCase())) ||
                (item.createdAt
                    .toString()
                    .toLowerCase()
                    .contains(contact.toLowerCase())) ||
                (item.car!.model
                    .toString()
                    .toLowerCase()
                    .contains(contact.toLowerCase())) ||
                (item.car!.plateNumber
                    .toString()
                    .toLowerCase()
                    .contains(contact.toLowerCase())))
            .toList();
      } else {
        rentsFiltered = rents;
      }
      setState(() {});
    });
  }

  Future _getRents() async {
    setState(() {
      isLoading = true;
    });
    var response = await RentService().fetchRents();
    rents = response.$1;
    dates = response.$2;
    rentsFiltered = rents;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Liste des locations"),
        ),
        body: isLoading
            ? ShimmerHelper.getShimmerListModel(context)
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      controller: _filterFieldController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "Rechercher une location",
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                          fontFamily: Constants.currentFontFamily,
                        ),
                        prefixIcon: const Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  rentsFiltered.isNotEmpty
                      ? Expanded(
                          child: Container(
                          color: Colors.grey.shade200,
                          width: Dimensions.getScreenWidth(context),
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 0),
                          child: RefreshIndicator(
                            onRefresh: () => _getRents(),
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: dates.length,
                                itemBuilder: (BuildContext context, index) {
                                  return Visibility(
                                    visible: rentsFiltered
                                        .where((rent) =>
                                            Helpers.formatDateTimeToDate(
                                                rent.createdAt,
                                                lang: "en") ==
                                            dates[index])
                                        .isNotEmpty,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: Dimensions.getScreenWidth(
                                                      context) *
                                                  0.44,
                                              height: 35,
                                              alignment: Alignment.centerLeft,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                "${dates[index].toString().split("-")[2]} ${Constants.getMonth(dates[index])} ${dates[index].toString().split("-")[0]}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: Constants
                                                        .secondFontFamily,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ListView.separated(
                                            separatorBuilder:
                                                (context, index2) =>
                                                    const Divider(
                                                      height: 1,
                                                    ),
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: rentsFiltered
                                                .where((rent) =>
                                                    Helpers
                                                        .formatDateTimeToDate(
                                                            rent.createdAt,
                                                            lang: "en") ==
                                                    dates[index])
                                                .length,
                                            itemBuilder:
                                                (BuildContext context, index2) {
                                              RentModel rent = rentsFiltered
                                                  .where((rent) =>
                                                      Helpers
                                                          .formatDateTimeToDate(
                                                              rent.createdAt,
                                                              lang: "en") ==
                                                      dates[index])
                                                  .elementAt(index2);
                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              RentDetailsScreen(
                                                                  rent: rent)),
                                                    );
                                                  },
                                                  child: Card(
                                                    color: Colors.white,
                                                    elevation: 0.0,
                                                    margin: EdgeInsets.zero,
                                                    child: ListTile(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              right: 5,
                                                              left: 10),
                                                      title: Text(
                                                        rent.car == null
                                                            ? "He"
                                                            : "${rent.car!.brand} ${rent.car!.model} ${rent.car!.plateNumber}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        Helpers
                                                            .formatDateTimeToString(
                                                                rent.createdAt),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      trailing: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: rent.state ==
                                                                    2
                                                                ? Colors.green
                                                                : Colors.orange,
                                                          ),
                                                          height: 30,
                                                          width: Dimensions
                                                                  .getScreenWidth(
                                                                      context) *
                                                              0.28,
                                                          child: Center(
                                                            child: Text(
                                                              rent.state == 2
                                                                  ? "Terminé"
                                                                  : (rent.state ==
                                                                          1
                                                                      ? "En cours"
                                                                      : "En attente"),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )),
                                                    ),
                                                  ));
                                            }),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ))
                      : const Card(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Aucune location",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 20),
                              ),
                            ),
                          ),
                        )
                  /* RefreshIndicator(
                      onRefresh: () => _getRents(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: rents.length,
                        itemBuilder: (context, index) {
                          RentModel car = rents[index];
                          return;
                        },
                      )),*/
                ]),
              ));
  }
}
