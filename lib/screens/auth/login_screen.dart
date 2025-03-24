import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loccar_agency/utils/assets.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/widgets/custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _passwordVisible = false;
  bool isLoading = false;
  late TabController _controller;
  String telephone = "";
  String indicatif = "+228";
  String pays = "";
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(height: height * 0.63),
              headerWidget(height: height * 0.55),
              Card(
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: height * 0.25),
                elevation: 8,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Container(
                  width: width,
                  height: height * 0.63,
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    child: Column(children: [
                      Text(
                        "Remplir vos paramètres de connexion pour vous connecter à votre compte",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: Constants.currentFontFamily,
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                            color: Constants.primaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.2),
                                spreadRadius: 2,
                                blurRadius: 20,
                                offset: const Offset(0, 0),
                              )
                            ]),
                        child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: TabBar(
                              controller: _controller,
                              labelColor: Colors.white,
                              indicatorColor: Colors.white,
                              tabs: const [
                                Tab(
                                  icon: FaIcon(
                                    FontAwesomeIcons.phone,
                                    size: 10,
                                  ),
                                  text: 'Téléphone',
                                ),
                                Tab(
                                  icon: FaIcon(
                                    FontAwesomeIcons.envelope,
                                    size: 10,
                                  ),
                                  text: 'Adresse mail',
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: height * .18,
                        child: TabBarView(
                            controller: _controller,
                            children: <Widget>[
                              Column(
                                children: [
                                  Card(
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            width: width * 0.3,
                                            child: CountryCodePicker(
                                              onChanged: (e) {
                                                setState(() {
                                                  indicatif = e.code.toString();
                                                  pays = e.name.toString();
                                                  //print(pays);
                                                });
                                              },
                                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                              initialSelection: 'TG',
                                              favorite: const ['+228', 'TG'],
                                              // optional. Shows only country name and flag
                                              showCountryOnly: false,
                                              // optional. Shows only country name and flag when popup is closed.
                                              showOnlyCountryWhenClosed: false,
                                              // optional. aligns the flag and the Text left
                                              alignLeft: false,
                                            ),
                                          ),
                                          Expanded(
                                            child: TextField(
                                              autofocus: false,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    8),
                                              ],
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    "Entrer votre téléphone",
                                                hintStyle: TextStyle(
                                                  color: Color(0xff303030),
                                                  fontSize: 12,
                                                ),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  telephone = value;
                                                });
                                              },
                                              onSubmitted: (e) {
                                                //print(e.toString());
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                              width: width * 0.8,
                                              child: TextFormField(
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                obscureText: _passwordVisible,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: Constants
                                                      .currentFontFamily,
                                                  fontSize: 16,
                                                ),
                                                controller: _passwordController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      "Entrer votre mot de passe",
                                                  hintStyle: TextStyle(
                                                    color:
                                                        const Color(0xff303030),
                                                    fontSize: 14,
                                                    fontFamily: Constants
                                                        .currentFontFamily,
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.lock,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _passwordVisible
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                      color: Constants
                                                          .primaryColor,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _passwordVisible =
                                                            !_passwordVisible;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Card(
                                    margin: EdgeInsets.zero,
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                              width: width * 0.7,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: Constants
                                                      .currentFontFamily,
                                                  fontSize: 16,
                                                ),
                                                controller: _emailController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      "Votre adresse mail",
                                                  hintStyle: TextStyle(
                                                    color:
                                                        const Color(0xff303030),
                                                    fontSize: 14,
                                                    fontFamily: Constants
                                                        .currentFontFamily,
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.mail,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                              width: width * 0.8,
                                              child: TextFormField(
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                obscureText: _passwordVisible,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: Constants
                                                      .currentFontFamily,
                                                  fontSize: 16,
                                                ),
                                                controller: _passwordController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      "Entrer votre mot de passe",
                                                  hintStyle: TextStyle(
                                                    color:
                                                        const Color(0xff303030),
                                                    fontSize: 14,
                                                    fontFamily: Constants
                                                        .currentFontFamily,
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.lock,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _passwordVisible
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                      color: Constants
                                                          .primaryColor,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _passwordVisible =
                                                            !_passwordVisible;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ]),
                      ),
                      Platform.isAndroid
                          ? const SizedBox(
                              height: 7,
                            )
                          : const SizedBox(),
                      GestureDetector(
                        child: Text(
                          "Mot de passe oublié ?",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constants.secondaryColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      !isLoading
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: CustomButton(
                                color: Constants.primaryColor,
                                textColor: Colors.white,
                                text: 'Se Connecter',
                                onPressed: () {
                                  final email = _emailController.text.trim();
                                  final password =
                                      _passwordController.text.trim();

                                  String numTel = "$indicatif$telephone";

                                  //print(numTel);

                                  // if (password != "") {
                                  //   if (email != "") {
                                  //     login(context, email, password);
                                  //   } else if (telephone != "") {
                                  //     login(context, numTel, password);
                                  //   } else {
                                  //     _showAlertDialog('Désolé',
                                  //         'Veuillez renseigner vos informations.');
                                  //   }
                                  // } else {
                                  //   _showAlertDialog('Désolé',
                                  //       'Veuillez renseigner vos informations.');
                                  // }
                                },
                              ),
                            )
                          : Center(
                              child: SpinKitRotatingCircle(
                                color: Constants.secondaryColor,
                                size: 50,
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Vous n'avez pas encore de compte ? Vous n'avez plus une minute à perdre!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: Constants.currentFontFamily,
                            color: Colors.black87,
                            fontSize: 14),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () async {
                          FocusManager.instance.primaryFocus?.unfocus();

                          var whatsappUrl = "whatsapp://send?phone=22891019245"
                              "&text=${Uri.encodeComponent("Bonjour SOGENUVO, j'aimerai avoir plus d'informations.")}";
                          var whatsappUrl2 = "https://sogenuvo.com";
                          try {
                            if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                              launchUrl(Uri.parse(whatsappUrl));
                            } else {
                              launchUrl(Uri.parse(whatsappUrl2));
                            }
                            // ignore: empty_catches
                          } catch (e) {}

                          // launchUrl(Uri.parse("https://wa.me/22891019245"));
                        },
                        child: const Text(
                          "Contactez-nous?",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  headerWidget({required double height}) {
    return Container(
        height: height,
        padding: EdgeInsets.only(top: height * 0.05),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Constants.primaryColor,
                Constants.primaryColor,
              ],
            ),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(70),
                bottomRight: Radius.circular(70))),
        child: Column(
          children: [
            Platform.isIOS
                ? const SizedBox(
                    height: 70,
                  )
                : const SizedBox(
                    height: 30,
                  ),
            const Image(
              image: AssetImage(AppAssets.logoWhiteLarge),
              width: 300,
            ),
            const Text(
              "Connectez-vous à votre compte",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
