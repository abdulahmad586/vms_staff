import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/visitor_enrolment/visitor_enrolment.dart';

class VisitorSearchScreen extends StatefulWidget {
  const VisitorSearchScreen({super.key});

  @override
  State<VisitorSearchScreen> createState() => _VisitorSearchScreenState();
}

class _VisitorSearchScreenState extends State<VisitorSearchScreen> {
  List<VisitorModel> visitors = [];
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: AppIconButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    icon: Icons.clear,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    // child: Hero(
                    //   tag: 'phoneSearch',
                    child: AppTextField(
                      itemsColor: AppColors.primaryColor,
                      keyboardType: TextInputType.phone,
                      autoFocus: true,
                      onChange: (s) {
                        if (s.length > 3) {
                          debouncer(const Duration(milliseconds: 250),
                              () => searchVisitor(s));
                        } else {
                          setState(() {
                            visitors = [];
                          });
                        }
                      },
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppIconButton(
                          icon: Icons.qr_code_2,
                          width: 20,
                          height: 20,
                          backgroundColor: Theme.of(context).primaryColor,
                          iconColor: Colors.white,
                          onTap: () {
                            _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                              context: context,
                              onCode: (code) {
                                searchVisitor(code ?? "");
                              },
                            );
                          },
                        ),
                      ),
                      hintText: "Phone number",
                      widthPercentage: double.infinity,
                    ),
                  ),
                  // ),
                ),
              ],
            ),
            Expanded(
              child: visitors.isEmpty
                  ? EmptyResult(
                      message: "No records found",
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                          itemCount: visitors.length,
                          itemBuilder: (context, index) {
                            return VisitorListItem(visitors[index],
                                showPhone: true,
                                onTap: () =>
                                    Navigator.pop(context, visitors[index]));
                          }),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Timer? canceller;
  void debouncer(Duration delay, Function fn) {
    if (canceller?.isActive ?? false) canceller?.cancel();
    canceller = Timer(delay, () {
      fn();
    });
  }

  searchVisitor(String s) async {
    try {
      final results = await VisitorsService().searchVisitorsByPhone(s);
      setState(() {
        visitors = results;
      });
    } catch (e) {}
  }
}
