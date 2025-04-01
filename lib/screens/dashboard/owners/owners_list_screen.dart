import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/models/owner.dart';
import 'package:loccar_agency/screens/dashboard/owners/add_or_edit_owner_screen.dart';
import 'package:loccar_agency/screens/dashboard/owners/owner_details_screen.dart';
import 'package:loccar_agency/services/owner.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/shimmer_helper.dart';

class OwnersListScreen extends StatefulWidget {
  const OwnersListScreen({super.key});

  @override
  State<OwnersListScreen> createState() => _OwnersListScreenState();
}

class _OwnersListScreenState extends State<OwnersListScreen> {
  List<OwnerModel> owners = [];
  List<OwnerModel> ownersFiltered = [];
  bool isLoading = false;
  final _filterFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getOwners());
    _filterFieldController.addListener(() {
      setState(() {
        if (_filterFieldController.text.isNotEmpty) {
          String searchText = _filterFieldController.text.toString().trim();

          ownersFiltered = owners
              .where((item) =>
                  (item.fullName
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase())) ||
                  (item.email
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase())) ||
                  (item.phoneNumber
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase())))
              .toList();
        } else {
          ownersFiltered = owners;
        }
      });
    });
  }

  Future<void> _getOwners() async {
    setState(() {
      isLoading = true;
    });
    owners = await OwnerService().fetchOwners();
    ownersFiltered = owners;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des propriétaires"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddOrEditOwnerScreen()))
              .then((value) => _getOwners());
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? ShimmerHelper.getShimmerListModel(context)
          : Column(
              children: [
                Container(
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    controller: _filterFieldController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Rechercher un propriétaire",
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
                      Text("Nom complet",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Voitures",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Dimensions.verticalSpacer(5),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _getOwners(),
                    child: ListView.builder(
                      itemCount: ownersFiltered.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        OwnerModel owner = ownersFiltered[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OwnerDetailsScreen(owner: owner)))
                                .then((value) => _getOwners());
                          },
                          child: Card(
                            child: ListTile(
                                leading: CircleAvatar(
                                    backgroundColor: AppColors.secondaryColor,
                                    child: Text(
                                        owner.fullName.substring(
                                          0,
                                          1,
                                        ),
                                        style: TextStyle(
                                            color: AppColors.primaryColor))),
                                title: Text(owner.fullName),
                                subtitle: Text(owner.email),
                                trailing: CircleAvatar(
                                  radius: 12,
                                  child: Center(
                                    child: Text(
                                      "${owner.carCount}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
