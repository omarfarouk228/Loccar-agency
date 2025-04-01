import 'package:flutter/material.dart';
import 'package:loccar_agency/models/assurance.dart';
import 'package:loccar_agency/models/car_photo.dart';
import 'package:loccar_agency/models/owner.dart';
import 'package:loccar_agency/models/payment.dart';
import 'package:loccar_agency/models/technical_visit.dart';
import 'package:loccar_agency/models/tvm.dart';

class CarModel {
  final int id;
  final int? ownerId;
  final int? agencyId;
  final int? administratorId;
  final int? categoryId;
  final String? brand;
  final String? grayCardNumber;
  final String? grayCard;
  final String? chassisNumber;
  final String? plateCountry;
  final String? plateNumber;
  final String? plateSeries;
  final int year;
  final String? model;
  final String? color;
  final bool geolocation;
  final int locationFees;
  final String? rentHours;
  final String? comment;
  final int shopFees;
  final bool isOnRace;
  final bool isOnLocation;
  final bool isOnShop;
  final bool isPopular;
  final int notation;
  final int places;
  final int doors;
  final bool airConditioner;
  final String? transmission;
  final String? engine;
  final DateTime? assuranceIssueDate;
  final DateTime? assuranceExpiryDate;
  final String? assurance;
  final DateTime? technicalVisitIssueDate;
  final DateTime? technicalVisitExpiryDate;
  final String? technicalVisit;
  final DateTime? tvmIssueDate;
  final DateTime? tvmExpiryDate;
  final String? tvm;
  final int state;
  final int score;
  final String? caracteristique;
  final double? metreCube;
  final double? poids;
  final String? type;
  final bool twoHours;
  final bool sixHours;
  final bool twelveHours;
  final bool days;
  final int? popularDays;
  final DateTime? popularStartDate;
  final DateTime? popularEndDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CarPhotoModel> carPhotos;
  final List<PaymentModel> payments;
  // final List<AccidentModel> accidents;
  // final List<MaintenanceModel> maintenances;
  final List<AssuranceModel> assurances;
  final List<TechnicalVisitModel> technicalVisits;
  final List<TvmModel> tvms;
  final OwnerModel? owner;

  CarModel(
      {required this.id,
      this.ownerId,
      required this.agencyId,
      this.administratorId,
      required this.categoryId,
      this.brand,
      this.grayCardNumber,
      this.grayCard,
      this.chassisNumber,
      this.plateCountry,
      this.plateNumber,
      this.plateSeries,
      required this.year,
      this.model,
      this.color,
      required this.geolocation,
      required this.locationFees,
      this.rentHours,
      this.comment,
      required this.shopFees,
      required this.isOnRace,
      required this.isOnLocation,
      required this.isOnShop,
      required this.isPopular,
      required this.notation,
      required this.places,
      required this.doors,
      required this.airConditioner,
      this.transmission,
      this.engine,
      required this.assuranceIssueDate,
      required this.assuranceExpiryDate,
      this.assurance,
      required this.technicalVisitIssueDate,
      required this.technicalVisitExpiryDate,
      this.technicalVisit,
      this.tvmIssueDate,
      this.tvmExpiryDate,
      this.tvm,
      required this.state,
      required this.score,
      this.caracteristique,
      this.metreCube,
      this.poids,
      this.type,
      required this.twoHours,
      required this.sixHours,
      required this.twelveHours,
      required this.days,
      this.popularDays,
      this.popularStartDate,
      this.popularEndDate,
      required this.createdAt,
      required this.updatedAt,
      required this.carPhotos,
      required this.payments,
      // required this.accidents,
      // required this.maintenances,
      required this.assurances,
      required this.technicalVisits,
      required this.tvms,
      this.owner});

  factory CarModel.fromJson(Map<String, dynamic> json) {
    debugPrint("json: $json['id]");
    List<CarPhotoModel> photos = [];
    List<PaymentModel> paymentsList = [];
    // List<AccidentModel> accidentsList = [];
    // List<MaintenanceModel> maintenancesList = [];
    List<AssuranceModel> assurancesList = [];
    List<TechnicalVisitModel> technicalVisitsList = [];
    List<TvmModel> tvmsList = [];

    if (json['car_photos'] != null) {
      for (var carPhoto in json['car_photos']) {
        photos.add(CarPhotoModel.fromJson(carPhoto));
      }
    }

    if (json['payments'] != null) {
      for (var payment in json['payments']) {
        paymentsList.add(PaymentModel.fromJson(payment));
      }
    }

    // if (json['accidents'] != null) {
    //   for (var accident in json['accidents']) {
    //     accidentsList.add(AccidentModel.fromJson(accident));
    //   }
    // }

    // if (json['maintenances'] != null) {
    //   for (var maintenance in json['maintenances']) {
    //     maintenancesList.add(MaintenanceModel.fromJson(maintenance));
    //   }
    // }

    if (json['assurances'] != null) {
      for (var assurance in json['assurances']) {
        assurancesList.add(AssuranceModel.fromJson(assurance));
      }
    }

    if (json['technicalVisits'] != null) {
      for (var technicalVisit in json['technicalVisits']) {
        technicalVisitsList.add(TechnicalVisitModel.fromJson(technicalVisit));
      }
    }

    if (json['tvms'] != null) {
      for (var tvm in json['tvms']) {
        tvmsList.add(TvmModel.fromJson(tvm));
      }
    }

    return CarModel(
        id: json['id'],
        ownerId: json['ownerId'],
        agencyId: json['agencyId'],
        administratorId: json['administratorId'],
        categoryId: json['categoryId'],
        brand: json['brand'],
        grayCardNumber: json['grayCardNumber'],
        grayCard: json['grayCard'],
        chassisNumber: json['chassisNumber'],
        plateCountry: json['plateCountry'],
        plateNumber: json['plateNumber'],
        plateSeries: json['plateSeries'],
        year: json['year'],
        model: json['model'],
        color: json['color'],
        geolocation: json['geolocation'],
        locationFees: json['locationFees'],
        rentHours: json['rentHours'],
        comment: json['comment'],
        shopFees: json['shopFees'],
        isOnRace: json['isOnRace'],
        isOnLocation: json['isOnLocation'],
        isOnShop: json['isOnShop'],
        isPopular: json['isPopular'],
        notation: json['notation'],
        places: json['places'],
        doors: json['doors'],
        airConditioner: json['airConditioner'],
        transmission: json['transmission'],
        engine: json['engine'],
        assuranceIssueDate: json['assuranceIssueDate'] != null
            ? DateTime.parse(json['assuranceIssueDate'])
            : null,
        assuranceExpiryDate: json['assuranceExpiryDate'] != null
            ? DateTime.parse(json['assuranceExpiryDate'])
            : null,
        assurance: json['assurance'],
        technicalVisitIssueDate: json['technicalVisitIssueDate'] == null
            ? null
            : DateTime.parse(json['technicalVisitIssueDate']),
        technicalVisitExpiryDate: json['technicalVisitExpiryDate'] == null
            ? null
            : DateTime.parse(json['technicalVisitExpiryDate']),
        technicalVisit: json['technicalVisit'],
        tvmIssueDate: json['tvmIssueDate'] == null
            ? null
            : DateTime.parse(json['tvmIssueDate']),
        tvmExpiryDate: json['tvmExpiryDate'] == null
            ? null
            : DateTime.parse(json['tvmExpiryDate']),
        tvm: json['tvm'],
        state: json['state'],
        score: json['score'],
        caracteristique: json['caracteristique'],
        metreCube: json['metreCube'],
        poids: json['poids'],
        type: json['type'],
        twoHours: json['twoHours'],
        sixHours: json['sixHours'],
        twelveHours: json['twelveHours'],
        days: json['days'],
        popularDays: json['popularDays'],
        popularStartDate: json['popularStartDate'] == null
            ? null
            : DateTime.parse(json['popularStartDate']),
        popularEndDate: json['popularEndDate'] == null
            ? null
            : DateTime.parse(json['popularEndDate']),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        carPhotos: photos,
        payments: paymentsList,
        // accidents: accidentsList,
        // maintenances: maintenancesList,
        assurances: assurancesList,
        technicalVisits: technicalVisitsList,
        tvms: tvmsList,
        owner:
            json['owner'] != null ? OwnerModel.fromJson(json['owner']) : null);
  }
}
