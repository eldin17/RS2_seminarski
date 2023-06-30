import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/kupac.dart';
import 'package:flutter_desktop/models/narudzba.dart';
import 'package:flutter_desktop/models/prodavac.dart';
import 'package:flutter_desktop/providers/kupac_provider.dart';
import 'package:flutter_desktop/providers/narudzbe_provider.dart';
import 'package:flutter_desktop/providers/prodavac_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/master_screen.dart';
import 'narudzbe_detalji.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PoslovniIzvjestaji extends StatefulWidget {
  PoslovniIzvjestaji({super.key});

  @override
  State<PoslovniIzvjestaji> createState() => _PoslovniIzvjestajiState();
}

class _PoslovniIzvjestajiState extends State<PoslovniIzvjestaji> {
  late List<Narudzba> narudzbe = [];
  late List<Kupac> top3kupci = [];
  Narudzba najvecaNarudzba1 = Narudzba();
  Narudzba najvecaNarudzba2 = Narudzba();
  double zarada1 = 0;
  double zarada2 = 0;
  Prodavac prodavac = Prodavac();
  late KupacProvider _kupciProvider;
  late NarudzbeProvider _narudzbaProvider;
  late ProdavacProvider _prodavacProvider;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _kupciProvider = context.read<KupacProvider>();
    _narudzbaProvider = context.read<NarudzbeProvider>();
    _prodavacProvider = context.read<ProdavacProvider>();

    initLoad();
  }

  Future initLoad() async {
    top3kupci = await _kupciProvider.getTop3();
    najvecaNarudzba1 = await _narudzbaProvider.najskuplja1();
    najvecaNarudzba2 = await _narudzbaProvider.najskuplja2();
    zarada1 = await _narudzbaProvider.zarada1();
    zarada2 = await _narudzbaProvider.zarada2();
    prodavac = await _prodavacProvider.getAktivnost();
    narudzbe = await _narudzbaProvider.getMonth();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Poslovni izvjestaji"),
      ),
      body: isLoading
          ? Container()
          : Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child:
                            Container(height: 230, child: _top3Part(context))),
                    Expanded(
                        child: Container(
                            height: 230, child: _najskupljaNarudzba1(context))),
                    Expanded(
                        child: Container(
                            height: 230, child: _najskupljaNarudzba2(context))),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child:
                            Container(height: 130, child: _prodavci(context))),
                    Expanded(
                        child: Container(
                            height: 130, child: _ukupnaZarada1(context))),
                    Expanded(
                        child: Container(
                            height: 130, child: _ukupnaZarada2(context))),
                  ],
                ),
                Expanded(
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Text(
                          "Narudzbe (cijena) u proslom mjesecu",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                            child: SingleChildScrollView(child: _grafikon())),
                      ],
                    ),
                  )),
                ),
              ],
            ),
    );
  }

  Card _top3Part(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: DataTable(
          columns: [
            const DataColumn(
              label: const Expanded(
                child: const Text(
                  "Top 3 kupca",
                  style: TextStyle(
                      fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          rows: (top3kupci != null || top3kupci != [])
              ? top3kupci!
                      .map((Kupac e) => DataRow(cells: [
                            DataCell(
                                Text("${e.osoba?.ime} ${e.osoba?.prezime}")),
                          ]))
                      .toList() ??
                  []
              : List.empty(),
        ),
      ),
    );
  }

  Card _najskupljaNarudzba1(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Text(
              "Najveca narudzba",
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            ),
            Text("prosli mjesec"),
            SizedBox(
              height: 50,
            ),
            Text(
              "${najvecaNarudzba1.totalFinal} KM",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  var kupac =
                      await _kupciProvider.getId(najvecaNarudzba1.kupacId!);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MasterScreen(
                        prikaz: NarudzbeDetalji(
                          narudzba: najvecaNarudzba1,
                          kupac: kupac,
                        ),
                      ),
                    ),
                  );
                },
                child: Text("Otvori"))
          ],
        ),
      ),
    );
  }

  Card _najskupljaNarudzba2(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Text(
              "Najveca narudzba",
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            ),
            Text("cijelo vrijeme"),
            SizedBox(
              height: 50,
            ),
            Text(
              "${najvecaNarudzba2.totalFinal} KM",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  var kupac =
                      await _kupciProvider.getId(najvecaNarudzba2.kupacId!);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MasterScreen(
                        prikaz: NarudzbeDetalji(
                          narudzba: najvecaNarudzba2,
                          kupac: kupac,
                        ),
                      ),
                    ),
                  );
                },
                child: Text("Otvori"))
          ],
        ),
      ),
    );
  }

  Card _ukupnaZarada1(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Text(
              "Zarada",
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            ),
            Text("prosli mjesec"),
            SizedBox(
              height: 20,
            ),
            Text(
              "${zarada1} KM",
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Card _ukupnaZarada2(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Text(
              "Zarada",
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            ),
            Text("cijelo vrijeme"),
            SizedBox(
              height: 20,
            ),
            Text(
              "${zarada2} KM",
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Card _prodavci(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Text(
              "Najaktivniji prodavac",
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "${prodavac.osoba?.ime} ${prodavac.osoba?.prezime}",
              style: TextStyle(fontSize: 15),
            ),
            Text(
              "${prodavac.poslovnaJedinica}",
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _grafikon() {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      series: <ChartSeries>[
        LineSeries<Narudzba, DateTime>(
          dataSource: narudzbe,
          xValueMapper: (Narudzba sales, _) =>
              DateTime.parse(sales.datumNarudzbe!),
          yValueMapper: (Narudzba sales, _) => sales.totalFinal,
        ),
      ],
    );
  }
}
