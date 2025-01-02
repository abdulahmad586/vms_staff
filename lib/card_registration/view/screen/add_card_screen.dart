import 'package:flutter/material.dart';
import 'package:shevarms_user/card_registration/card_registration.dart';
import 'package:shevarms_user/shared/shared.dart';

class AddCardScreen extends StatefulWidget {
  final Function(CardModel)? onCardAdded;
  final CardModel? card;
  final String cardType;
  const AddCardScreen(this.cardType, {super.key, this.card, this.onCardAdded});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final TextEditingController serialNumber = TextEditingController();

  final TextEditingController qrCode = TextEditingController();

  final TextEditingController rfidCode = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();

  final qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();

  @override
  void initState() {
    serialNumber.text = widget.card?.sno ?? "";
    qrCode.text = widget.card?.qrCode ?? "";
    rfidCode.text = widget.card?.rfid ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void scanQRCode() {
      qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
        context: context,
        onCode: (code) {
          qrCode.text = code.toString();
        },
      );
    }

    void readRFID() {
      Alert.showModal(
          context,
          SizedBox(
              height: 500, child: RFIDReader((text) => rfidCode.text = text)));
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.card == null ? "ADD CARD" : "EDIT CARD",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryColor,
                    fontFamily: 'Iceberg',
                  ))),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height - 90,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Card(
                      child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.add_card_outlined,
                      size: 70,
                    ),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Add Card",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AppTextField(
                    labelText: "Card Serial No.",
                    hintText: "Enter Serial Number",
                    controller: serialNumber,
                    keyboardType: TextInputType.number,
                    validator: (s) {
                      if (s == null || s.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AppTextField(
                    labelText: "QR Code",
                    hintText: "Tap to scan QR code",
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: qrCode,
                    onTap: scanQRCode,
                    suffixIcon: CustomIconButton(
                      Icons.qr_code_2_outlined,
                      onPressed: scanQRCode,
                    ),
                    validator: (s) {
                      if (s == null || s.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AppTextField(
                    labelText: "RFID",
                    hintText: "Tap to scan RFID",
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: rfidCode,
                    validator: (s) {
                      if (s == null || s.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                    onTap: readRFID,
                    suffixIcon: CustomIconButton(
                      Icons.network_check_sharp,
                      onPressed: readRFID,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  if (widget.card != null)
                    AppTextButton(
                        label: "SAVE CARD",
                        width: 100,
                        buttonColor: AppColors.primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          Navigator.pop(
                              context,
                              CardModel(
                                  id: widget.card!.id,
                                  sno: serialNumber.text,
                                  rfid: rfidCode.text,
                                  type: widget.cardType,
                                  qrCode: qrCode.text));
                        }),
                  if (widget.card == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppTextButton(
                            label: "ADD ANOTHER",
                            width: 120,
                            buttonColor: AppColors.secondaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              if (!formKey.currentState!.validate()) return;
                              widget.onCardAdded?.call(CardModel(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                sno: serialNumber.text,
                                rfid: rfidCode.text,
                                qrCode: qrCode.text,
                                type: widget.cardType,
                              ));
                              serialNumber.clear();
                              rfidCode.clear();
                              qrCode.clear();
                            }),
                        AppTextButton(
                            label: "ADD CARD",
                            width: 120,
                            buttonColor: AppColors.primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              if (!formKey.currentState!.validate()) return;
                              Navigator.pop(
                                  context,
                                  CardModel(
                                      id: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      sno: serialNumber.text,
                                      rfid: rfidCode.text,
                                      type: widget.cardType,
                                      qrCode: qrCode.text));
                            }),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
