import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shevarms_user/shared/constant/constant.dart';

class AppTextButton extends StatelessWidget {
  AppTextButton(
      {Key? key,
      required this.label,
      required this.onPressed,
      this.buttonColor,
      this.textColor,
      this.loading = false,
      this.disabled = false,
      this.icon,
      this.padding,
      this.borderRadius,
      this.width})
      : super(key: key);
  final String label;
  final bool loading;
  final bool disabled;
  final Function() onPressed;
  final Color? buttonColor, textColor;
  final double? width;
  final double? borderRadius;
  final IconData? icon;
  final EdgeInsets? padding;

  @override
  build(BuildContext context) {
    const double maxWidth = 350;
    return Container(
      constraints: const BoxConstraints(
        maxWidth: maxWidth+40,
      ),
      child: RawMaterialButton(
        fillColor: disabled ? buttonColor?.withOpacity(0.2) : buttonColor,
        elevation: disabled ? 0 : 1.0,
        onPressed: disabled ? null : () {
          if (!loading) {
            onPressed();
          }
        },
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 10))),
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                  width: width == null ? null : ( width! > maxWidth ? maxWidth: width),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null)
                        Icon(
                          icon,
                          color: textColor,
                        ),
                      if (icon != null)
                        const SizedBox(
                          width: 10,
                        ),
                      if(!loading)Text(
                        '$label ',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: textColor, fontWeight: FontWeight.bold),
                      ),
                      loading
                          ? const SizedBox(
                              width: 50,
                              height: 15,
                              child: LoadingIndicator(
                                  indicatorType: Indicator.ballClipRotatePulse,
                                  /// Required, The loading type of the widget
                                  colors: [
                                    Colors.white,//AppColors.primaryColorDark,
                                    Colors.grey,AppColors.secondaryColor,
                                    Colors.white,AppColors.primaryColor,
                                  ],
                                  strokeWidth: 2,
                                  pathBackgroundColor: Colors.black))
                          : const SizedBox()
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorIconButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color iconColor, textColor;
  final Color? borderColor;
  final double iconSize, textSize;
  final Function()? onPressed;
  final Widget? badge, child;
  final bool showShadow;
  final String? imageIcon;
  final BoxShape shape;

  const ColorIconButton(this.label, this.icon, this.color,
      {this.borderColor,
      this.child,
      this.iconColor = Colors.white,
      this.textColor = Colors.black,
      this.iconSize = 25,
      this.textSize = 13,
      this.onPressed,
      this.badge,
      this.shape = BoxShape.circle,
      this.showShadow = true,
      this.imageIcon});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      InkWell(
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
        splashColor: color,
        onTap: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(.37 * iconSize),
              decoration: BoxDecoration(
                  border: borderColor == null
                      ? null
                      : Border.all(color: borderColor!),
                  color: color,
                  shape: shape,
                  borderRadius: shape == BoxShape.circle
                      ? null
                      : const BorderRadius.all(Radius.circular(10)),
                  boxShadow: showShadow
                      ? [
                          const BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.15),
                            blurRadius: 10.0,
                          ),
                          const BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.15),
                            blurRadius: 10.0,
                          ),
                        ]
                      : [],
                  image: imageIcon != null
                      ? DecorationImage(
                          image: Image.network(imageIcon!).image,
                          fit: BoxFit.cover)
                      : null),
              child: imageIcon == null
                  ? Center(
                      child: child ??
                          Icon(
                            icon,
                            color: iconColor,
                            size: iconSize,
                          ))
                  : Container(),
            ),
            SizedBox(
              height: (label.isEmpty) ? 0 : 5.0,
            ),
            (label.isEmpty
                ? SizedBox()
                : Text(
                    label,
                    style: TextStyle(color: textColor, fontSize: textSize),
                  )),
          ],
        ),
      ),
      (this.badge == null ? Container() : this.badge!)
    ]);
  }
}
