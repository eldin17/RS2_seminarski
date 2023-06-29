import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/novost.dart';
import 'package:flutter_desktop/providers/novosti_provider.dart';
import 'package:flutter_desktop/screens/novosti_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/master_screen.dart';

class NovostDetalji extends StatefulWidget {
  Novost item;
  final VoidCallback onRowUpdated;

  NovostDetalji({required this.item, required this.onRowUpdated, super.key});

  @override
  State<NovostDetalji> createState() => _NovostDetaljiState();
}

class _NovostDetaljiState extends State<NovostDetalji> {
  late NovostiProvider _novostProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _novostProvider = context.read<NovostiProvider>();
  }

  void updateScreen(Novost novi) async {
    setState(() {
      widget.item = novi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _leftPart(context, widget.item, _novostProvider),
        Container(
          alignment: Alignment.topRight,
          child: _rightPart(context, widget.item, _novostProvider,
              widget.onRowUpdated, updateScreen),
        ),
      ],
    );
  }

  Expanded _leftPart(
      BuildContext context, Novost item, NovostiProvider _novostProvider) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 700, maxHeight: 300),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(children: [
                    Row(
                      children: [
                        Text(
                          "${item.naslov}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 600),
                          child: Text(
                            "${item.sadrzaj}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 15,
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                            "${DateFormat('dd.MM.yyyy').format(DateTime.parse(item.datumPostavljanja!))}"),
                      ),
                    )
                  ]),
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 700, maxHeight: 350),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(children: [
                    Row(
                      children: [
                        Text(
                          "${item.prodavac?.osoba?.ime} ${item.prodavac?.osoba?.prezime}",
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Poslovna jedinica - ",
                        ),
                        Text(
                          "${item.prodavac?.poslovnaJedinica}",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                20.0), // Set the desired border radius
                            child: Image.network(
                              item.prodavac!.slikaProdavca!,
                              height: 200,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _rightPart(
    BuildContext context,
    Novost item,
    NovostiProvider _novostiProvider,
    VoidCallback funkcijaRefresh,
    void Function(Novost nova) updateScreen,
  ) {
    return Container(
      width: 200,
      height: 105,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
                            builder: (BuildContext context) => AlertDialog(
                                  title: (Text("Provjera")),
                                  content: Text("Jeste li sigurni?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await _novostiProvider
                                            .delete(item.novostId!);
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: (Text("Uspjeh")),
                                                  content:
                                                      Text("Uspjesno obrisano"),
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
                                        var obj = await _novostiProvider.get();
                                        MaterialPageRoute(
                                          builder: (context) => MasterScreen(
                                            prikaz: NovostiScreen(
                                              podaci: obj,
                                            ),
                                          ),
                                        );
                                        var nova = await _novostiProvider
                                            .getId(item.novostId!);
                                        updateScreen(nova);
                                      },
                                      child: Text("Obrisi"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
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
    );
  }
}
