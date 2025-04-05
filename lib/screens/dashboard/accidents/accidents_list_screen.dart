import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/models/accident.dart';
import 'package:loccar_agency/screens/dashboard/accidents/accident_details_screen.dart';
import 'package:loccar_agency/services/accident.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/helpers.dart';
import 'package:loccar_agency/utils/shimmer_helper.dart';

class AccidentsListScreen extends StatefulWidget {
  const AccidentsListScreen({super.key});

  @override
  State<AccidentsListScreen> createState() => _AccidentsListScreenState();
}

class _AccidentsListScreenState extends State<AccidentsListScreen> {
  List<AccidentModel> accidents = [];
  List<AccidentModel> accidentsFiltered = [];
  bool isLoading = false;
  bool isFiltered = false;
  final _filterFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getAccidents());
  }

  Future<void> _getAccidents() async {
    setState(() {
      isLoading = true;
    });
    accidents = await AccidentService().fetchAccidents();
    accidentsFiltered = accidents;
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des accidents"),
      ),
      body: isLoading
          ? ShimmerHelper.getShimmerListModel(context)
          : accidentsFiltered.isNotEmpty
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
                              hintText: "Rechercher un accident",
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
                          onRefresh: () => _getAccidents(),
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: accidentsFiltered.length,
                              itemBuilder: (BuildContext context, index) {
                                AccidentModel accident =
                                    accidentsFiltered[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AccidentDetailsScreen(
                                                        accident: accident)))
                                        .then((value) => _getAccidents());
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
                                                child: accident.car!.carPhotos
                                                        .isNotEmpty
                                                    ? CachedNetworkImage(
                                                        imageUrl:
                                                            "${Constants.baseUrl}/${accident.car!.carPhotos.first.carPhoto}",
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
                                                "${accident.car!.brand} ${accident.car!.model} ${accident.car!.year}"),
                                            subtitle: Text(
                                                "${accident.car!.plateCountry} ${accident.car!.plateSeries} ${accident.car!.plateNumber} - ${accident.car!.color}"),
                                            trailing: Text(
                                              accident.state == 0
                                                  ? "Nouveau"
                                                  : "Lu",
                                              style: TextStyle(
                                                  color: accident.state == 0
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
                                                    accident.createdAt,
                                                    lang: "fr"),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                accident.owner!.fullName,
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
                        "Aucun accident",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ),
                  ),
                ),
    );
  }
}
