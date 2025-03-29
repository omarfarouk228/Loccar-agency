import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/models/car.dart';
import 'package:loccar_agency/screens/dashboard/cars/car_details_screen.dart';
import 'package:loccar_agency/services/car.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/shimmer_helper.dart';
import 'package:loccar_agency/widgets/buttons/sized_button.dart';

class CarsListScreen extends StatefulWidget {
  const CarsListScreen({super.key});

  @override
  State<CarsListScreen> createState() => _CarsListScreenState();
}

class _CarsListScreenState extends State<CarsListScreen> {
  List<CarModel> cars = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getCars());
  }

  Future _getCars() async {
    setState(() {
      isLoading = true;
    });
    cars = await CarService().fetchCars();
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
      body: isLoading
          ? ShimmerHelper.getShimmerListModel(context)
          : RefreshIndicator(
              onRefresh: () => _getCars(),
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  CarModel car = cars[index];
                  return Card(
                    child: ListTile(
                        leading: SizedBox(
                            width: 60,
                            child: car.carPhotos.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl:
                                        "${Constants.baseUrl}/${car.carPhotos.first.carPhoto}",
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
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
                                            )),
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                            backgroundImage: imageProvider,
                                            radius: 25),
                                  )
                                : CircleAvatar(
                                    backgroundColor: AppColors.secondaryColor,
                                    radius: 25,
                                    child: const Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: FaIcon(
                                        FontAwesomeIcons.car,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ))),
                        title: Text("${car.brand} ${car.model} ${car.year}"),
                        subtitle: Text(
                            "${car.plateCountry} ${car.plateSeries} ${car.plateNumber} - ${car.color}"),
                        trailing: SizedButton(
                          width: 40,
                          height: 35,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CarDetailsScreen(car: car))),
                          child: const FaIcon(FontAwesomeIcons.eye,
                              size: 12, color: Colors.white),
                        )),
                  );
                },
              )),
    );
  }
}
