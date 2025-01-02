import 'package:flutter/material.dart';
import 'package:shevarms_user/shared/shared.dart';

class ReportingCard extends StatelessWidget{

  final VoidCallback onReport;
  const ReportingCard({super.key, required this.onReport});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 17.0,
                offset: const Offset(-10, 10))
          ]
      ),
      child: Row(
        children: [
          const Padding( padding:EdgeInsets.symmetric(horizontal: 5), child: Icon(Icons.record_voice_over, size: 30, color: Colors.white,)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Found inaccuracies in a project?", maxLines: 1, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight:FontWeight.bold, color:Colors.white),),
                const SizedBox(height: 5,),
                Text("Let us know through a direct link!", maxLines: 1, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight:FontWeight.normal, color: Colors.grey[200]),),
              ],
            ),
          ),
          AppTextButton(label: "Report",
              buttonColor: AppColors.primaryColor,
              textColor: Colors.white,
              borderRadius:15,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              onPressed: onReport
          )
        ],
      ),
    );
  }

}