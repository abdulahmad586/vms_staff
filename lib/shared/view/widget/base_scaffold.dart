import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as provider;

class BaseScaffold extends StatelessWidget{

  final Widget? body;
  final bool showBack;
  final bool noGradient;
  final Widget? title;
  final String? assetBackgroundImage;
  final Color? appBarBackgroundColor,textAndIconColors;
  final List<Widget>? appBarActions;
  final Widget? floatingActionButton;
  final double? backgroundImageOpacity;
  final AlignmentGeometry? backgroundImageAlignment;
  const BaseScaffold({super.key, this.assetBackgroundImage, this.noGradient=false, this.backgroundImageAlignment, this.backgroundImageOpacity, this.textAndIconColors, this.appBarBackgroundColor, this.body, this.title,this.showBack=false, this.appBarActions, this.floatingActionButton });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: showBack?AppBar(
        backgroundColor: appBarBackgroundColor ?? Colors.white,
        elevation: 0,
        actions: appBarActions,
        iconTheme: textAndIconColors !=null ? IconThemeData(color: textAndIconColors): null,
        titleTextStyle: textAndIconColors !=null ? const TextStyle(color: Colors.white) : null,
        title: title,
        leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
      ):null,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            padding:  const EdgeInsets.all(15),
            decoration:  BoxDecoration(
              color: const Color.fromRGBO(255,255,255, 0.7),
              gradient: noGradient ? null : const LinearGradient(
                colors: [
                  Color.fromRGBO(255, 255, 255, 1.0), // Pure white (100% opacity)
                  Color.fromRGBO(255, 255, 255, 0.7), // White with 70% opacity
                  Color.fromRGBO(255, 255, 255, 0.3), // White with 30% opacity
                  Color.fromRGBO(255, 255, 255, 1.0), // Pure white (100% opacity)
                ],
                stops: [0.0, 0.33, 0.67, 1.0], // Color stops
                begin: Alignment.topRight, // Start from top-right
                end: Alignment.bottomLeft, // End at bottom-left
              ),
              image: assetBackgroundImage == null ? null : DecorationImage(
            image: assetBackgroundImage!.endsWith("svg") ? provider.Svg(assetBackgroundImage!) : Image.asset(assetBackgroundImage!).image,
        alignment: backgroundImageAlignment??Alignment.bottomRight,
        opacity: backgroundImageOpacity??0.1,
        colorFilter: const ColorFilter.linearToSrgbGamma())
            ),
            child: SafeArea(
              child: body??const SizedBox(),
            ),
          ),

        ],
      ),
    );
  }

}