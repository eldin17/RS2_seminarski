import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/artikal.dart';
import 'package:flutter_mobile/models/login_response.dart';
import 'package:flutter_mobile/models/narudzba.dart';
import 'package:flutter_mobile/models/narudzba_artikal.dart';
import 'package:flutter_mobile/providers/kupac_provider.dart';
import 'package:flutter_mobile/providers/narudzbe_provider.dart';
import 'package:flutter_mobile/providers/stripe.dart';
import 'package:flutter_mobile/screens/narudzbe_detalji.dart';
import 'package:flutter_mobile/screens/stripe_screen.dart';
import 'package:flutter_mobile/screens/zivotinje_detalji.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/kupac.dart';
import '../models/narudzba_info.dart';
import '../models/zivotinja.dart';
import '../util/util.dart';
import '../widgets/master_screen.dart';
import 'artikli_detalji.dart';

class NarudzbeScreen extends StatefulWidget {
  NarudzbeScreen({super.key});

  @override
  State<NarudzbeScreen> createState() => _NarudzbeScreenState();
}

class _NarudzbeScreenState extends State<NarudzbeScreen> {
  List<Narudzba> narudzbe = [];
  Narudzba trenutnaNarudzba = Narudzba();
  late NarudzbeProvider _narudzbeProvider;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _narudzbeProvider = context.read<NarudzbeProvider>();
    initForm();
  }

  Future initForm() async {
    if (NarudzbaInfo.narudzbaID != null) {
      var narudzbe2 =
          await _narudzbeProvider.getByKupacId(NarudzbaInfo.kupacID!);
      var trenutna2 = await _narudzbeProvider.getId(NarudzbaInfo.narudzbaID!);
      setState(() {
        narudzbe = narudzbe2;
        trenutnaNarudzba = trenutna2;
        isLoading = false;
      });
    } else {
      var narudzbe2 =
          await _narudzbeProvider.getByKupacId(NarudzbaInfo.kupacID!);
      setState(() {
        narudzbe = narudzbe2;
        isLoading = false;
      });
    }
  }

  void refreshScreen() async {
    var trenutna2 = await _narudzbeProvider.getId(NarudzbaInfo.narudzbaID!);
    setState(() {
      trenutnaNarudzba = trenutna2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: isLoading
            ? Container()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      NarudzbaInfo.narudzbaID == null
                          ? Container(
                              child: Text("Nemate aktivnu narudzbu"),
                            )
                          : trenutna(context, trenutnaNarudzba,
                              _narudzbeProvider, refreshScreen),
                      NarudzbaInfo.narudzbaID == null
                          ? FilledButton(
                              onPressed: () async {
                                var obj = {
                                  'kupacId': NarudzbaInfo.kupacID,
                                };
                                var response = await _narudzbeProvider.add(obj);
                                setState(() {
                                  NarudzbaInfo.narudzbaID = response.narudzbaId;
                                  trenutnaNarudzba = response;
                                });
                              },
                              child: Text("Kreiraj narudzbu"))
                          : Container(),
                      NarudzbaInfo.narudzbaID != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (ElevatedButton(
                                  onPressed: () async {
                                    var response = await _narudzbeProvider
                                        .delete(NarudzbaInfo.narudzbaID!);
                                    setState(() {
                                      NarudzbaInfo.narudzbaID = null;
                                    });
                                  },
                                  child: Text(
                                    "Obrisi narudzbu",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                )),
                                trenutnaNarudzba.totalFinal! > 0
                                    ? (ElevatedButton(
                                        onPressed: () async {
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              transitionDuration: Duration.zero,
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  MasterScreen(
                                                child: CheckoutPage(
                                                  narudzba: trenutnaNarudzba,
                                                ),
                                                index: 3,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text("Plati"),
                                      ))
                                    : Container(),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 30,
                      ),
                      stareNarudzbe(context, narudzbe, _narudzbeProvider),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

Column stareNarudzbe(BuildContext context, List<Narudzba> narudzbe,
    NarudzbeProvider _narudzbeProvider) {
  return Column(
    children: [
      SizedBox(
        height: 20,
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(216, 255, 239, 0.78),
            Color.fromRGBO(216, 255, 242, 1),
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              narudzbe.isNotEmpty
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 350,
                        child: Container(
                          height: 420,
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 3.5,
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            scrollDirection: Axis.vertical,
                            children: _narudzbeList(
                                context, narudzbe, _narudzbeProvider),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

List<Widget> _narudzbeList(BuildContext context, List<Narudzba> lista,
    NarudzbeProvider _narudzbeProvider) {
  List<Widget> list = lista
      .map((x) => Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(216, 247, 255, 1),
                Color.fromRGBO(231, 231, 252, 0.781)
              ]),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration.zero,
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  MasterScreen(
                            child: NarudzbeDetalji(
                              narudzba: x,
                            ),
                            index: 1,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 85,
                      width: 320,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(255, 255, 255, 1),
                              Color.fromRGBO(244, 252, 231, 0.6),
                            ]),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${DateFormat('dd.MM.yyyy').format(DateTime.parse(x.datumNarudzbe!))}",
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          "${formatNumber(x.totalFinal)} KM",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ))
      .cast<Widget>()
      .toList();

  return list;
}

Column trenutna(BuildContext context, Narudzba narudzba,
    NarudzbeProvider _narudzbeProvider, VoidCallback refreshScreen) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(216, 217, 255, 1),
            Color.fromRGBO(244, 252, 231, 0.6),
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${DateFormat('dd.MM.yyyy').format(DateTime.parse(narudzba.datumNarudzbe!))}",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      Text(
                        "${formatNumber(narudzba.totalFinal)} KM",
                        style: TextStyle(
                            fontSize: 19,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(216, 217, 255, 0.781),
            Color.fromRGBO(216, 217, 255, 1),
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              narudzba.zivotinje!.isNotEmpty
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 350,
                        child: Container(
                          height: 260,
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1.2,
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            scrollDirection: Axis.horizontal,
                            children: _zivotinjeList(
                                context,
                                narudzba.zivotinje!,
                                _narudzbeProvider,
                                refreshScreen),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              narudzba.narudzbeArtikli!.isNotEmpty
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 350,
                        child: Container(
                          height: 260,
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1.2,
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            scrollDirection: Axis.horizontal,
                            children: _artikliList(
                                context,
                                narudzba.narudzbeArtikli!,
                                _narudzbeProvider,
                                refreshScreen),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    ],
  );
}

List<Widget> _zivotinjeList(BuildContext context, List<Zivotinja> lista,
    NarudzbeProvider _narudzbeProvider, VoidCallback refreshScreen) {
  List<Widget> list = lista
      .map((x) => Container(
            height: 270,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(216, 247, 255, 1),
                Color.fromRGBO(231, 231, 252, 0.781)
              ]),
            ),
            child: Container(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration.zero,
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  MasterScreen(
                            child: ZivotinjeDetalji(
                              zivotinja: x,
                              vrsta: x.vrsta,
                            ),
                            index: 1,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 150,
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10), // Set the border radius here
                          child: Image.network(
                            obradiSliku(x.slike![0].putanja!),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(x.naziv ?? ""),
                  Text(
                    "${formatNumber(x.cijena)} KM",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  IconButton(
                      onPressed: () async {
                        var response = await _narudzbeProvider.removeZivotinja(
                            x.zivotinjaId!, NarudzbaInfo.narudzbaID!);
                        refreshScreen();
                      },
                      icon: Icon(Icons.cancel))
                ],
              ),
            ),
          ))
      .cast<Widget>()
      .toList();

  return list;
}

List<Widget> _artikliList(BuildContext context, List<NarudzbaArtikal> lista,
    NarudzbeProvider _narudzbeProvider, VoidCallback refreshScreen) {
  List<Widget> list = lista
      .map((x) => Container(
            height: 270,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(225, 255, 216, 1),
                  Color.fromRGBO(231, 252, 232, 0.6)
                ])),
            child: Container(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration.zero,
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  MasterScreen(
                            child: ArtikliDetalji(
                              artikal: x.artikal!,
                            ),
                            index: 2,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 150,
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10), // Set the border radius here
                          child: Image.network(
                            obradiSliku(x.artikal!.slike![0].putanja!),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(x.artikal!.naziv ?? ""),
                  Text(
                    "${formatNumber(x.artikal!.cijena)} KM",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  IconButton(
                      onPressed: () async {
                        var response = await _narudzbeProvider.removeArtikal(
                            x.artikalId!, NarudzbaInfo.narudzbaID!);
                        refreshScreen();
                      },
                      icon: Icon(Icons.cancel)),
                ],
              ),
            ),
          ))
      .cast<Widget>()
      .toList();

  return list;
}
