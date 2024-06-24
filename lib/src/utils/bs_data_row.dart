import 'package:bs_flutter_datatable_2/bs_flutter_datatable.dart';

class BsDataRow {
  const BsDataRow({
    required this.index,
    required List<BsDataCell> cells,
  }) : _cells = cells;

  final int index;

  final List<BsDataCell> _cells;

  List<BsDataCell> getCells() => _cells;
}
