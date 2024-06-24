import 'package:bs_flutter_datatable_2/bs_flutter_datatable.dart';
import 'package:flutter/material.dart';

Function(dynamic, int, List<Map<String, dynamic>>, BsDatatableSource) datatablesListener = (value, index, sources, source) {};

class ExampleSource extends BsDatatableSource {
  ExampleSource({
    List<Map<String, dynamic>> data = const [],
    Function(dynamic, int, List<Map<String, dynamic>>, BsDatatableSource)? editListener,
    Function(dynamic, int, List<Map<String, dynamic>>, BsDatatableSource)? deleteListener,
  })  : onEditListener = editListener ?? datatablesListener,
        onDeleteListener = deleteListener ?? datatablesListener,
        super(data: data);

  Function(dynamic, int, List<Map<String, dynamic>>, BsDatatableSource) onEditListener = (value, index, sources, source) {};
  Function(dynamic, int, List<Map<String, dynamic>>, BsDatatableSource) onDeleteListener = (value, index, sources, source) {};

  static List<BsDataColumn> get columns => <BsDataColumn>[
        BsDataColumn(label: Text('No'), orderable: false, searchable: false, width: 100.0),
        BsDataColumn(label: Text('Code'), columnName: 'typecd', width: 200.0),
        BsDataColumn(label: Text('Name'), columnName: 'typenm'),
        BsDataColumn(label: Text('Aksi'), orderable: false, searchable: false, width: 200.0),
      ];

  @override
  BsDataRow getRow(int index) {
    return BsDataRow(index: index, cells: <BsDataCell>[
      BsDataCell(Text('${controller.start + index + 1}')),
      BsDataCell(Text('${response.data[index]['typecd']}')),
      BsDataCell(Text('${response.data[index]['typenm']}')),
      BsDataCell(Row(
        children: [
          // BsButton(
          //   margin: EdgeInsets.only(right: 5.0),
          //   onPressed: () => onEditListener(response.data[index]['typecd'], index, response.data, this),
          //   prefixIcon: Icons.edit,
          //   size: BsButtonSize.btnIconSm,
          //   style: BsButtonStyle.primary,
          // ),
          // BsButton(
          //   onPressed: () => onDeleteListener(response.data[index]['typecd'], index, response.data, this),
          //   prefixIcon: Icons.delete,
          //   size: BsButtonSize.btnIconSm,
          //   style: BsButtonStyle.danger,
          // )
        ],
      ))
    ]);
  }
}
