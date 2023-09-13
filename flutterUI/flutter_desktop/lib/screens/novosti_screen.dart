import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/novost.dart';
import 'package:flutter_desktop/providers/novosti_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../widgets/master_screen.dart';
import 'novosti_add.dart';
import 'novosti_detalji.dart';

class NovostiScreen extends StatefulWidget {
  SearchResult<Novost> podaci;

  NovostiScreen({required this.podaci, super.key});

  @override
  State<NovostiScreen> createState() => _NovostiScreenState();
}

class _NovostiScreenState extends State<NovostiScreen> {
  TextEditingController _naslovController = new TextEditingController();
  TextEditingController _imeController = new TextEditingController();
  TextEditingController _prezimeController = new TextEditingController();

  late NovostiProvider _novostiProvider;

  void refreshTable() async {
    var data = await _novostiProvider.get();
    setState(() {
      widget.podaci = data;
      print("Tabela REFRESH");
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _novostiProvider = context.read<NovostiProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novosti"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MasterScreen(
                prikaz: NovostiAdd(
                  onRowUpdated: refreshTable,
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          _topPartFilters(context),
          _bottomPartData(),
        ],
      ),
    );
  }

  Container _topPartFilters(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Naslov",
                  prefixIcon: Icon(Icons.search),
                ),
                controller: _naslovController,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 400),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Ime autora",
                      prefixIcon: Icon(Icons.person),
                    ),
                    controller: _imeController,
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Prezime autora",
                      prefixIcon: Icon(Icons.person),
                    ),
                    controller: _prezimeController,
                  ),
                ),
              ],
            ),
          ),
          Tooltip(
            message: "Očisti filtere",
            child: TextButton(
              onPressed: () async {
                var data = await _novostiProvider.get();

                setState(() {
                  _naslovController.value = TextEditingValue.empty;
                  _imeController.value = TextEditingValue.empty;
                  _prezimeController.value = TextEditingValue.empty;
                  _prezimeController.value = TextEditingValue.empty;

                  widget.podaci = data;
                });
              },
              child: Row(
                children: [Icon(Icons.cancel_outlined)],
              ),
            ),
          ),
          FilledButton(
              onPressed: () async {
                var data = await _novostiProvider.get(filter: {
                  'prodavacIme': _imeController.text,
                  'prodavacPrezime': _prezimeController.text,
                  'naslov': _naslovController.text,
                });
                setState(() {
                  widget?.podaci = data;
                });
              },
              child: Text("Pretraga")),
        ],
      ),
    );
  }

  Expanded _bottomPartData() {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "Naslov",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "Autor",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "Datum objave",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
          rows: widget.podaci?.data
                  .map((Novost e) => DataRow(cells: [
                        DataCell(Text(e.naslov ?? "")),
                        DataCell(Text(
                          (e.sadrzaj ?? "").length > 10
                              ? '${(e.sadrzaj ?? "").substring(0, 10)}...'
                              : e.sadrzaj ?? "",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )),
                        DataCell(Text(
                            '${e.prodavac?.osoba?.ime ?? ""} ${e.prodavac?.osoba?.prezime ?? ""}')),
                        DataCell(Text(
                            "${DateFormat('dd.MM.yyyy').format(DateTime.parse(e.datumPostavljanja!))}")),
                        DataCell(
                          Container(
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MasterScreen(
                                      prikaz: NovostDetalji(
                                        item: e,
                                        onRowUpdated: refreshTable,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Icon(Icons.more_horiz),
                            ),
                          ),
                        ),
                      ]))
                  .toList() ??
              [],
        ),
      ),
    );
  }
}
