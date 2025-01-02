import 'package:flutter/material.dart';
import 'package:shevarms_user/shared/shared.dart';

class StatWidget extends StatelessWidget {
  final IconData icon;
  final Widget? iconWidget;
  final String label;
  final String display;
  final Color? backgroundColor, iconBackgroundColor, iconColor;
  final double? width, height;
  final bool showShadow;
  final Function()? onClick;

  const StatWidget(
      {required this.icon,
      this.iconWidget,
      required this.label,
      this.display = "",
      this.width,
      this.height,
      this.backgroundColor,
      this.iconBackgroundColor,
      this.iconColor,
      this.onClick,
      this.showShadow = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color.fromARGB(70, 255, 152, 0),
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                      color: Colors.grey[300]!,
                      blurRadius: 17.0,
                      offset: const Offset(-10, 10))
                ]
              : [],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        iconWidget ??
                            ColorIconButton(
                              "",
                              icon,
                              iconBackgroundColor ??
                                  AppColors
                                      .primaryColor, //Color.fromARGB(255, 243, 228, 192),
                              iconColor: iconColor ?? Colors.white,
                              iconSize: 15,
                              showShadow: false,
                            ),
                        const SizedBox()
                      ]),
                  const SizedBox(height: 10.0),
                  Text(
                    label,
                    style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            if (display.isNotEmpty)
              Text(
                display,
                style: const TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}

class DashboardStatWidget extends StatelessWidget {
  final IconData icon;
  final Widget? iconWidget;
  final String label;
  final String display, display2;
  final Color? backgroundColor, iconBackgroundColor, iconColor, textColor;
  final double? width, height;
  final bool showShadow;
  final Function()? onClick;

  const DashboardStatWidget(
      {required this.icon,
      this.iconWidget,
      required this.label,
      this.display = "",
      this.display2 = "",
      this.width,
      this.height,
      this.backgroundColor,
      this.iconBackgroundColor,
      this.textColor,
      this.iconColor,
      this.onClick,
      this.showShadow = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color.fromARGB(70, 255, 152, 0),
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                      color: Colors.grey[300]!,
                      blurRadius: 17.0,
                      offset: const Offset(-10, 10))
                ]
              : [],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        iconWidget ??
                            ColorIconButton(
                              "",
                              icon,
                              iconBackgroundColor ??
                                  AppColors
                                      .primaryColor, //Color.fromARGB(255, 243, 228, 192),
                              iconColor: iconColor ?? Colors.white,
                              iconSize: 15,
                              showShadow: false,
                            ),
                        const SizedBox()
                      ]),
                  const SizedBox(height: 10.0),
                  Text(
                    label,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: textColor ?? Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            if (display.isNotEmpty)
              Column(
                children: [
                  if (display2.isNotEmpty)
                    Text(
                      display2,
                      style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  Text(
                    display,
                    style: TextStyle(
                        fontSize: 30.0,
                        color: textColor ?? Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
