import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/zivotinja.dart';
import 'package:flutter_desktop/providers/zivotinje_provider.dart';
import 'package:flutter_desktop/screens/zivotinje_edit.dart';
import 'package:flutter_desktop/screens/zivotinje_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/rasa.dart';
import '../providers/rase_provider.dart';
import '../util/util.dart';
import '../widgets/master_screen.dart';

class ZivotinjeDetalji extends StatefulWidget {
  Zivotinja item;
  List<dynamic> akcije = [];
  final VoidCallback onRowUpdated;

  ZivotinjeDetalji(
      {required this.item,
      required this.akcije,
      required this.onRowUpdated,
      super.key});

  @override
  State<ZivotinjeDetalji> createState() => _ZivotinjeDetaljiState();
}

class _ZivotinjeDetaljiState extends State<ZivotinjeDetalji> {
  late ZivotinjeProvider _zivotinjeProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _zivotinjeProvider = context.read<ZivotinjeProvider>();
  }

  void updateScreen(Zivotinja nova) async {
    var noveAkcije = await _zivotinjeProvider.allowedActions(nova.zivotinjaId!);
    setState(() {
      widget.item = nova;
      widget.akcije = noveAkcije;
    });
  }

  void updateDostupnost(Zivotinja nova) async {
    var noveAkcije = await _zivotinjeProvider.allowedActions(nova.zivotinjaId!);

    setState(() {
      widget.item.dostupnost = nova.dostupnost;
      widget.akcije = noveAkcije;
    });
  }

//-----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _leftPart(context, widget.item, _zivotinjeProvider),
        _rightPart(context, widget.item, _zivotinjeProvider, widget.akcije,
            widget.onRowUpdated, updateScreen, updateDostupnost),
      ],
    );
  }
}

Column _leftPart(BuildContext context, Zivotinja item,
    ZivotinjeProvider _zivotinjeProvider) {
  return Column(
    children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            width: 400,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 250,
              ),
              items: item.slike?.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(),
                      child: Image.network(
                        image.putanja!,
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
      Expanded(
        child: Container(
          width: 445,
          height: 300,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Container(
                            width: 300,
                            child: Text(
                              "${item.vrsta?.opis}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 15,
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    ],
  );
}

Expanded _rightPart(
  BuildContext context,
  Zivotinja item,
  ZivotinjeProvider _zivotinjeProvider,
  List<dynamic> akcije,
  VoidCallback funkcijaRefresh,
  void Function(Zivotinja nova) updateScreen,
  void Function(Zivotinja nova) updateDostupnost,
) {
  return Expanded(
    child: Container(
      child: Column(
        children: [
          Column(
            children: [
              Container(
                width: 445,
                height: 180,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(children: [
                      Row(
                        children: [
                          Text(
                            "Vrsta",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(" - ${item.vrsta?.naziv}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Rasa",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(" - ${item.vrsta?.rasa?.naziv}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Starost",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(" - ${item.vrsta?.starost} godina"),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Boja",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(" - ${item.vrsta?.boja}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Prostor",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(" - ${getProstor(item.vrsta?.prostor)}"),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
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
                              "Cijena",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(" - ${formatNumber(item.cijena)} KM"),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Naziv",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(" - ${item.naziv}"),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Napomena",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: 250,
                              child: Text(
                                " - ${item.napomena}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 15,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Dostupnost",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(" - ${getDostupnost(item.dostupnost)}"),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Datum postavljanja",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                " - ${DateFormat('dd.MM.yyyy').format(item.datumPostavljanja!)}"),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Status",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              " - ${item.stateMachine}",
                              style: TextStyle(
                                  color: getTextColor(item.stateMachine)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          //--------------------------------

          Expanded(
            child: Container(
              width: 445,
              height: 155,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Visibility(
                          visible: isButtonVisible("Activate", akcije),
                          child: Container(
                            width: 70,
                            height: 40,
                            child: Tooltip(
                              message: "Aktiviraj",
                              child: FilledButton(
                                  onPressed: () async {
                                    try {
                                      await _zivotinjeProvider
                                          .activate(item.zivotinjaId!);
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: (Text("Uspjeh")),
                                                content:
                                                    Text("Uspjesna aktivacija"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text("Ok"),
                                                  )
                                                ],
                                              ));
                                      funkcijaRefresh();
                                      var nova = await _zivotinjeProvider
                                          .getId(item.zivotinjaId!);
                                      updateScreen(nova);
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Icon(Icons.check)),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isButtonVisible("Delete", akcije),
                          child: Container(
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
                                                content:
                                                    Text("Jeste li sigurni?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      await _zivotinjeProvider
                                                          .delete(item
                                                              .zivotinjaId!);
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
                                                                    child: Text(
                                                                        "Ok"),
                                                                  )
                                                                ],
                                                              ));
                                                      funkcijaRefresh();
                                                      var obj =
                                                          await _zivotinjeProvider
                                                              .get();
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            MasterScreen(
                                                          prikaz:
                                                              ZivotinjeScreen(
                                                            podaci: obj,
                                                          ),
                                                        ),
                                                      );
                                                      var nova =
                                                          await _zivotinjeProvider
                                                              .getId(item
                                                                  .zivotinjaId!);
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
                        ),
                        Visibility(
                          visible: isButtonVisible("Update", akcije),
                          child: Container(
                            width: 70,
                            height: 40,
                            child: Tooltip(
                              message: "Uredi",
                              child: FilledButton(
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => MasterScreen(
                                          prikaz: ZivotinjeEdit(
                                            vrsta: item.vrsta!,
                                            zivotinja: item,
                                            onRowUpdated: funkcijaRefresh,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.edit)),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isButtonVisible("Dostupnost", akcije),
                          child: Container(
                            width: 70,
                            height: 40,
                            child: Tooltip(
                              message: "Promijeni dostupnost",
                              child: FilledButton(
                                  onPressed: () async {
                                    var nova =
                                        await _zivotinjeProvider.dostupnost(
                                            item.zivotinjaId!,
                                            !item.dostupnost!);
                                    updateDostupnost(nova);
                                  },
                                  child: item.dostupnost != true
                                      ? Icon(Icons.check_circle)
                                      : Icon(Icons.cancel)),
                            ),
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
          ),
        ],
      ),
    ),
  );
}

bool isButtonVisible(String button, List<dynamic> lista) {
  for (var item in lista) {
    if (button == item) return true;
  }
  return false;
}

String getProstor(bool? prostor) {
  if (prostor != null && prostor) {
    return "Potreban je veci prostor za ovu zivotinju";
  }
  return "Dovoljan je manji prostor za ovu zivotinju";
}

String getDostupnost(bool? dostupnost) {
  if (dostupnost != null && dostupnost) {
    return "Da";
  }
  return "Ne";
}
