import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desktop/providers/artikli_provider.dart';
import 'package:flutter_desktop/screens/artikli_edit.dart';
import 'package:flutter_desktop/screens/artikli_screen.dart';
import 'package:provider/provider.dart';

import '../models/artikal.dart';
import '../util/util.dart';
import '../widgets/master_screen.dart';

class ArtikliDetalji extends StatefulWidget {
  Artikal item;
  List<dynamic> akcije = [];
  final VoidCallback onRowUpdated;
  ArtikliDetalji(
      {required this.item,
      required this.akcije,
      required this.onRowUpdated,
      super.key});

  @override
  State<ArtikliDetalji> createState() => _ArtikliDetaljiState();
}

class _ArtikliDetaljiState extends State<ArtikliDetalji> {
  late ArtikliProvider _artikliProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _artikliProvider = context.read<ArtikliProvider>();
  }

  void updateScreen(Artikal nova) async {
    var noveAkcije = await _artikliProvider.allowedActions(nova.artikalId!);
    setState(() {
      widget.item = nova;
      widget.akcije = noveAkcije;
    });
  }

  void updateDostupnost(Artikal nova) async {
    var noveAkcije = await _artikliProvider.allowedActions(nova.artikalId!);

    setState(() {
      widget.item.dostupnost = nova.dostupnost;
      widget.akcije = noveAkcije;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _leftPart(context, widget.item, _artikliProvider),
        _rightPart(context, widget.item, _artikliProvider, widget.akcije,
            widget.onRowUpdated, updateScreen, updateDostupnost),
      ],
    );
  }
}

Column _leftPart(
    BuildContext context, Artikal item, ArtikliProvider artikliProvider) {
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
                              "${item.opis}",
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
  Artikal item,
  ArtikliProvider _artikliProvider,
  List<dynamic> akcije,
  VoidCallback funkcijaRefresh,
  void Function(Artikal nova) updateScreen,
  void Function(Artikal nova) updateDostupnost,
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
                            "Naziv",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(" - ${item.naziv}"),
                        ],
                      ),
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
                            "Dostupnost",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(" - ${getDostupnost(item.dostupnost)}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Kategorija",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(" - ${item.kategorija?.naziv}"),
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
                    ]),
                  ),
                ),
              ),

              //--------------------------------

              Container(
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
                                        await _artikliProvider
                                            .activate(item.artikalId!);
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: (Text("Uspjeh")),
                                                  content: Text(
                                                      "Uspjesna aktivacija"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text("Ok"),
                                                    )
                                                  ],
                                                ));
                                        funkcijaRefresh();
                                        var nova = await _artikliProvider
                                            .getId(item.artikalId!);
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
                                                        await _artikliProvider
                                                            .delete(item
                                                                .artikalId!);
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
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                      child: Text(
                                                                          "Ok"),
                                                                    )
                                                                  ],
                                                                ));
                                                        funkcijaRefresh();
                                                        var obj =
                                                            await _artikliProvider
                                                                .get();
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MasterScreen(
                                                            prikaz:
                                                                ArtilkliScreen(
                                                              podaci: obj,
                                                            ),
                                                          ),
                                                        );
                                                        var nova =
                                                            await _artikliProvider
                                                                .getId(item
                                                                    .artikalId!);
                                                        updateScreen(nova);
                                                      },
                                                      child: Text("Obrisi"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
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
                                            prikaz: ArtikliEdit(
                                              artikal: item,
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
                                          await _artikliProvider.dostupnost(
                                              item.artikalId!,
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
            ],
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

String getDostupnost(bool? dostupnost) {
  if (dostupnost != null && dostupnost) {
    return "Da";
  }
  return "Ne";
}
