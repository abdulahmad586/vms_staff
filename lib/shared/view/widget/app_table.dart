import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class AppTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> data;
  final Widget Function(dynamic index)? actionsBuilder;

  const AppTable(
      {super.key,
      required this.columns,
      required this.data,
      this.actionsBuilder});

  @override
  Widget build(BuildContext context) {
    return DataTable2(
        columnSpacing: 10,
        showHeadingCheckBox: true,
        showCheckboxColumn: true,
        horizontalMargin: 12,
        minWidth: MediaQuery.of(context).size.width,
        // border: TableBorder.all(),
        columns: [
          ...columns
              .map(
                (e) => DataColumn2(
                  label: SizedBox(width: 50, child: Text(e)),
                  size: ColumnSize.S,
                ),
              )
              .toList(),
          if (actionsBuilder != null) const DataColumn2(label: Text("Actions"))
        ],
        rows: List<DataRow>.generate(
            data.length,
            (index) => DataRow(cells: [
                  ...data[index]
                      .map((e) => DataCell(
                            SizedBox(child: Text(e)),
                          ))
                      .toList(),
                  if (actionsBuilder != null) DataCell(actionsBuilder!(index))
                ])));
  }
}
