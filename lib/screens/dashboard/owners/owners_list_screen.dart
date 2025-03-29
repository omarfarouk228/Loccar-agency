import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/models/owner.dart';
import 'package:loccar_agency/screens/dashboard/owners/owner_details_screen.dart';
import 'package:loccar_agency/services/owner.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/shimmer_helper.dart';
import 'package:loccar_agency/widgets/buttons/sized_button.dart';

class OwnersListScreen extends StatefulWidget {
  const OwnersListScreen({super.key});

  @override
  State<OwnersListScreen> createState() => _OwnersListScreenState();
}

class _OwnersListScreenState extends State<OwnersListScreen> {
  List<OwnerModel> owners = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getOwners());
  }

  Future<void> _getOwners() async {
    setState(() {
      isLoading = true;
    });
    owners = await OwnerService().fetchOwners();
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
      body: isLoading
          ? ShimmerHelper.getShimmerListModel(context)
          : RefreshIndicator(
              onRefresh: () => _getOwners(),
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: owners.length,
                itemBuilder: (context, index) {
                  OwnerModel owner = owners[index];
                  return Card(
                    child: ListTile(
                        leading: CircleAvatar(
                            backgroundColor: AppColors.secondaryColor,
                            child: Text(
                                owner.fullName.substring(
                                  0,
                                  1,
                                ),
                                style: const TextStyle(color: Colors.white))),
                        title: Text(owner.fullName),
                        subtitle: Text(owner.email),
                        trailing: SizedButton(
                            width: 75,
                            height: 35,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OwnerDetailsScreen(owner: owner))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(FontAwesomeIcons.eye,
                                    size: 12, color: Colors.white),
                                Dimensions.horizontalSpacer(5),
                                const Text(
                                  "Détails",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ))),
                  );
                },
              ),
            ),
    );
  }
}
