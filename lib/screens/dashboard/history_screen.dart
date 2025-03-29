import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/models/transaction.dart';
import 'package:loccar_agency/services/transaction.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/helpers.dart';
import 'package:loccar_agency/utils/shimmer_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _filterFieldController = TextEditingController();

  List<TransactionModel> transactions = [];
  List<TransactionModel> transactionsFiltered = [];
  List dates = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getTransactions());

    _filterFieldController.addListener(() {
      setState(() {
        if (_filterFieldController.text.isNotEmpty) {
          String searchText = _filterFieldController.text.toString().trim();

          transactionsFiltered = transactions
              .where((item) =>
                  (item.amount
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase())) ||
                  (item.createdAt
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase())) ||
                  (item.transactionType
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase())) ||
                  (item.receiverType
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase())))
              .toList();
        } else {
          transactionsFiltered = transactions;
        }
      });
    });
  }

  Future<void> _getTransactions() async {
    setState(() {
      isLoading = true;
    });
    var response = await TransactionService().fetchRents();
    transactions = response.$1;
    transactionsFiltered = transactions;
    dates = response.$2;

    debugPrint("dates: $dates");

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.thirdyColor,
                AppColors.thirdyColor.withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            children: [
              Card(
                  elevation: 8,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: Dimensions.getScreenWidth(context),
                    height: 55,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            width: Dimensions.getScreenWidth(context) * 0.75,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                color: AppColors.primaryColor.withOpacity(0.2)),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              controller: _filterFieldController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 6),
                                hintText: "Rechercher une transaction",
                                hintStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                                prefixIcon: Icon(
                                  FontAwesomeIcons.magnifyingGlass,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                  child: Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 2),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: !isLoading
                    ? transactionsFiltered.isNotEmpty
                        ? Container(
                            color: Colors.grey.shade200,
                            width: Dimensions.getScreenWidth(context),
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 0),
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: dates.length,
                                itemBuilder: (BuildContext context, index) {
                                  return Visibility(
                                    visible: transactionsFiltered
                                        .where((transaction) =>
                                            Helpers.formatDateTimeToDate(
                                                transaction.createdAt,
                                                lang: "fr") ==
                                            dates[index])
                                        .isNotEmpty,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: Dimensions.getScreenWidth(
                                                      context) *
                                                  0.44,
                                              height: 35,
                                              alignment: Alignment.centerLeft,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                "${dates[index].toString().split("-")[2]} ${Constants.getMonth(dates[index])} ${dates[index].toString().split("-")[0]}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: Constants
                                                        .secondFontFamily,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ListView.separated(
                                            separatorBuilder:
                                                (context, index2) =>
                                                    const Divider(
                                                      height: 1,
                                                    ),
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: transactionsFiltered
                                                .where((transaction) =>
                                                    Helpers
                                                        .formatDateTimeToDate(
                                                            transaction
                                                                .createdAt,
                                                            lang: "fr") ==
                                                    dates[index])
                                                .length,
                                            itemBuilder:
                                                (BuildContext context, index2) {
                                              TransactionModel transaction =
                                                  transactionsFiltered
                                                      .where((transaction) =>
                                                          Helpers
                                                              .formatDateTimeToDate(
                                                                  transaction
                                                                      .createdAt,
                                                                  lang: "fr") ==
                                                          dates[index])
                                                      .elementAt(index2);
                                              return Card(
                                                color: Colors.white,
                                                elevation: 0.0,
                                                margin: EdgeInsets.zero,
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          right: 5, left: 10),
                                                  title: Text(
                                                    "${transaction.transactionType} - ${transaction.amount} Fcfa ",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                    Helpers
                                                        .formatDateTimeToString(
                                                            transaction
                                                                .createdAt),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  trailing: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: transaction
                                                                    .status ==
                                                                "approved"
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                      height: 30,
                                                      width: Dimensions
                                                              .getScreenWidth(
                                                                  context) *
                                                          0.28,
                                                      child: Center(
                                                        child: Text(
                                                          transaction.status ==
                                                                  "approved"
                                                              ? "Validé"
                                                              : "En attente",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      )),
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  );
                                }),
                          )
                        : const Center(
                            child: Text(
                              "Aucune transaction",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 20),
                            ),
                          )
                    : ShimmerHelper.getShimmerListModel(context),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
