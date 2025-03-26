import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loccar_agency/screens/dashboard/dashboard_screen.dart';
import 'package:loccar_agency/utils/assets.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/preferences.dart';
import 'package:loccar_agency/utils/snack_bar_helper.dart';
import 'package:loccar_agency/widgets/buttons/rounded_button.dart';
import 'package:loccar_agency/widgets/textfields/custom_password_field.dart';
import 'package:loccar_agency/widgets/textfields/custom_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = Dimensions.getScreenHeight(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage(AppAssets.authBg), // Replace with actual image
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay with Opacity
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          SafeArea(child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
                child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 40, bottom: 20),
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      AppAssets
                                          .logoBlueSquare, // Replace with actual logo
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                                const Text(
                                    "Suivez en temps réel la gestion vos véhicules avec Loccar Agence.",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: Dimensions.getScreenWidth(context),
                            height: screenHeight * 0.6,
                            child: Form(
                              key: formKey,
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Créer un  compte',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Dimensions.verticalSpacer(10),
                                      Text(
                                        "Nom *",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Dimensions.verticalSpacer(5),
                                      CustomTextField(
                                        controller: emailController,
                                        hintText: 'Ex: agence@gmail.com',
                                        autofocus: true,
                                        maxLength: 30,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        errorMessage:
                                            "L'adresse email est obligatoire",
                                      ),
                                      Dimensions.verticalSpacer(10),
                                      Text(
                                        "Mot de passe *",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Dimensions.verticalSpacer(5),
                                      CustomPasswordField(
                                        controller: passwordController,
                                        hintText: 'Mot de passe',
                                        errorMessage:
                                            "Le mot de passe doit contenir au moins 8 caractères",
                                        passwordVisible: true,
                                      ),
                                      Dimensions.verticalSpacer(20),
                                      !isLoading
                                          ? RoundedButton(
                                              isActive: true,
                                              color: AppColors.primaryColor,
                                              textColor: Colors.white,
                                              text: 'Continuer',
                                              onPressed: () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  login();
                                                }
                                              },
                                            )
                                          : Center(
                                              child: SpinKitThreeBounce(
                                                color: AppColors.secondaryColor,
                                                size: 30,
                                              ),
                                            ),
                                      const Spacer(),
                                      const Text(
                                        "Vous n'avez pas encore de compte ? Vous n'avez plus une minute à perdre!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14),
                                      ),
                                      Dimensions.verticalSpacer(5),
                                      GestureDetector(
                                        onTap: () async {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();

                                          var whatsappUrl =
                                              "whatsapp://send?phone=22891019245"
                                              "&text=${Uri.encodeComponent("Bonjour LOCCAR, j'aimerai avoir plus d'informations.")}";
                                          var whatsappUrl2 =
                                              "https://sogenuvo.com";
                                          try {
                                            if (await canLaunchUrl(
                                                Uri.parse(whatsappUrl))) {
                                              launchUrl(Uri.parse(whatsappUrl));
                                            } else {
                                              launchUrl(
                                                  Uri.parse(whatsappUrl2));
                                            }
                                            // ignore: empty_catches
                                          } catch (e) {}
                                        },
                                        child: const Center(
                                          child: Text(
                                            "Contactez-nous?",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).viewInsets.bottom),
                        ],
                      ),
                    )));
          })),

          // Content
        ],
      ),
    );
  }

  void login() {
    if (emailController.text == "sogenuvo@gmail.com" &&
        passwordController.text == "952489") {
      setState(() {
        isLoading = false;
      });
      SharedPreferencesHelper.setIntValue("step_auth", 1);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
          (route) => false);
    } else {
      setState(() {
        isLoading = false;
      });
      SnackBarHelper.showCustomSnackBar(
          context, "Email ou mot de passe incorrect");
    }
  }
}
