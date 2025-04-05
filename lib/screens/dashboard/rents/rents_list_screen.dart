import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/models/rent.dart';
import 'package:loccar_agency/screens/dashboard/rents/rent_details_screen.dart';
import 'package:loccar_agency/services/rent.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/helpers.dart';
import 'package:loccar_agency/utils/shimmer_helper.dart';

import '../../../utils/dimensions.dart';

class RentsListScreen extends StatefulWidget {
  const RentsListScreen({super.key});

  @override
  State<RentsListScreen> createState() => _RentsListScreenState();
}

class _RentsListScreenState extends State<RentsListScreen>
    with SingleTickerProviderStateMixin {
  List<RentModel> rents = [];
  List<RentModel> rentsFiltered = [];
  List dates = [];
  bool isLoading = false;
  bool isFiltered = false;
  final _filterFieldController = TextEditingController();

  // Tab controller
  late TabController _tabController;

  // Lists for each tab
  List<RentModel> pendingRents = [];
  List<RentModel> inProgressRents = [];
  List<RentModel> completedRents = [];

  // Filtered lists for each tab
  List<RentModel> pendingRentsFiltered = [];
  List<RentModel> inProgressRentsFiltered = [];
  List<RentModel> completedRentsFiltered = [];

  // Dates for each status
  List pendingDates = [];
  List inProgressDates = [];
  List completedDates = [];

  @override
  void initState() {
    super.initState();
    // Initialize tab controller with 3 tabs
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) => _getRents());
    _filterFieldController.addListener(() {
      filterRentsBySearch();
    });

    // Listen for tab changes
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _filterFieldController.dispose();
    super.dispose();
  }

  void filterRentsBySearch() {
    if (_filterFieldController.text.isNotEmpty) {
      String query =
          _filterFieldController.text.toString().trim().toLowerCase();

      pendingRentsFiltered = pendingRents
          .where((item) =>
              (item.car!.brand.toString().toLowerCase().contains(query)) ||
              (item.createdAt.toString().toLowerCase().contains(query)) ||
              (item.car!.model.toString().toLowerCase().contains(query)) ||
              (item.car!.plateNumber.toString().toLowerCase().contains(query)))
          .toList();

      inProgressRentsFiltered = inProgressRents
          .where((item) =>
              (item.car!.brand.toString().toLowerCase().contains(query)) ||
              (item.createdAt.toString().toLowerCase().contains(query)) ||
              (item.car!.model.toString().toLowerCase().contains(query)) ||
              (item.car!.plateNumber.toString().toLowerCase().contains(query)))
          .toList();

      completedRentsFiltered = completedRents
          .where((item) =>
              (item.car!.brand.toString().toLowerCase().contains(query)) ||
              (item.createdAt.toString().toLowerCase().contains(query)) ||
              (item.car!.model.toString().toLowerCase().contains(query)) ||
              (item.car!.plateNumber.toString().toLowerCase().contains(query)))
          .toList();
    } else {
      pendingRentsFiltered = pendingRents;
      inProgressRentsFiltered = inProgressRents;
      completedRentsFiltered = completedRents;
    }
    setState(() {});
  }

  Future _getRents() async {
    setState(() {
      isLoading = true;
    });
    var response = await RentService().fetchRents();
    rents = response.$1;
    dates = response.$2;

    // Sort rents by status
    pendingRents = rents.where((rent) => rent.state == 0).toList();
    inProgressRents = rents.where((rent) => rent.state == 1).toList();
    completedRents = rents.where((rent) => rent.state == 2).toList();

    // Initialize filtered lists
    pendingRentsFiltered = pendingRents;
    inProgressRentsFiltered = inProgressRents;
    completedRentsFiltered = completedRents;

    // Create date lists for each status
    pendingDates = _getUniqueDates(pendingRents);
    inProgressDates = _getUniqueDates(inProgressRents);
    completedDates = _getUniqueDates(completedRents);

    setState(() {
      isLoading = false;
    });
  }

  List _getUniqueDates(List<RentModel> rentsList) {
    Set<String> uniqueDates = {};
    for (var rent in rentsList) {
      uniqueDates.add(Helpers.formatDateTimeToDate(rent.createdAt, lang: "en"));
    }
    return uniqueDates.toList()
      ..sort((a, b) => b.compareTo(a)); // Sort dates in descending order
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des locations"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "En attente"),
            Tab(text: "En cours"),
            Tab(text: "Terminé"),
          ],
          labelColor: AppColors.secondaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.secondaryColor,
        ),
      ),
      body: isLoading
          ? ShimmerHelper.getShimmerListModel(context)
          : Column(
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
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Pending Rents
                      _buildRentsList(pendingRentsFiltered, pendingDates, 0),
                      // Tab 2: In Progress Rents
                      _buildRentsList(
                          inProgressRentsFiltered, inProgressDates, 1),
                      // Tab 3: Completed Rents
                      _buildRentsList(
                          completedRentsFiltered, completedDates, 2),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildRentsList(
      List<RentModel> rentsList, List datesList, int statusCode) {
    if (rentsList.isEmpty) {
      return const Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Aucune location",
              style: TextStyle(color: Colors.black54, fontSize: 20),
            ),
          ),
        ),
      );
    }

    return Container(
      color: Colors.grey.shade200,
      width: Dimensions.getScreenWidth(context),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
      child: RefreshIndicator(
        onRefresh: () => _getRents(),
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: datesList.length,
            itemBuilder: (BuildContext context, index) {
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: Dimensions.getScreenWidth(context) * 0.44,
                        height: 35,
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "${datesList[index].toString().split("-")[2]} ${Constants.getMonth(datesList[index])} ${datesList[index].toString().split("-")[0]}",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontFamily: Constants.secondFontFamily,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                      separatorBuilder: (context, index2) =>
                          const Divider(height: 1),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: rentsList
                          .where((rent) =>
                              Helpers.formatDateTimeToDate(rent.createdAt,
                                  lang: "en") ==
                              datesList[index])
                          .length,
                      itemBuilder: (BuildContext context, index2) {
                        RentModel rent = rentsList
                            .where((rent) =>
                                Helpers.formatDateTimeToDate(rent.createdAt,
                                    lang: "en") ==
                                datesList[index])
                            .elementAt(index2);

                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RentDetailsScreen(rent: rent)),
                              ).then((value) => _getRents());
                            },
                            child: Card(
                                color: Colors.white,
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                        contentPadding: const EdgeInsets.only(
                                            right: 5, left: 10),
                                        title: Text(
                                          rent.user!.userName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          "${rent.car!.brand} ${rent.car!.model} ${rent.car!.color}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        trailing: Text(
                                          statusCode == 0
                                              ? "En attente"
                                              : (statusCode == 1
                                                  ? "En cours"
                                                  : "Terminé"),
                                          style: TextStyle(
                                            color: statusCode == 0
                                                ? Colors.red
                                                : (statusCode == 1
                                                    ? Colors.orange
                                                    : Colors.green),
                                          ),
                                        )),
                                    const Divider(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Date de début: ",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                            Helpers.formatDateTimeToString(
                                                rent.startDate),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )));
                      }),
                ],
              );
            }),
      ),
    );
  }
}
