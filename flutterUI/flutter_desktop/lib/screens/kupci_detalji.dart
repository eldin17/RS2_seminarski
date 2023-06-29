import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/kupac.dart';
import 'package:flutter_desktop/providers/kupac_provider.dart';
import 'package:flutter_desktop/screens/kupci_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../util/util.dart';
import '../widgets/master_screen.dart';

class KupacDetalji extends StatefulWidget {
  Kupac item;
  final VoidCallback onRowUpdated;

  KupacDetalji({required this.item, required this.onRowUpdated, super.key});

  @override
  State<KupacDetalji> createState() => _KupacDetaljiState();
}

class _KupacDetaljiState extends State<KupacDetalji> {
  late KupacProvider _kupacProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _kupacProvider = context.read<KupacProvider>();
  }

  void updateScreen(Kupac novi) async {
    setState(() {
      widget.item = novi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _leftPart(context, widget.item, _kupacProvider),
        _rightPart(context, widget.item, _kupacProvider, widget.onRowUpdated,
            updateScreen),
      ],
    );
  }
}

Column _leftPart(
    BuildContext context, Kupac item, KupacProvider _kupacProvider) {
  return Column(
    children: [
      ClipRRect(
        borderRadius:
            BorderRadius.circular(20.0), // Set the desired border radius
        child: Image.network(
          item.slikaKupca!,
          height: 300,
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        width: 448,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(children: [
              Row(
                children: [
                  Text(
                    "Ime",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(" - ${item.osoba?.ime}"),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Prezime",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(" - ${item.osoba?.prezime}"),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Datum rodjenja",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      " - ${DateFormat('dd.MM.yyyy').format(item.osoba!.datumRodjenja!)}"),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Drzava",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(" - ${item.lokacija?.drzava}"),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Grad",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(" - ${item.lokacija?.grad}"),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Ulica",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(" - ${item.lokacija?.ulica}"),
                ],
              ),
            ]),
          ),
        ),
      )
    ],
  );
}

Column _rightPart(
  BuildContext context,
  Kupac item,
  KupacProvider _kupacProvider,
  VoidCallback funkcijaRefresh,
  void Function(Kupac nova) updateScreen,
) {
  return Column(
    children: [
      Column(
        children: [
          Container(
            width: 445,
            height: 180,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Broj narudzbi",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(" - ${item.brojNarudzbi}"),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Kuca",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(" - ${getKuca(item.kuca)}"),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Dvoriste",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(" - ${getDvoriste(item.dvoriste)}"),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Stan",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(" - ${getStan(item.stan)}"),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Korisnicko ime",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(" - ${item.korisnickiNalog?.username}"),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Datum registracije",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                            " - ${DateFormat('dd.MM.yyyy').format(DateTime.parse(item.korisnickiNalog!.datumRegistracije!))}"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 445,
            height: 105,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 70,
                        height: 40,
                        child: Tooltip(
                          message: "Obrisi",
                          child: FilledButton(
                              onPressed: () async {
                                try {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: (Text("Provjera")),
                                            content: Text("Jeste li sigurni?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  await _kupacProvider
                                                      .delete(item.kupacId!);
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                            title: (Text(
                                                                "Uspjeh")),
                                                            content: Text(
                                                                "Uspjesno obrisano"),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child:
                                                                    Text("Ok"),
                                                              )
                                                            ],
                                                          ));
                                                  funkcijaRefresh();
                                                  var obj = await _kupacProvider
                                                      .get();
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MasterScreen(
                                                      prikaz: KupciScreen(
                                                        podaci: obj,
                                                      ),
                                                    ),
                                                  );
                                                  var nova =
                                                      await _kupacProvider
                                                          .getId(item.kupacId!);
                                                  updateScreen(nova);
                                                },
                                                child: Text("Obrisi"),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("Odustani"),
                                              )
                                            ],
                                          ));
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Icon(Icons.delete)),
                        ),
                      ),
                      Container(
                        width: 70,
                        height: 40,
                        child: Tooltip(
                          message: "Nazad",
                          child: FilledButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              child: Icon(Icons.keyboard_return)),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    ],
  );

  //--------------------------------
}

String getKuca(bool? kuca) {
  if (kuca != null && kuca) {
    return "Da";
  }
  return "Ne";
}

String getDvoriste(bool? dvoriste) {
  if (dvoriste != null && dvoriste) {
    return "Da";
  }
  return "Ne";
}

String getStan(bool? stan) {
  if (stan != null && stan) {
    return "Da";
  }
  return "Ne";
}
