import 'dart:convert';

import 'package:bs_flutter_datatable_2/bs_flutter_datatable.dart';

abstract class BsDatatableSource {
  BsDatatableSource({List<Map<String, dynamic>>? data, BsDatatableResponse? response, BsDatatableController? controller}) {
    if (data != null) _data = data;

    if (response == null) response = BsDatatableResponse(data: List.from([]));

    _response = response;

    if (data != null) _response.data.insertAll(0, data);

    if (controller == null) controller = BsDatatableController();

    _controller = controller;
  }

  List<Map<String, dynamic>> _data = List<Map<String, dynamic>>.empty(growable: true);
  List<String> _responseData = List<String>.empty(growable: true);
  List<String> _deletedData = List<String>.empty(growable: true);

  /// Variable to handle response from jQuery datatable.net
  BsDatatableResponse _response = BsDatatableResponse(data: List.empty(growable: true));

  /// Variable to save datatable config
  BsDatatableController _controller = BsDatatableController();

  BsDatatableResponse get response => _response;
  set response(BsDatatableResponse value) => _response = value;

  BsDatatableController get controller => _controller;
  set controller(BsDatatableController value) => _controller = controller;

  /// Get count data from [response]
  int get countData => response.countData;

  /// Get count filtered data from [response]
  int get countFiltered => response.countFiltered;

  /// Get count data in page using [response].data length
  int get countDataPage => response.data.length;

  /// Set row widgets
  BsDataRow getRow(int index);

  void update(List<Map<String, dynamic>>? values) {
    if (values != null) _data = values;

    controller.reload(clearData: false);
  }

  void clear() {
    _data.clear();

    controller.reload(clearData: false);
  }

  void insert(int index, Map<String, dynamic> element) {
    _data.insert(index, element);
    controller.reload(clearData: false);
  }

  void add(Map<String, dynamic> value) {
    _data.add(value);
    controller.reload(clearData: false);
  }

  dynamic get(int index) {
    if (_data[index] != null) return _data[index];

    return null;
  }

  void put(int index, Map<String, dynamic> value) {
    if (_data.contains(index)) _data[index] = value;

    controller.reload(clearData: false);
  }

  void removeAt(int index) {
    _deletedData.add(jsonEncode(_data[index]));
    _data.removeAt(index);
    controller.reload(clearData: false);
  }

  void remove(Map<String, dynamic> value) {
    _deletedData.add(jsonEncode(value));
    _data.remove(value);
    controller.reload(clearData: false);
  }

  void addAll(List<Map<String, dynamic>> values) {
    _data.addAll(values);
    controller.reload(clearData: false);
  }

  void insertAll(int index, List<Map<String, dynamic>> iterable) {
    _data.insertAll(index, iterable);
    controller.reload(clearData: false);
  }

  void reload({bool clear = false, List<Map<String, dynamic>> data = const []}) {
    if (clear) {
      _data.clear();
      _responseData.clear();
    }

    if (data.length > 0) {
      data.forEach((responseData) {
        if (!_responseData.contains(jsonEncode(responseData))) {
          _responseData.add(jsonEncode(responseData));
          _data.add(responseData);
        }
      });
    }

    List<Map<String, dynamic>> currentDataFiltered = _data.where((data) {
      bool matched = false;
      for (int i = 0; i < controller.columns.length; i++) {
        bool datamatched = false;
        Map<String, String> column = controller.columns[i];

        if (column['searchable'] == 'true') {
          if (data[column['name']] != null) {
            String field = data[column['name']].toString().toLowerCase().trim();
            String value = controller.searchValue.toLowerCase().trim();

            if (field.contains(value)) {
              datamatched = true;
            }
          }

          matched = datamatched;

          if (datamatched) break;
        }
      }

      return matched;
    }).toList();

    List<Map<String, dynamic>> currentData = currentDataFiltered.skip(controller.start).take(controller.length).toList();
    _response = BsDatatableResponse(
        data: clear ? response.data : currentData,
        countData: clear ? response.countData : _data.length,
        countFiltered: clear ? response.countFiltered : currentDataFiltered.length);
  }
}
