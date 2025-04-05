import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/models/maintenance.dart';
import 'package:loccar_agency/screens/dashboard/maintenances/maintenance_details_screen.dart';
import 'package:loccar_agency/services/maintenance.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/helpers.dart';
import 'package:loccar_agency/utils/shimmer_helper.dart';

class MaintenancesListScreen extends StatefulWidget {
  const MaintenancesListScreen({super.key});

  @override
  State<MaintenancesListScreen> createState() => _MaintenancesListScreenState();
}

class _MaintenancesListScreenState extends State<MaintenancesListScreen> {
  List<MaintenanceModel> maintenances = [];
  List<MaintenanceModel> maintenancesFiltered = [];
  bool isLoading = false;
  bool isFiltered = false;
  final _filterFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getMaintenances());
  }

  Future<void> _getMaintenances() async {
    setState(() {
      isLoading = true;
    });
    maintenances = await MaintenanceService().fetchMaintenances();
    maintenancesFiltered = maintenances;
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des maintenances"),
      ),
      body: isLoading
          ? ShimmerHelper.getShimmerListModel(context)
          : maintenancesFiltered.isNotEmpty
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
                              hintText: "Rechercher un maintenance",
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
                          onRefresh: () => _getMaintenances(),
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: maintenancesFiltered.length,
                              itemBuilder: (BuildContext context, index) {
                                MaintenanceModel maintenance =
                                    maintenancesFiltered[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MaintenanceDetailsScreen(
                                                        maintenance:
                                                            maintenance)))
                                        .then((value) => _getMaintenances());
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
                                                child: maintenance.car!
                                                        .carPhotos.isNotEmpty
                                                    ? CachedNetworkImage(
                                                        imageUrl:
                                                            "${Constants.baseUrl}/${maintenance.car!.carPhotos.first.carPhoto}",
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
                                                "${maintenance.car!.brand} ${maintenance.car!.model} ${maintenance.car!.year}"),
                                            subtitle: Text(
                                                "${maintenance.car!.plateCountry} ${maintenance.car!.plateSeries} ${maintenance.car!.plateNumber} - ${maintenance.car!.color}"),
                                            trailing: Text(
                                              maintenance.state == 0
                                                  ? "Nouveau"
                                                  : "Lu",
                                              style: TextStyle(
                                                  color: maintenance.state == 0
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
                                                    maintenance.createdAt,
                                                    lang: "fr"),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                maintenance.owner!.fullName,
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
                        "Aucune maintenance",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ),
                  ),
                ),
    );
  }
}
