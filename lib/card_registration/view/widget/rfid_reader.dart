import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shimmer/shimmer.dart';

class RFIDReader extends StatefulWidget {
  final Function(String text) onRead;
  const RFIDReader(this.onRead, {super.key});

  @override
  State<RFIDReader> createState() => _RFIDReaderState();
}

class _RFIDReaderState extends State<RFIDReader> {
  bool processing = false;
  TextEditingController idController = TextEditingController();
  final FocusNode idNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      idNode.requestFocus();
    });
  }

  @override
  void dispose() {
    idController.dispose();
    idNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RFID Reader',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              SizedBox(
                  height: 200,
                  width: 250,
                  child: SvgPicture.asset(
                    AssetConstants.scanCard,
                    width: 100,
                  )),
              const SizedBox(height: 10),
              Text(
                'Please scan user\'s RFID card',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KeyboardListener(
                    focusNode: idNode,
                    autofocus: true,
                    onKeyEvent: (key) {
                      idController.text =
                          idController.text + (key.character ?? '');
                      if (key.logicalKey.keyLabel.toString() == 'Enter') {
                        debouncer(const Duration(milliseconds: 500), () {
                          widget.onRead(idController.text);
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: Shimmer.fromColors(
                      baseColor:
                          processing ? AppColors.primaryColor : Colors.grey,
                      highlightColor: Colors.grey[900]!,
                      enabled: processing,
                      child: AppTextField(
                        hidePassword: true,
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Key cannot be blank';
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          widget.onRead(idController.text);
                          Navigator.pop(context);
                        },
                        itemsColor: processing ? null : AppColors.primaryColor,
                        keyboardType: TextInputType.name,
                        controller: idController,
                        icon: processing
                            ? Icons.more_horiz
                            : Icons.verified_user_sharp,
                        hintText: 'Scan for ID',
                        enabled: false,
                        widthPercentage: 90,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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

  void hideKeyboard() {
    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }
}
