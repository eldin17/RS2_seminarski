import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/narudzba.dart';
import 'package:flutter_desktop/models/narudzba_artikal.dart';
import 'package:flutter_desktop/models/search_result.dart';
import 'package:flutter_desktop/providers/artikli_provider.dart';
import 'package:flutter_desktop/screens/artikli_detalji.dart';
import 'package:provider/provider.dart';

import '../models/kupac.dart';
import '../models/zivotinja.dart';
import '../providers/kupac_provider.dart';
import '../providers/narudzbe_provider.dart';
import '../util/util.dart';
import '../widgets/master_screen.dart';

class NarudzbeDetalji extends StatefulWidget {
  Narudzba narudzba;
  Kupac kupac;

  NarudzbeDetalji({super.key, required this.narudzba, required this.kupac});

  @override
  State<NarudzbeDetalji> createState() => _NarudzbeDetaljiState();
}

class _NarudzbeDetaljiState extends State<NarudzbeDetalji> {
  late KupacProvider _kupacProvider;
  late NarudzbeProvider _narudzbaProvider;
  late ArtikliProvider _artikliProvider;

  void refreshTable() async {
    return;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _kupacProvider = context.read<KupacProvider>();
    _narudzbaProvider = context.read<NarudzbeProvider>();
    _artikliProvider = context.read<ArtikliProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _topPart(context, widget.narudzba, widget.kupac),
        Row(
          children: [
            _leftPart(context, widget.narudzba),
            _rightPart(context, widget.narudzba),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text("Nazad"),
            ),
          ],
        )
      ],
    );
  }

  Expanded _leftPart(BuildContext context, Narudzba narudzba) {
    return Expanded(
      child: Container(
        height: 400,
        child: Card(
          child: Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: DataTable(
                  columns: [
                    const DataColumn(
                      label: const Expanded(
                        child: const Text(
                          "Artikli",
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
                  rows: (narudzba.narudzbeArtikli != null ||
                          narudzba.narudzbeArtikli != [])
                      ? narudzba.narudzbeArtikli!
                              .map((NarudzbaArtikal e) => DataRow(cells: [
                                    DataCell(Text(
                                        e.artikal?.naziv?.toString() ?? "")),
                                    DataCell(Text(
                                        "${formatNumber(e.artikal?.cijena)?.toString()} KM")),
                                  ]))
                              .toList() ??
                          []
                      : List.empty(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded _rightPart(BuildContext context, Narudzba narudzba) {
    return Expanded(
      child: Container(
        height: 400,
        child: Card(
          child: Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: DataTable(
                  columns: [
                    const DataColumn(
                      label: const Expanded(
                        child: const Text(
                          "Zivotinje",
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
                          "",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    )
                  ],
                  rows: (narudzba.zivotinje != null || narudzba.zivotinje != [])
                      ? narudzba.zivotinje!
                              .map((Zivotinja e) => DataRow(cells: [
                                    DataCell(
                                        Text(e.vrsta?.naziv.toString() ?? "")),
                                    DataCell(
                                        Text(e.vrsta?.rasa.toString() ?? "")),
                                    DataCell(Text(
                                        "${formatNumber(e.cijena)?.toString()} KM")),
                                  ]))
                              .toList() ??
                          []
                      : List.empty(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _topPart(BuildContext context, Narudzba narudzba, Kupac kupac) {
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text("${kupac.osoba?.ime} ${kupac.osoba?.prezime}",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              Row(
                children: [
                  Text(
                    "${kupac.lokacija?.drzava} - ${kupac.lokacija?.grad}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(" - ${narudzba.totalFinal} KM"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
