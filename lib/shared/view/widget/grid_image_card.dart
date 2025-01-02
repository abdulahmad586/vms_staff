import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

// Widget CardNetworkImage(
//     {Size size = const Size(70, 50),
//     double radius = 5,
//     String? imageString,
//     Widget? child,
//     bool showBorder = false,
//     Color borderColor = Colors.white}) {
//   return CachedNetworkImage(
//     imageUrl: imageString,
//     imageBuilder: (context, imageProvider) => Container(
//         width: size.width,
//         height: (size.height),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(radius)),
//           boxShadow: [BoxShadow(color: borderColor, spreadRadius: 3)],
//           color: imageString == null
//               ? const Color.fromARGB(100, 255, 255, 255)
//               : const Color.fromARGB(0, 0, 0, 0),
//           image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
//         ),
//         child: Center(child: child)),
//   );
// }

Widget CardLocalImage(
    {Size size = const Size(70, 50),
    double radius = 5,
    required String imageString,
    Widget? child,
    Widget? centerWidget,
    bool showBorder = false,
    Color borderColor = Colors.white}) {
  return Stack(
    children: [
      Container(
          width: size.width,
          height: (size.height),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.elliptical(radius, radius)),
            boxShadow: [BoxShadow(color: borderColor, spreadRadius: 3)],
            color: imageString == null
                ? const Color.fromARGB(100, 255, 255, 255)
                : const Color.fromARGB(0, 0, 0, 0),
            image: DecorationImage(
                image: Image.file(File(imageString)).image, fit: BoxFit.cover),
          ),
          child: Center(child: child)),
      Container(
        width: size.width,
        height: size.height,
        child: Center(
          child: centerWidget,
        ),
      )
    ],
  );
}

Widget CardMemoryImage(
    {Size size = const Size(70, 50),
      double radius = 5,
      required Uint8List imageData,
      Widget? child,
      Widget? centerWidget,
      bool showBorder = false,
      Color borderColor = Colors.white}) {
  return Stack(
    children: [
      Container(
          width: size.width,
          height: (size.height),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.elliptical(radius, radius)),
            boxShadow: [BoxShadow(color: borderColor, spreadRadius: 3)],
            color: const Color.fromARGB(0, 0, 0, 0),
            image: DecorationImage(
                image: MemoryImage(imageData), fit: BoxFit.cover),
          ),
          child: Center(child: child)),
      Container(
        width: size.width,
        height: size.height,
        child: Center(
          child: centerWidget,
        ),
      )
    ],
  );
}
