import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/kupac.dart';
import 'package:flutter_desktop/models/narudzba.dart';
import 'package:flutter_desktop/models/novost.dart';
import 'package:flutter_desktop/providers/kupac_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../providers/narudzbe_provider.dart';
import '../util/util.dart';
import '../widgets/master_screen.dart';
import 'narudzbe_detalji.dart';

class NarudzbeScreen extends StatefulWidget {
  SearchResult<Narudzba> podaci;

  NarudzbeScreen({required this.podaci, super.key});

  @override
  State<NarudzbeScreen> createState() => _NarudzbeScreenState();
}

class _NarudzbeScreenState extends State<NarudzbeScreen> {
  TextEditingController _totalDoController = new TextEditingController();
  TextEditingController _totalOdController = new TextEditingController();
  TextEditingController _kupacImeController = new TextEditingController();
  TextEditingController _kupacPrezimeController = new TextEditingController();
  late NarudzbeProvider _narudzbeProvider;
  late KupacProvider _kupacProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _narudzbeProvider = context.read<NarudzbeProvider>();
    _kupacProvider = context.read<KupacProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Narudzbe"),
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
                labelText: "Ime kupca",
                prefixIcon: Icon(Icons.search),
              ),
              controller: _kupacImeController,
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Prezime kupca",
                prefixIcon: Icon(Icons.search),
              ),
              controller: _kupacPrezimeController,
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 280),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Total od",
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                    ),
                    controller: _totalOdController,
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Total do",
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                    ),
                    controller: _totalDoController,
                  ),
                ),
              ],
            ),
          ),
          Tooltip(
            message: "Očisti filtere",
            child: TextButton(
              onPressed: () async {
                var data = await _narudzbeProvider.get();

                setState(() {
                  _kupacImeController.value = TextEditingValue.empty;
                  _kupacPrezimeController.value = TextEditingValue.empty;
                  _totalOdController.value = TextEditingValue.empty;
                  _totalDoController.value = TextEditingValue.empty;

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
                var totalDo;
                var totalOd;
                try {
                  totalDo = double.parse(_totalDoController.text);
                } catch (e) {
                  totalDo = 0;
                }
                try {
                  totalOd = double.parse(_totalOdController.text);
                } catch (e) {
                  totalOd = 0;
                }
                if (totalDo > 0 && totalOd > 0 && (totalDo < totalOd)) {
                  setState(() {
                    var temp = _totalDoController.text;
                    _totalDoController.text = _totalOdController.text;
                    _totalOdController.text = temp;
                  });
                  var temp = totalDo;
                  totalDo = totalOd;
                  totalOd = temp;
                }
                var data = await _narudzbeProvider.get(filter: {
                  'kupacIme': _kupacImeController.text,
                  'kupacPrezime': _kupacPrezimeController.text,
                  'totalDo': totalDo,
                  'totalOd': totalOd,
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
                  "Datum narudzbe",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "Total (KM)",
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
                  .map((Narudzba e) => DataRow(cells: [
                        DataCell(Text(
                          e.stateMachine?.toString() ?? "",
                          style: TextStyle(color: getTextColor(e.stateMachine)),
                        )),
                        DataCell(Text(
                            "${DateFormat('dd.MM.yyyy').format(DateTime.parse(e.datumNarudzbe!))}")),
                        DataCell(Text(
                            "${formatNumber(e.totalFinal)?.toString()}" ?? "")),
                        DataCell(
                          Container(
                            child: ElevatedButton(
                              onPressed: () async {
                                var kupac =
                                    await _kupacProvider.getId(e.kupacId!);

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MasterScreen(
                                      prikaz: NarudzbeDetalji(
                                        narudzba: e,
                                        kupac: kupac,
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
