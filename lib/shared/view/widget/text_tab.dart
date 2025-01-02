import 'package:flutter/material.dart';
import 'package:shevarms_user/shared/constant/constant.dart';

class TextTab extends StatelessWidget {
  const TextTab(
      {required this.tabTexts,
      required this.onChange,
      this.activeTab = 0,
      this.spaceBetween = 15});

  final List<String> tabTexts;
  final Function(int) onChange;
  final int activeTab;
  final double spaceBetween;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabTexts.length,
            (index) => tabItem(context, tabTexts[index], index, index == activeTab)),
      ),
    );
  }

  Widget tabItem(BuildContext context, String text, int index, bool active) {
    return GestureDetector(
      onTap: () {
        onChange(index);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: active
            ? const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)))
            : null,
        margin:
            EdgeInsets.symmetric(horizontal: (spaceBetween / 2), vertical: 3),
        child: SizedBox(
          width: 70,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active ? Colors.white : Colors.grey),
          ),
        ),
      ),
    );
  }
}
