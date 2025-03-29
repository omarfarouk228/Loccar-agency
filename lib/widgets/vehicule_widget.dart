// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:loccar_agency/models/car.dart';
// import 'package:loccar_agency/utils/colors.dart';
// import 'package:badges/badges.dart' as badges;

// class VehiculeWidget extends StatefulWidget {
//   final ModelVehicle vehicle;
//   final bool badge;

//   final VoidCallback onPressed;

//   const VehiculeWidget(
//       {super.key,
//       required this.vehicle,
//       required this.badge,
//       required this.onPressed});

//   @override
//   State<VehiculeWidget> createState() => _VehiculeWidgetState();
// }

// class _VehiculeWidgetState extends State<VehiculeWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onPressed,
//       child: Card(
//           elevation: 8,
//           child: widget.badge
//               ? badges.Badge(
//                   badgeContent: const Text(
//                     '!',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   badgeStyle:
//                       badges.BadgeStyle(badgeColor: AppColors.secondaryColor),
//                   position: badges.BadgePosition.topEnd(top: -10, end: -5),
//                   child: ListTile(
//                       title: Text(
//                         "${widget.vehicle.marque}  ${widget.vehicle.model}",
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle:
//                           Text("Numéro de plaque: ${widget.vehicle.plaque}"),
//                       leading: CircleAvatar(
//                           backgroundColor: AppColors.primaryColor,
//                           radius: 25,
//                           child: const Padding(
//                             padding: EdgeInsets.all(3.0),
//                             child: FaIcon(
//                               FontAwesomeIcons.car,
//                               color: Colors.white,
//                               size: 25,
//                             ),
//                           )),
//                       trailing: GestureDetector(
//                         onTap: widget.onPressed,
//                         child: Container(
//                             width: 50,
//                             height: 30,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: AppColors.primaryColor,
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             child: const FaIcon(
//                               FontAwesomeIcons.eye,
//                               size: 15,
//                               color: Colors.white,
//                             )),
//                       )))
//               : ListTile(
//                   title: Text(
//                     "${widget.vehicle.marque}  ${widget.vehicle.model}",
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text("Numéro de plaque: ${widget.vehicle.plaque}"),
//                   leading: CircleAvatar(
//                       backgroundColor: AppColors.primaryColor,
//                       radius: 25,
//                       child: const Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: FaIcon(
//                           FontAwesomeIcons.car,
//                           color: Colors.white,
//                           size: 25,
//                         ),
//                       )),
//                   trailing: GestureDetector(
//                     onTap: widget.onPressed,
//                     child: Container(
//                         width: 50,
//                         height: 30,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryColor,
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         child: const FaIcon(
//                           FontAwesomeIcons.eye,
//                           size: 15,
//                           color: Colors.white,
//                         )),
//                   ))),
//     );
//   }
// }
