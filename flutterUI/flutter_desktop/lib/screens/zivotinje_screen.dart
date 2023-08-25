import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/search_result.dart';
import 'package:flutter_desktop/models/zivotinja.dart';
import 'package:flutter_desktop/providers/zivotinje_provider.dart';
import 'package:flutter_desktop/screens/zivotinje_add.dart';
import 'package:flutter_desktop/screens/zivotinje_detalji_screen.dart';
import 'package:flutter_desktop/util/util.dart';
import 'package:provider/provider.dart';

import '../widgets/master_screen.dart';

class ZivotinjeScreen extends StatefulWidget {
  SearchResult<Zivotinja> podaci;

  ZivotinjeScreen({required this.podaci, super.key});

  @override
  State<ZivotinjeScreen> createState() => _ZivotinjeScreenState();
}

class _ZivotinjeScreenState extends State<ZivotinjeScreen> {
  TextEditingController _vrstaController = new TextEditingController();
  TextEditingController _rasaController = new TextEditingController();
  TextEditingController _cijenaDoController = new TextEditingController();
  TextEditingController _cijenaOdController = new TextEditingController();
  late ZivotinjeProvider _zivotinjeProvider;

  void refreshTable() async {
    var data = await _zivotinjeProvider.get();
    setState(() {
      widget.podaci = data;
      print("Tabela REFRESH");
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _zivotinjeProvider = context.read<ZivotinjeProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zivotinje"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MasterScreen(
                prikaz: ZivotinjeAdd(
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
                labelText: "Vrsta (pas, macka...)",
                prefixIcon: Icon(Icons.search),
              ),
              controller: _rasaController,
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Rasa (labrador, papagaj...)",
                prefixIcon: Icon(Icons.search),
              ),
              controller: _vrstaController,
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 280),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Cijena od",
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                    ),
                    controller: _cijenaOdController,
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Cijena do",
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                    ),
                    controller: _cijenaDoController,
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
                var data = await _zivotinjeProvider.get(filter: {
                  'vrsta': _vrstaController.text,
                  'rasa': _rasaController.text,
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
                  "Rasa",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "Vrsta",
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
                  .map((Zivotinja e) => DataRow(
                          // onSelectChanged: (selected) => {
                          //       if (selected == true)
                          //         {

                          //           Navigator.of(context).push(
                          //             MaterialPageRoute(
                          //               builder: (context) => MasterScreen(
                          //                 prikaz: ZivotinjeDetalji(
                          //                   item: e,
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         }
                          //     },
                          cells: [
                            DataCell(Text(
                              e.stateMachine?.toString() ?? "",
                              style: TextStyle(
                                  color: getTextColor(e.stateMachine)),
                            )),
                            DataCell(Text(e.naziv?.toString() ?? "")),
                            DataCell(
                                Text(formatNumber(e.cijena)?.toString() ?? "")),
                            DataCell(Text(e.vrsta?.naziv?.toString() ?? "")),
                            DataCell(Text(e.vrsta?.rasa?.naziv ?? "")),
                            DataCell(
                              e.slike?[0].putanja != ""
                                  ? Container(
                                      width: 70,
                                      height: 70,
                                      child: Image.network(
                                          "${e.slike?[0].putanja}"),
                                    )
                                  : Image.asset(
                                      "assets/images/logo.jpg",
                                      height: 70,
                                    ),
                            ),
                            DataCell(
                              Container(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    var data = await _zivotinjeProvider
                                        .allowedActions(e.zivotinjaId!);
                                    print("${data.toString()}");

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => MasterScreen(
                                          prikaz: ZivotinjeDetalji(
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
