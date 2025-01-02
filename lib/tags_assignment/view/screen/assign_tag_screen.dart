import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/visitor_enrolment/visitor_enrolment.dart';
import 'package:shimmer/shimmer.dart';

class AssignTagScreen extends StatefulWidget{

  final VisitorModel visitor;
  const AssignTagScreen({super.key, required this.visitor});

  @override
  State<AssignTagScreen> createState() => _AssignTagScreenState();
}

class _AssignTagScreenState extends State<AssignTagScreen> {

  final TextEditingController idController = TextEditingController();
  bool processing= false;
  final FocusNode idNode = FocusNode();

  @override
  void dispose() {
    idController.dispose();
    idNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final buttonSize = (MediaQuery.of(context).size.width / 2) -80;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assign Tag',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CardImage(imageString: widget.visitor.picture, size: const Size(100,100), radius:50),
              const SizedBox(height:10),
              Text(
                [widget.visitor.firstName, widget.visitor.lastName].join(" "),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryColor, fontFamily: 'Iceberg'),
              ),
              Text(
                widget.visitor.userType.name.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold,fontFamily: 'Iceberg'),
              ),
              const SizedBox(height:20),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("Assign Card"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SCAN RFID CARD",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primaryColor, fontFamily: 'Iceberg'),
                      ),
                      const SizedBox(height:10),
                      RawKeyboardListener(
                        focusNode: idNode,
                        autofocus: true,
                        onKey: (key){
                          idController.text =idController.text+ (key.character??'');
                          if(key.data.logicalKey.keyLabel.toString() == 'Enter'){
                            debouncer(const Duration(milliseconds:500), ()=>setCardPin());
                          }
                        },

                        child: Shimmer.fromColors(
                          baseColor: processing?AppColors.primaryColor: Colors.grey,
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
                            onEditingComplete: (){
                              setCardPin();
                            },
                            itemsColor: processing ? null : AppColors.primaryColor,
                            keyboardType: TextInputType.name,
                            controller: idController,
                            icon: processing ? Icons.more_horiz : Icons.credit_card,
                            hintText: "Scan Card",
                            enabled: false,
                            widthPercentage: 90,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height:20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     AppTextButton(label: "Approve", width: buttonSize, disabled: idController.text.isEmpty, buttonColor: Theme.of(context).primaryColor, onPressed: (){
              //       if(idController.text.isEmpty){
              //         Alert.toast(context, message: "Please assign a visitor's card");
              //         return;
              //       }else{
              //         NavUtils.navTo(context, SuccessPage(message:"Visitor checked in successfully",onContinue: (context){
              //           Navigator.pop(context,widget.visitor);
              //           Navigator.pop(context,widget.visitor);
              //         }));
              //       }
              //     }),
              //     AppTextButton(label: "Reject", width: buttonSize, buttonColor: Colors.red, onPressed: (){
              //       Navigator.pop(context);
              //     })
              //   ],
              // ),
              AppTextButton(label: "Assign Tag", width: buttonSize, buttonColor: Theme.of(context).primaryColor, textColor: Colors.white, onPressed: (){
                Navigator.pop(context);
              })
            ],
          ),
        ),
      ),
    );
  }

  Timer? canceller;
  void debouncer(Duration delay,Function fn) {
    if (canceller?.isActive ?? false) canceller?.cancel();
    canceller = Timer(delay, () {
      fn();
    });
  }

  void hideKeyboard(){
    setState(() {
      SystemChannels.textInput
          .invokeMethod('TextInput.hide');
    });
  }

  void setCardPin(){

  }
}