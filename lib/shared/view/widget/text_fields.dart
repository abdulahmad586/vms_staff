import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:textfield_datepicker/textfield_datepicker.dart';

import '../../constant/constant.dart';

class AppTextField extends StatelessWidget {
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final double? widthPercentage;
  final double? width;
  final String? hintText;
  final String? labelText;
  final IconData? icon;
  final Widget? prefixIcon, suffixIcon;
  final bool? hidePassword;
  final bool? enabled, autoFocus;
  final Color? itemsColor, fillColor;
  final int? minLines, maxLines, maxLength;
  final TextEditingController? controller;
  final Function()? onTap;
  final Function()? onTapOutside;
  final Function()? onEditingComplete;
  final Function(String)? onChange;
  final String? initialValue;

  const AppTextField({
    super.key,
    this.focusNode,
    this.keyboardType,
    this.validator,
    this.widthPercentage,
    this.width,
    this.hintText,
    this.labelText,
    this.icon,
    this.suffixIcon,
    this.prefixIcon,
    this.fillColor,
    this.hidePassword,
    this.enabled,
    this.autoFocus,
    this.itemsColor,
    this.minLines,
    this.maxLines,
    this.controller,
    this.onEditingComplete,
    this.onChange,
    this.onTap,
    this.onTapOutside,
    this.initialValue,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 350,
      ),
      child: SizedBox(
          width: width ??
              ((widthPercentage ?? 100) / 100) *
                  MediaQuery.of(context).size.width,
          child: TextFormField(
            focusNode: focusNode,
            initialValue: initialValue,
            obscureText: hidePassword ?? false,
            enabled: enabled,
            minLines: minLines,
            maxLines: maxLines ?? 1,
            maxLength: maxLength,
            onTap: onTap,
            onChanged: onChange,
            validator: validator ??
                (value) {
                  return null;
                },
            onTapOutside: onTapOutside == null
                ? null
                : (p) {
                    onTapOutside!();
                  },
            keyboardType: keyboardType,
            onEditingComplete: onEditingComplete,
            autofocus: autoFocus ?? false,
            style: Theme.of(context).textTheme.bodyMedium,
            controller: controller,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              isDense: true,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon ??
                  (icon == null
                      ? null
                      : Icon(
                          icon,
                          size: 15,
                          color: itemsColor,
                        )),
              hintText: hintText,
              labelText: labelText,
              fillColor: fillColor ?? Theme.of(context).highlightColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.red[100]!, width: 1.0),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          )),
    );
  }
}

class AppTextDropdown extends StatelessWidget {
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final double? widthPercentage;
  final double? width;
  final String? hintText;
  final String? labelText;
  final IconData? icon;
  final Widget? suffixIcon;
  final bool? hidePassword;
  final List<String> list;
  final void Function(dynamic)? onChanged;
  final bool? enableSearch, isEnabled;
  final dynamic initialValue;
  final Color? fillColor;

  const AppTextDropdown({
    super.key,
    this.keyboardType,
    this.validator,
    this.widthPercentage,
    this.width,
    this.hintText,
    this.labelText,
    this.icon,
    this.suffixIcon,
    this.hidePassword,
    required this.list,
    this.onChanged,
    this.enableSearch,
    this.initialValue,
    this.isEnabled,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width ??
            ((widthPercentage ?? 100) / 100) *
                MediaQuery.of(context).size.width,
        child: DropDownTextField(
          validator: validator ??
              (value) {
                return null;
              },
          keyboardType: keyboardType,
          // style: Theme.of(context).textTheme.labelLarge,
          searchDecoration: InputDecoration(hintText: hintText),
          onChanged: onChanged,
          isEnabled: isEnabled ?? true,
          enableSearch: enableSearch ?? true,
          initialValue: initialValue,
          textFieldDecoration: getDecoration(
            context,
            fillColor: fillColor,
            hintText: hintText,
            icon: icon,
            suffixIcon: suffixIcon,
            labelText: labelText,
          ),
          dropDownList: List.generate(
              list.length,
              (index) =>
                  DropDownValueModel(name: list[index], value: list[index])),
        ));
  }
}

InputDecoration getDecoration(BuildContext context,
    {Widget? suffixIcon,
    IconData? icon,
    String? hintText,
    Color? labelColor,
    Color? fillColor,
    String? labelText}) {
  return InputDecoration(
    isDense: true,
    suffixIcon: suffixIcon ?? (icon == null ? null : Icon(icon, size: 15)),
    hintText: hintText,
    labelText: labelText,
    // hintStyle: Theme.of(context).textTheme.bodyMedium,
    fillColor: fillColor ?? Theme.of(context).highlightColor,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.red[100]!, width: 1.0),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryColor, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
}

class AppSearchField extends StatelessWidget {
  AppSearchField(
      {required this.loader,
      required this.itemBuilder,
      this.keyboardType,
      this.validator,
      this.widthPercentage,
      this.width,
      this.hintText,
      this.labelText,
      this.icon,
      this.suffixIcon,
      this.hidePassword,
      this.enabled,
      this.autoFocus,
      this.itemsColor,
      this.minLines,
      this.maxLines,
      this.controller,
      this.onEditingComplete,
      this.onSuggestionSelected,
      this.fillColor,
      this.onChange,
      this.onTap});
  Future<List<dynamic>> Function(String) loader;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final double? widthPercentage;
  final double? width;
  final String? hintText;
  final String? labelText;
  final IconData? icon;
  final Widget? suffixIcon;
  final bool? hidePassword;
  final bool? enabled, autoFocus;
  final Color? itemsColor, fillColor;
  final int? minLines, maxLines;
  final TextEditingController? controller;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final dynamic Function(dynamic)? onSuggestionSelected;
  final Function(String)? onChange;
  final Widget Function(BuildContext, dynamic) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ??
          ((widthPercentage ?? 100) / 100) * MediaQuery.of(context).size.width,
      child: TypeAheadField(
        builder: (BuildContext context, TextEditingController controller,
            FocusNode focusNode) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: getDecoration(
              context,
              fillColor: fillColor,
              hintText: hintText,
              icon: icon,
              suffixIcon: suffixIcon,
              labelText: labelText,
            ),
          );
        },
        /*textFieldConfiguration: TextFieldConfiguration(
          // autofocus: true,
          style: DefaultTextStyle.of(context)
              .style
              .copyWith(fontStyle: FontStyle.italic),
          decoration: InputDecoration(
            alignLabelWithHint: true,
            isDense: true,
            suffixIcon: suffixIcon ??
                (icon == null
                    ? null
                    : Icon(
                  icon,
                  size: 15,
                  color: itemsColor,
                )),
            hintText: hintText,
            labelText: labelText,
            fillColor: fillColor?? Theme.of(context).highlightColor.withAlpha(30),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.red[100]!, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),*/
        suggestionsCallback: (pattern) async {
          return await loader(pattern);
        },
        itemBuilder: itemBuilder,
        onSelected: onSuggestionSelected ?? (s) {},
      ),
    );
  }
}

class AppTextDateField extends StatelessWidget {
  final String? Function(String?)? validator;
  final double? widthPercentage;
  final double? width;
  final String? hintText;
  final String? labelText;
  final IconData? icon;
  final Widget? suffixIcon;
  final bool? enabled, autoFocus;
  final Color? itemsColor, fillColor;
  final int? minLines, maxLines;
  final TextEditingController? controller;
  final Function()? onTap;
  final Function()? onTapOutside;
  final Function()? onEditingComplete;
  final Function(DateTime)? onChange;
  final DateTime? initialValue;
  final DateTime? minimumDate;
  final int? minimumYear;

  const AppTextDateField({
    super.key,
    this.validator,
    this.widthPercentage,
    this.width,
    this.hintText,
    this.labelText,
    this.icon,
    this.suffixIcon,
    this.fillColor,
    this.enabled,
    this.autoFocus,
    this.itemsColor,
    this.minLines,
    this.maxLines,
    this.controller,
    this.onEditingComplete,
    this.onChange,
    this.onTap,
    this.onTapOutside,
    this.initialValue,
    this.minimumDate,
    this.minimumYear,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController ctrl = controller ??
        TextEditingController.fromValue(TextEditingValue(
            text: initialValue == null
                ? ""
                : "${initialValue?.day}/${initialValue?.month}/${initialValue?.year}"));
    ctrl.addListener(() {
      if (ctrl.text.isNotEmpty) {
        onChange?.call(DateTime.parse(ctrl.text));
      }
    });

    return Container(
      constraints: const BoxConstraints(maxWidth: 350),
      child: SizedBox(
        width: (width ??
            ((widthPercentage ?? 100) / 100) *
                MediaQuery.of(context).size.width),
        child: TextfieldDatePicker(
          textfieldDatePickerMargin: EdgeInsets.zero,
          textfieldDatePickerPadding: EdgeInsets.zero,
          cupertinoDatePickerBackgroundColor: Colors.white,
          cupertinoDatePickerMaximumDate: DateTime(2099),
          cupertinoDatePickerMaximumYear: 2099,
          cupertinoDatePickerMinimumYear: minimumYear ?? 1930,
          cupertinoDatePickerMinimumDate: minimumDate ?? DateTime(1930),
          cupertinoDateInitialDateTime: DateTime.now(),
          materialDatePickerFirstDate: minimumDate ?? DateTime(1930),
          materialDatePickerInitialDate: DateTime.now(),
          materialDatePickerLastDate: DateTime(2099),
          preferredDateFormat: DateFormat('yyyy-MM-dd'),
          textfieldDatePickerController: ctrl,
          validator: validator,
          onEditingComplete: onEditingComplete,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          textCapitalization: TextCapitalization.sentences,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            isDense: true,
            suffixIcon:
                suffixIcon ?? (icon == null ? null : Icon(icon, size: 15)),
            hintText: hintText,
            labelText: labelText,
            fillColor: Theme.of(context).highlightColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.red[100]!, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ),
    );
  }
}

class AppDateTimeField extends StatelessWidget {
  final String? Function(String?)? validator;
  final double? widthPercentage;
  final double? width;
  final String? hintText;
  final String? labelText;
  final IconData? icon;
  final Widget? suffixIcon;
  final bool? enabled, autoFocus;
  final Color? itemsColor, fillColor;
  final int? minLines, maxLines;
  final TextEditingController? controller;
  final Function()? onTapOutside;
  final Function()? onEditingComplete;
  final Function(DateTime)? onChange;
  final DateTime? initialValue;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  const AppDateTimeField({
    super.key,
    this.validator,
    this.widthPercentage,
    this.width,
    this.hintText,
    this.labelText,
    this.icon,
    this.suffixIcon,
    this.fillColor,
    this.enabled = true,
    this.autoFocus = false,
    this.itemsColor,
    this.minLines,
    this.maxLines,
    this.controller,
    this.onEditingComplete,
    this.onChange,
    this.onTapOutside,
    this.initialValue,
    this.minimumDate,
    this.maximumDate,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController ctrl = controller ??
        TextEditingController(
          text: initialValue != null
              ? DateFormat('yyyy-MM-dd HH:mm a').format(initialValue!)
              : '',
        );

    return Container(
      constraints: const BoxConstraints(maxWidth: 350),
      child: SizedBox(
        width: width ??
            ((widthPercentage ?? 100) / 100) *
                MediaQuery.of(context).size.width,
        child: TextFormField(
          controller: ctrl,
          autofocus: autoFocus ?? false,
          enabled: enabled,
          validator: validator,
          onTapOutside: (_) => onTapOutside?.call(),
          readOnly: true,
          onTap: () async {
            DateTime? dateTime = await showOmniDateTimePicker(
              context: context,
              initialDate: initialValue ?? DateTime.now(),
              firstDate: minimumDate ?? DateTime(1930),
              lastDate: maximumDate ?? DateTime(2099),
              is24HourMode: false,
              isForce2Digits: true,
              minutesInterval: 1,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              transitionBuilder: (context, anim1, anim2, child) {
                return FadeTransition(opacity: anim1, child: child);
              },
            );

            if (dateTime != null) {
              ctrl.text = DateFormat('yyyy-MM-dd HH:mm a').format(dateTime);
              onChange?.call(dateTime);
            }
          },
          onEditingComplete: () => onEditingComplete?.call(),
          decoration: InputDecoration(
            isDense: true,
            suffixIcon:
                suffixIcon ?? (icon == null ? null : Icon(icon, size: 15)),
            hintText: hintText ?? 'Select date and time',
            labelText: labelText,
            fillColor: fillColor ?? Theme.of(context).highlightColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.red[100]!, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ),
    );
  }
}
