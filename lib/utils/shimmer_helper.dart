import 'package:flutter/material.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHelper {
  static Widget getShimmerListModel(context, {int itemCount = 10}) {
    return ListView.builder(
        itemCount: itemCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade400,
            period: const Duration(seconds: 1),
            highlightColor: AppColors.primaryColor.withOpacity(0.3),
            child: ListTile(
              title: Card(
                child: SizedBox(
                    height: 10,
                    width: Dimensions.getScreenWidth(context) * 0.2),
              ),
              subtitle: Card(
                child: SizedBox(
                    height: 10,
                    width: Dimensions.getScreenWidth(context) * 0.5),
              ),
              leading: const CircleAvatar(),
            ),
          );
        });
  }

  static Widget getShimmerDividerModel(context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      period: const Duration(seconds: 1),
      highlightColor: AppColors.primaryColor.withOpacity(0.3),
      child: Card(
        child: Container(
          width: Dimensions.getScreenWidth(context),
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  static Widget getShimmerWithImageListModel(context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade400,
        period: const Duration(seconds: 1),
        highlightColor: AppColors.primaryColor.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.only(right: 3.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Card(
                        child: Container(
                          width: Dimensions.getScreenWidth(context),
                          height: Dimensions.getScreenHeight(context) * 0.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  SizedBox(
                    width: Dimensions.getScreenWidth(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            child: Container(
                              width: Dimensions.getScreenWidth(context) * 0.5,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            child: Container(
                              width: Dimensions.getScreenWidth(context),
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
