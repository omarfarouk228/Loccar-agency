import 'package:flutter/material.dart';
import 'package:loccar_agency/screens/auth/login_screen.dart';
import 'package:loccar_agency/utils/assets.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/preferences.dart';
import 'package:loccar_agency/widgets/custom_widgets.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        bottomNavigationBar: Container(
          height: height * 0.17,
          alignment: Alignment.center,
          child: Column(
            children: [
              const Text(
                "Pour utiliser l'application, vous devez accepter nos",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "termes et conditions d'utilisations",
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryColor,
                    decoration: TextDecoration.underline),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: CustomButton(
                  color: AppColors.primaryColor,
                  textColor: Colors.white,
                  text: 'Accepter et continuer',
                  onPressed: () {
                    SharedPreferencesHelper.setIntValue("onboarding_seen", 1);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const LoginScreen();
                    }));
                  },
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 200.0,
              height: 200.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage(AppAssets.logoBlueSquare),
                    fit: BoxFit.cover,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20.0,
                  color: AppColors.primaryColor,
                ),
                children: const <TextSpan>[
                  TextSpan(text: 'Bienvenue dans votre application\n'),
                  TextSpan(
                      text: 'de location de voitures',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Une nouvelle façon de louer et gérer vos voitures. LOCCAR vous simplifie "
              "les procédures et vous notifie des papiers administratifs.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ]),
        ));
  }
}
