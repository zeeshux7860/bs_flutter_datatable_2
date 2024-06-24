import 'dart:convert';

import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';
import 'package:bs_flutter_datatable_example/source.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  final _router = FluroRouter.appRouter;

  MyApp() {
    _router.define('/',
        handler: Handler(
          handlerFunc: (context, parameters) => Datatables(),
        ));
    _router.define('/test',
        handler: Handler(
          handlerFunc: (context, parameters) => Test(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: _router.generator,
    );
  }
}

class Test extends StatelessWidget {
  final _router = FluroRouter.appRouter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            TextButton(
              onPressed: () => _router.navigateTo(context, '/'),
              child: Text('Test'),
            )
          ],
        ),
      ),
    );
  }
}

class Datatables extends StatefulWidget {
  @override
  _DatatablesState createState() => _DatatablesState();
}

class _DatatablesState extends State<Datatables> {
  ExampleSource _source = ExampleSource(data: [
    {'typeid': 0, 'typecd': 'TP1', 'typenm': 'Type Baru'},
  ]);
  ExampleSource _source1 = ExampleSource(
      data: [
        {'typeid': 0, 'typecd': 'TP1', 'typenm': 'Type 1'},
        {'typeid': 0, 'typecd': 'TP2', 'typenm': 'Type 2'},
        {'typeid': 0, 'typecd': 'TP3', 'typenm': 'Type 3'},
        {'typeid': 0, 'typecd': 'TP4', 'typenm': 'Type 4'},
        {'typeid': 0, 'typecd': 'TP5', 'typenm': 'Type 5'},
      ],
      editListener: (value, index, sources, source) {
        final data = source.get(index);
        value['typenm'] = 'Edited';

        source.put(index, data);
      });

  @override
  void initState() {
    _source.controller = BsDatatableController();
    super.initState();
  }

  Future loadApi(Map<String, dynamic> params) {
    return http
        .post(
      Uri.parse('http://localhost/flutter_crud/api/public/types/datatables'),
      body: params,
    )
        .then((value) {
      Map<String, dynamic> json = jsonDecode(value.body);
      setState(() {
        _source.response = BsDatatableResponse.createFromJson(json['data']);
        _source.onEditListener = (typeid, index, sources, source) {
          final data = _source.get(index);
          data['typenm'] = 'Edited';

          _source.put(index, data);
        };
        _source.onDeleteListener = (typeid, index, sources, source) {
          source.removeAt(index);
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Datatables.net'),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Column(children: [
                    Container(
                      margin: EdgeInsets.only(right: 5.0),
                      child: TextButton(
                        onPressed: () {
                          _source.insert(0, {'typecd': 'TP1', 'typenm': 'Type ${_source.response.countData + 1}'});
                        },
                        child: Text('Insert'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _source.add({'typecd': 'TP1', 'typenm': 'Type ${_source.response.countData + 1}'});
                      },
                      child: Text('Add'),
                    )
                  ]),
                  Container(
                    child: BsDatatable(
                      source: _source,
                      clearData: BsDatatablesClearData.never,
                      title: Text('Datatables Data'),
                      columns: ExampleSource.columns,
                      language: BsDatatableLanguage(
                          nextPagination: 'Next',
                          previousPagination: 'Previous',
                          information: 'Show __START__ to __END__ of __FILTERED__ entries',
                          informationFiltered: 'filtered from __DATA__ total entries',
                          firstPagination: 'First Page',
                          lastPagination: 'Last Page',
                          hintTextSearch: 'Search data ...',
                          perPageLabel: null,
                          searchLabel: null),
                      serverSide: loadApi,
                    ),
                  ),
                  Container(
                    // actions: [
                    //   Container(
                    //     margin: EdgeInsets.only(right: 5.0),
                    //     child: TextButton(
                    //       onPressed: () {
                    //         _source1.insert(0, {'typecd': 'TP1', 'typenm': 'Type ${_source1.response.countData + 1}'});
                    //       },
                    //       child: Text('Insert'),
                    //     ),
                    //   ),
                    //   TextButton(
                    //     onPressed: () {
                    //       _source1.add({'typecd': 'TP1', 'typenm': 'Type ${_source1.response.countData + 1}'});
                    //     },
                    //     child: Text('Add'),
                    //   )
                    // ],
                    child: BsDatatable(
                      source: _source1,
                      title: Text('Datatables Data'),
                      columns: ExampleSource.columns,
                    ),
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
