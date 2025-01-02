import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class EmergencyButton extends StatefulWidget{

  final Function()? onPressing, onStopPressing, onRecording, onFinishedRecording;

  const EmergencyButton({this.onPressing, this.onStopPressing, this.onRecording, this.onFinishedRecording});

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton> {
  bool pressed =false;
  bool actionStarted = false;

  double pressingTime = 0;
  double actionTime = 0;
  double maxActionTime = 30000;
  double maxPressingTime = 5000;
  late Ticker pressTicker;



  @override
  void initState() {
    super.initState();
    pressTicker = Ticker((elapsed) {

      if(pressingTime >= maxPressingTime){
        // pressTicker.stop(canceled: true);
        if(!actionStarted){
          actionStarted = true;
          print("Recording");
          if(widget.onRecording !=null) widget.onRecording!();
        }
        setState(() {
          pressingTime = 0;
        });
        // if(widget.onPressing != null)widget.onPressing!();
      }else{

        setState(() {
          pressingTime = elapsed.inMilliseconds.toDouble();
          actionTime = elapsed.inMilliseconds.toDouble();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    pressTicker.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(height: 210, width: 210,child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 20, value: (pressingTime/maxPressingTime)),),
        SizedBox(height: 210, width: 210,child: CircularProgressIndicator(color: Colors.redAccent, strokeWidth: 20, value: (actionTime-maxPressingTime)/maxActionTime),),
        GestureDetector(
          onTapDown: (details){
            if(widget.onPressing != null)widget.onPressing!();
            setState(() {
              pressed=true;
            });
            if(!pressTicker.isTicking){
              pressTicker.start();
            }

          },
          onTapUp: (details){
            if(widget.onStopPressing != null)widget.onStopPressing!();
            pressTicker.stop(canceled: true);
            setState(() {
              pressed =false;
              pressingTime = 0;
              actionTime=0;
            });

          },
          child: RedButton(pressed: pressed,),
        )
      ],
    );
  }
}

class RedButton extends StatelessWidget{

  final bool pressed;

  const RedButton({super.key, this.pressed=false});

  @override
  Widget build(BuildContext context) {

    return Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          // color: AppColors.primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(200)),
          gradient: RadialGradient(
            colors: [
              Colors.red[500]!,
              Colors.red[pressed ? 900 : 700]!
              ]
          ),
          boxShadow: [
            const BoxShadow(offset: Offset(0,3),color: Colors.grey, blurRadius: 10, spreadRadius: 2, blurStyle: BlurStyle.outer),
            BoxShadow(offset: const Offset(0,3),color: Colors.grey[400]!, blurRadius: 0, spreadRadius: 5, blurStyle: BlurStyle.solid),
            BoxShadow(offset: const Offset(0,3),color: Colors.grey[400]!, blurRadius: 50, spreadRadius: 7, blurStyle: BlurStyle.outer)
          ]
        ),
        child: const Center(child: Icon(Icons.emergency_share_outlined, size: 50, color: Colors.white,),),
      );
  }

}