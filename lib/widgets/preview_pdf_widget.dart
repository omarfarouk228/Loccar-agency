import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loccar_agency/utils/colors.dart';

class PreviewPDFWidget extends StatelessWidget {
  final String url;
  const PreviewPDFWidget(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lecture du document"),
      ),
      body: const PDF(swipeHorizontal: true).cachedFromUrl(
        url,
        placeholder: (double progress) => Center(
          child: SpinKitCubeGrid(
            color: AppColors.primaryColor,
            size: 40.0,
          ),
        ),
        errorWidget: (dynamic error) =>
            const Center(child: Text("Impossible d'ouvrir ce document")),
      ),
    );
  }
}
