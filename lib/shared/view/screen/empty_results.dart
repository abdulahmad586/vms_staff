import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loading_indicator/loading_indicator.dart';

class EmptyResult extends StatelessWidget {
  EmptyResult({Key? key, this.height, this.width,  this.message = "No records found", this.loading=false})
      : super(key: key);

  final String message;
  final bool loading;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
//    appState = Provider.of<AppState>(context);
    return Scaffold(
      body: SizedBox(
        height:height ?? MediaQuery.of(context).size.height,
        width: width ?? MediaQuery.of(context).size.width,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            loading ? const SizedBox(
              width: 50,
              height: 30,
              child: LoadingIndicator(
                  indicatorType: Indicator.ballScaleRippleMultiple,

                  /// Required, The loading type of the widget
                  colors: [
                    Color(0xff191a19),
                    Color(0xfffd7790),
                    Color(0xffc40019),
                    Color(0xff480101),
                  ],
                  strokeWidth: 2,
                  pathBackgroundColor: Colors.black),
            ) :  const Icon(Icons.hourglass_empty, size: 50,),
            const SizedBox(
              height: 40,
            ),

            Text(
              loading ? 'Loading data' : message ,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontFamily: "Iceberg"),
            ),
            const SizedBox(
              height: 40,
            ),

          ]),
        ),
      ),
    );
  }

}
