import 'package:flutter/material.dart';
import 'package:flutter_desktop/screens/artikli_detalji.dart';
import 'package:provider/provider.dart';

import '../models/artikal.dart';
import '../models/search_result.dart';
import '../providers/artikli_provider.dart';
import '../util/util.dart';
import '../widgets/master_screen.dart';
import 'artikli_add.dart';

class ArtilkliScreen extends StatefulWidget {
  SearchResult<Artikal> podaci;

  ArtilkliScreen({required this.podaci, super.key});

  @override
  State<ArtilkliScreen> createState() => _ArtilkliScreenState();
}

class _ArtilkliScreenState extends State<ArtilkliScreen> {
  TextEditingController _nazivController = new TextEditingController();
  TextEditingController _cijenaDoController = new TextEditingController();
  TextEditingController _cijenaOdController = new TextEditingController();
  late ArtikliProvider _artikliProvider;

  void refreshTable() async {
    var data = await _artikliProvider.get();
    setState(() {
      widget.podaci = data;
      print("Tabela REFRESH");
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _artikliProvider = context.read<ArtikliProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Artikli"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MasterScreen(
                prikaz: ArtikliAdd(
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
            child: TextField(
              decoration: InputDecoration(
                labelText: "Naziv",
                prefixIcon: Icon(Icons.search),
              ),
              controller: _nazivController,
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 280),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Cijena do",
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                    ),
                    controller: _cijenaDoController,
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Cijena od",
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                    ),
                    controller: _cijenaOdController,
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
              onPressed: () async {
                var cijenaDo;
                var cijenaOd;
                try {
                  cijenaDo = double.parse(_cijenaDoController.text);
                } catch (e) {
                  cijenaDo = 0;
                }
                try {
                  cijenaOd = double.parse(_cijenaOdController.text);
                } catch (e) {
                  cijenaOd = 0;
                }
                if (cijenaDo > 0 && cijenaOd > 0 && (cijenaDo < cijenaOd)) {
                  setState(() {
                    var temp = _cijenaDoController.text;
                    _cijenaDoController.text = _cijenaOdController.text;
                    _cijenaOdController.text = temp;
                  });
                  var temp = cijenaDo;
                  cijenaDo = cijenaOd;
                  cijenaOd = temp;
                }
                var data = await _artikliProvider.get(filter: {
                  'naziv': _nazivController.text,
                  'cijenaDo': cijenaDo,
                  'cijenaOd': cijenaOd,
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
                  "Status",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "Naziv",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "Cijena",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "Kategorija",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "Slika",
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
            )
          ],
          rows: widget.podaci?.data
                  .map((Artikal e) => DataRow(cells: [
                        DataCell(Text(
                          e.stateMachine?.toString() ?? "",
                          style: TextStyle(color: getTextColor(e.stateMachine)),
                        )),
                        DataCell(Text(e.naziv?.toString() ?? "")),
                        DataCell(
                            Text(formatNumber(e.cijena)?.toString() ?? "")),
                        DataCell(Text(e.kategorija?.naziv?.toString() ?? "")),
                        DataCell(e.slike?[0].putanja != ""
                            ? Container(
                                width: 70,
                                height: 70,
                                child: Image.network("${e.slike?[0].putanja}"),
                              )
                            : Text("")),
                        DataCell(
                          Container(
                            child: ElevatedButton(
                              onPressed: () async {
                                var data = await _artikliProvider
                                    .allowedActions(e.artikalId!);
                                print("${data.toString()}");

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MasterScreen(
                                      prikaz: ArtikliDetalji(
                                        item: e,
                                        akcije: data,
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
