import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/kupac.dart';
import 'package:flutter_desktop/providers/kupac_provider.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../widgets/master_screen.dart';
import 'kupci_detalji.dart';

class KupciScreen extends StatefulWidget {
  SearchResult<Kupac> podaci;

  KupciScreen({required this.podaci, super.key});

  @override
  State<KupciScreen> createState() => _KupciScreenState();
}

class _KupciScreenState extends State<KupciScreen> {
  TextEditingController _brojNarudzbiDoController = new TextEditingController();
  TextEditingController _brojNarudzbiOdController = new TextEditingController();
  TextEditingController _imeController = new TextEditingController();
  TextEditingController _prezimeController = new TextEditingController();
  TextEditingController _gradController = new TextEditingController();
  TextEditingController _drzavaController = new TextEditingController();

  late KupacProvider _kupacProvider;

  void refreshTable() async {
    var data = await _kupacProvider.get();
    setState(() {
      widget.podaci = data;
      print("Tabela REFRESH");
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _kupacProvider = context.read<KupacProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kupci"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _topPartFilters(context),
          _bottomPartData(),
        ],
      ),
    );
  }

  Column _topPartFilters(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Narudzbe (max)",
                          ),
                          controller: _brojNarudzbiDoController,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Narudzbe (min)",
                          ),
                          controller: _brojNarudzbiOdController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 280),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Ime",
                          prefixIcon: Icon(Icons.person),
                        ),
                        controller: _imeController,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Prezime",
                          prefixIcon: Icon(Icons.person),
                        ),
                        controller: _prezimeController,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 280),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Grad",
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        controller: _gradController,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Drzava",
                          prefixIcon: Icon(Icons.flag),
                        ),
                        controller: _drzavaController,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Tooltip(
                message: "Očisti filtere",
                child: TextButton(
                  onPressed: () async {
                    var data = await _kupacProvider.get();

                    setState(() {
                      _brojNarudzbiOdController.value = TextEditingValue.empty;
                      _brojNarudzbiDoController.value = TextEditingValue.empty;
                      _imeController.value = TextEditingValue.empty;
                      _prezimeController.value = TextEditingValue.empty;
                      _gradController.value = TextEditingValue.empty;
                      _drzavaController.value = TextEditingValue.empty;
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
                    var narudzbeDo;
                    var narudzbeOd;
                    try {
                      narudzbeDo = int.parse(_brojNarudzbiDoController.text);
                    } catch (e) {
                      narudzbeDo = 0;
                    }
                    try {
                      narudzbeOd = int.parse(_brojNarudzbiOdController.text);
                    } catch (e) {
                      narudzbeOd = 0;
                    }
                    if (narudzbeDo > 0 &&
                        narudzbeOd > 0 &&
                        (narudzbeDo < narudzbeOd)) {
                      setState(() {
                        var temp = _brojNarudzbiDoController.text;
                        _brojNarudzbiDoController.text =
                            _brojNarudzbiOdController.text;
                        _brojNarudzbiOdController.text = temp;
                      });
                      var temp = narudzbeDo;
                      narudzbeDo = narudzbeOd;
                      narudzbeOd = temp;
                    }
                    var data = await _kupacProvider.get(filter: {
                      'ime': _imeController.text,
                      'prezime': _prezimeController.text,
                      'grad': _gradController.text,
                      'drzava': _drzavaController.text,
                      'brojNarudzbiDo': narudzbeDo,
                      'brojNarudzbiOd': narudzbeOd,
                    });
                    setState(() {
                      widget?.podaci = data;
                    });
                  },
                  child: Text("Pretraga")),
            ],
          ),
        ),
      ],
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
                  "Ime i prezime",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "Grad",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "Drzava",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "Korisnicko ime",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "Narudzbe",
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
                  .map((Kupac e) => DataRow(cells: [
                        DataCell(Text(
                            '${e.osoba?.ime ?? ""} ${e.osoba?.prezime ?? ""}')),
                        DataCell(Text(e.lokacija?.grad.toString() ?? "")),
                        DataCell(Text(e.lokacija?.drzava.toString() ?? "")),
                        DataCell(
                            Text(e.korisnickiNalog?.username.toString() ?? "")),
                        DataCell(Text(e.brojNarudzbi?.toString() ?? "")),
                        DataCell(e.slikaKupca != ""
                            ? Container(
                                width: 70,
                                height: 70,
                                child: Image.network("${e.slikaKupca}"),
                              )
                            : Text("")),
                        DataCell(
                          Container(
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MasterScreen(
                                      prikaz: KupacDetalji(
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
