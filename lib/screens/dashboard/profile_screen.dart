import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/models/user.dart';
import 'package:loccar_agency/screens/auth/login_screen.dart';
import 'package:loccar_agency/utils/assets.dart';
import 'package:loccar_agency/utils/bottom_sheet_helper.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/preferences.dart';
import 'package:loccar_agency/widgets/buttons/sized_button.dart';
import 'package:loccar_agency/widgets/profile_item_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getUser());
  }

  void _getUser() async {
    user = await SharedPreferencesHelper.getObject(
        "user", (json) => UserModel.fromJson2(json));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = Dimensions.getScreenHeight(context);
    return Scaffold(
      body: FutureBuilder(
          future: Future.value(user),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: <Widget>[
                        Container(
                          height: height * 0.25,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              image: DecorationImage(
                                  image: AssetImage(AppAssets.banner),
                                  fit: BoxFit.cover)),
                        ),
                        Center(
                            child: Container(
                                margin: EdgeInsets.only(
                                  top: height * 0.18,
                                ),
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                    borderRadius: BorderRadius.circular(100)),
                                child: Center(
                                  child: Text(user!.name[0],
                                      style: const TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ))),
                      ],
                    ),
                    Text(
                      user!.name,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 30,
                          ),
                    ),
                    Text(
                      user!.email,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Dimensions.verticalSpacer(20),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "COMPTE",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black26),
                                  ),
                                  Dimensions.horizontalSpacer(5),
                                  GestureDetector(
                                    onTap: () {},
                                    child: SizedButton(
                                      width: 25,
                                      height: 25,
                                      radius: 7,
                                      color: AppColors.thirdyColor,
                                      child: const FaIcon(
                                        FontAwesomeIcons.pencil,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Dimensions.verticalSpacer(5),
                              accountInfosSection(),
                              Dimensions.verticalSpacer(20),
                              Text(
                                "PLUS",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black26),
                              ),
                              Dimensions.verticalSpacer(5),
                              appInfosSection(),
                              Dimensions.verticalSpacer(20),
                              Text(
                                "AVANCÉE",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black26),
                              ),
                              Dimensions.verticalSpacer(5),
                              handleAccountSection(),
                              Dimensions.verticalSpacer(20),
                            ]))
                  ],
                ),
              ));
            } else {
              return Container();
            }
          }),
    );
  }

  Widget accountInfosSection() {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.placeholderBg2,
        ),
        child: Column(children: [
          ProfileItemWidget(
              leftText: "Adresse mail",
              rightText: user!.email,
              isIcon: false,
              callback: () {}),
          const Divider(),
          ProfileItemWidget(
              leftText: "Mot de passe",
              rightText: "********",
              isIcon: true,
              callback: () {}),
          const Divider(),
          Column(
            children: [
              ProfileItemWidget(
                  leftText: "Raison sociale",
                  rightText: user!.name,
                  isIcon: true,
                  callback: () {}),
              const Divider(),
              ProfileItemWidget(
                  leftText: "Pays",
                  rightText: user!.country,
                  isIcon: true,
                  callback: () {}),
              const Divider(),
              ProfileItemWidget(
                  leftText: "Ville",
                  rightText: user!.city,
                  isIcon: true,
                  callback: () {}),
            ],
          ),
        ]));
  }

  Widget appInfosSection() {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.placeholderBg2,
        ),
        child: Column(children: [
          ProfileItemWidget(
              leftText: "Version de l'application",
              rightText: "1.0.0",
              isIcon: false,
              callback: () {}),
          const Divider(),
          ProfileItemWidget(
              leftText: "Noter l'application",
              rightText: "",
              isIcon: true,
              callback: () async {}),
          const Divider(),
          ProfileItemWidget(
              leftText: "Partager LOCCAR AGENCE!",
              rightText: "",
              isIcon: true,
              callback: () {}),
        ]));
  }

  Widget handleAccountSection() {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.placeholderBg2,
        ),
        child: Column(children: [
          ProfileItemWidget(
              leftText: "Déconnexion",
              rightText: "",
              isIcon: false,
              color: Colors.red,
              callback: () async {
                BottomSheetHelper.showModalSheetWithConfirmationButton(
                    context,
                    const FaIcon(
                      FontAwesomeIcons.lock,
                      color: Colors.white,
                    ),
                    "Déconnexion",
                    "Êtes-vous vraiment sûr de vous deconnecter?", () async {
                  SharedPreferencesHelper.clearAll();

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false);
                });
              }),
        ]));
  }
}
