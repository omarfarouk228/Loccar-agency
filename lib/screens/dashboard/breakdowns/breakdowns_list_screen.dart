import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/models/breakdown.dart';
import 'package:loccar_agency/screens/dashboard/breakdowns/breakdown_details_screen.dart';
import 'package:loccar_agency/services/breakdown.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/helpers.dart';
import 'package:loccar_agency/utils/shimmer_helper.dart';

class BreakdownsListScreen extends StatefulWidget {
  const BreakdownsListScreen({super.key});

  @override
  State<BreakdownsListScreen> createState() => _BreakdownsListScreenState();
}

class _BreakdownsListScreenState extends State<BreakdownsListScreen> {
  List<BreakdownModel> breakdowns = [];
  List<BreakdownModel> breakdownsFiltered = [];
  bool isLoading = false;
  bool isFiltered = false;
  final _filterFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getBreakdowns());
  }

  Future<void> _getBreakdowns() async {
    setState(() {
      isLoading = true;
    });
    breakdowns = await BreakdownService().fetchBreakdowns();
    breakdownsFiltered = breakdowns;
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des pannes"),
      ),
      body: isLoading
          ? ShimmerHelper.getShimmerListModel(context)
          : breakdownsFiltered.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: 50,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            controller: _filterFieldController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Rechercher une panne",
                              hintStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                              prefixIcon: Icon(
                                FontAwesomeIcons.magnifyingGlass,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Dimensions.verticalSpacer(10),
                      RefreshIndicator(
                          onRefresh: () => _getBreakdowns(),
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: breakdownsFiltered.length,
                              itemBuilder: (BuildContext context, index) {
                                BreakdownModel breakdown =
                                    breakdownsFiltered[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BreakdownDetailsScreen(
                                                        breakdown: breakdown)))
                                        .then((value) => _getBreakdowns());
                                  },
                                  child: Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Column(
                                      children: [
                                        ListTile(
                                            leading: SizedBox(
                                                width: 60,
                                                child: breakdown.car!.carPhotos
                                                        .isNotEmpty
                                                    ? CachedNetworkImage(
                                                        imageUrl:
                                                            "${Constants.baseUrl}/${breakdown.car!.carPhotos.first.carPhoto}",
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            CircleAvatar(
                                                                backgroundColor:
                                                                    AppColors
                                                                        .secondaryColor,
                                                                radius: 25,
                                                                child:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              3.0),
                                                                  child: FaIcon(
                                                                    FontAwesomeIcons
                                                                        .car,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 25,
                                                                  ),
                                                                )),
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            CircleAvatar(
                                                                backgroundImage:
                                                                    imageProvider,
                                                                radius: 25),
                                                      )
                                                    : CircleAvatar(
                                                        backgroundColor:
                                                            AppColors
                                                                .secondaryColor,
                                                        radius: 25,
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  3.0),
                                                          child: FaIcon(
                                                            FontAwesomeIcons
                                                                .car,
                                                            color: Colors.white,
                                                            size: 25,
                                                          ),
                                                        ))),
                                            title: Text(
                                                "${breakdown.car!.brand} ${breakdown.car!.model} ${breakdown.car!.year}"),
                                            subtitle: Text(
                                                "${breakdown.car!.plateCountry} ${breakdown.car!.plateSeries} ${breakdown.car!.plateNumber} - ${breakdown.car!.color}"),
                                            trailing: Text(
                                              breakdown.state == 0
                                                  ? "Nouveau"
                                                  : "Lu",
                                              style: TextStyle(
                                                  color: breakdown.state == 0
                                                      ? Colors.red
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        const Divider(
                                          height: 1,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Helpers.formatDateTimeToString(
                                                    breakdown.createdAt,
                                                    lang: "fr"),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                breakdown.owner!.fullName,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }))
                    ],
                  ),
                )
              : const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Aucune panne",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ),
                  ),
                ),
    );
  }
}
