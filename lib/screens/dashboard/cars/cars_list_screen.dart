import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/models/car.dart';
import 'package:loccar_agency/screens/dashboard/cars/add_or_edit_car_screen.dart';
import 'package:loccar_agency/screens/dashboard/cars/car_details_screen.dart';
import 'package:loccar_agency/services/car.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/shimmer_helper.dart';

class CarsListScreen extends StatefulWidget {
  const CarsListScreen({super.key});

  @override
  State<CarsListScreen> createState() => _CarsListScreenState();
}

class _CarsListScreenState extends State<CarsListScreen> {
  List<CarModel> cars = [];
  List<CarModel> carsFiltered = [];
  bool isLoading = false;
  final _filterFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getCars());
    _filterFieldController.addListener(() {
      setState(() {
        if (_filterFieldController.text.isNotEmpty) {
          String searchText = _filterFieldController.text.toString().trim();

          carsFiltered = cars
              .where((item) =>
                  (item.plateNumber
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase())) ||
                  (item.brand
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase())) ||
                  (item.model
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase())))
              .toList();
        } else {
          carsFiltered = cars;
        }
      });
    });
  }

  Future _getCars() async {
    setState(() {
      isLoading = true;
    });
    cars = await CarService().fetchCars();
    carsFiltered = cars;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des voitures"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddOrEditCarScreen()))
              .then((value) => _getCars());
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? ShimmerHelper.getShimmerListModel(context)
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      controller: _filterFieldController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "Rechercher une voiture",
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
                  Dimensions.verticalSpacer(5),
                  Container(
                    height: 40,
                    color: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Voiture",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Location",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Dimensions.verticalSpacer(5),
                  RefreshIndicator(
                      onRefresh: () => _getCars(),
                      child: ListView.builder(
                        itemCount: carsFiltered.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          CarModel car = carsFiltered[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CarDetailsScreen(car: car)))
                                  .then((value) => _getCars());
                            },
                            child: Card(
                              child: ListTile(
                                  leading: SizedBox(
                                      width: 60,
                                      child: car.carPhotos.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  "${Constants.baseUrl}/${car.carPhotos.first.carPhoto}",
                                              errorWidget: (context, url,
                                                      error) =>
                                                  CircleAvatar(
                                                      backgroundColor: AppColors
                                                          .secondaryColor,
                                                      radius: 25,
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(3.0),
                                                        child: FaIcon(
                                                          FontAwesomeIcons.car,
                                                          color: Colors.white,
                                                          size: 25,
                                                        ),
                                                      )),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      CircleAvatar(
                                                          backgroundImage:
                                                              imageProvider,
                                                          radius: 25),
                                            )
                                          : CircleAvatar(
                                              backgroundColor:
                                                  AppColors.secondaryColor,
                                              radius: 25,
                                              child: const Padding(
                                                padding: EdgeInsets.all(3.0),
                                                child: FaIcon(
                                                  FontAwesomeIcons.car,
                                                  color: Colors.white,
                                                  size: 25,
                                                ),
                                              ))),
                                  title: Text(
                                      "${car.brand} ${car.model} ${car.year}"),
                                  subtitle: Text(
                                      "${car.plateCountry} ${car.plateSeries} ${car.plateNumber} - ${car.color}"),
                                  trailing: Text(
                                    car.isOnLocation ? "Oui" : "Non",
                                    style: TextStyle(
                                        color: car.isOnLocation
                                            ? Colors.green
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          );
                        },
                      )),
                ],
              ),
            ),
    );
  }
}
