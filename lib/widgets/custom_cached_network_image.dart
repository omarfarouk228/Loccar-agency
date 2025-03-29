import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/widgets/fullscreen_image_widget.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final double borderRadius;

  const CustomCachedNetworkImage(
      {super.key,
      required this.imageUrl,
      required this.height,
      required this.width,
      required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageFullScreenWrapperWidget(
                    child: CachedNetworkImage(imageUrl: imageUrl))));
      },
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        errorWidget: (context, url, error) => Container(
            margin: const EdgeInsets.all(5),
            height: height,
            width: width,
            decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(borderRadius)),
            alignment: Alignment.center,
            child: const FaIcon(
              FontAwesomeIcons.image,
              color: Colors.white,
              size: 25,
            )),
        imageBuilder: (context, imageProvider) => Container(
          margin: const EdgeInsets.all(5),
          height: height,
          width: width,
          decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              border: Border.all(color: AppColors.secondaryColor, width: 1),
              borderRadius: BorderRadius.circular(borderRadius)),
        ),
      ),
    );
  }
}
