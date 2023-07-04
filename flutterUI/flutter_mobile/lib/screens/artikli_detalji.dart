import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/artikal.dart';
import 'package:flutter_mobile/models/narudzba_info.dart';
import 'package:flutter_mobile/providers/narudzbe_provider.dart';
import 'package:provider/provider.dart';

import '../models/kategorija.dart';
import '../models/kupac.dart';
import '../models/login_response.dart';
import '../providers/kupac_provider.dart';
import '../util/util.dart';

class ArtikliDetalji extends StatefulWidget {
  Artikal artikal = Artikal();

  ArtikliDetalji({super.key, required this.artikal});

  @override
  State<ArtikliDetalji> createState() => _ArtikliDetaljiState();
}

class _ArtikliDetaljiState extends State<ArtikliDetalji> {
  Kupac kupac = Kupac();
  late KupacProvider _kupciProvider;
  late NarudzbeProvider _narudzbeProvider;
  bool isLoading = true;
  ValueNotifier<int> kolicina = ValueNotifier<int>(1);

  @override
  void initState() {
    super.initState();
    _kupciProvider = context.read<KupacProvider>();
    _narudzbeProvider = context.read<NarudzbeProvider>();
    initForm();
  }

  Future initForm() async {
    var novi = await _kupciProvider
        .getByKorisnickiId(LoginResponse.idLogiranogKorisnika!);
    setState(() {
      kupac = novi;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                slike(widget.artikal),
                SizedBox(
                  height: 30,
                ),
                isLoading
                    ? Container()
                    : podaci(context, widget.artikal, kupac, _narudzbeProvider,
                        kolicina),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Column podaci(BuildContext context, Artikal artikal, Kupac kupac,
    NarudzbeProvider _narudzbeProvider, ValueNotifier<int> kolicina) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(231, 248, 252, 0.712),
            Color.fromRGBO(189, 253, 218, 1),
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 300,
                  child: Text(
                    "${formatNumber(artikal.cijena)} KM",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
            Color.fromRGBO(189, 253, 218, 1),
            Color.fromRGBO(231, 248, 252, 0.712),
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: artikal.kategorija != null
                      ? Text(
                          "Kategorija - ${artikal.kategorija?.naziv}\nNaziv - ${artikal.naziv}",
                          style: TextStyle(fontSize: 17))
                      : Text(
                          "Naziv - ${artikal.naziv}",
                          style: TextStyle(fontSize: 17),
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
            Color.fromRGBO(231, 248, 252, 0.712),
            Color.fromRGBO(189, 253, 218, 1),
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 300,
                  child: Text(
                    "${artikal.opis}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 15,
                    style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
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
      artikal.dostupnost == true && artikal.stateMachine == "Active"
          ? Container(
              child: FilledButton(
                  onPressed: () async {
                    if (NarudzbaInfo.narudzbaID == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Upozorenje"),
                          content: Text(
                              "Nema aktivne narudzbe.\nKreiraj novu i pokusaj ponovo?"),
                          actions: [
                            TextButton(
                              child: Text('Ne'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Da'),
                              onPressed: () async {
                                var obj = {
                                  'kupacId': NarudzbaInfo.kupacID,
                                };
                                var response = await _narudzbeProvider.add(obj);
                                NarudzbaInfo.narudzbaID = response.narudzbaId;
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    if (NarudzbaInfo.narudzbaID != null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: Text('Odaberite kolicinu'),
                                content: DropdownButton<int>(
                                  value: kolicina.value,
                                  onChanged: (novaKolicina) {
                                    setState(() {
                                      kolicina.value = novaKolicina!;
                                    });
                                  },
                                  items: List.generate(10, (index) {
                                    return DropdownMenuItem<int>(
                                      value: index + 1,
                                      child: Text((index + 1).toString()),
                                    );
                                  }),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Odustani'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () async {
                                      var obj = {
                                        'kolicina': kolicina.value,
                                      };
                                      var response =
                                          await _narudzbeProvider.addArtikal(
                                        NarudzbaInfo.narudzbaID!,
                                        artikal.artikalId!,
                                        obj,
                                      );
                                      Navigator.of(context).pop();
                                      print(
                                          'Odabrana kolicina: ${kolicina.value}');
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                  child: Text("Dodaj na narudzbu")),
            )
          : Container(
              child: Text("Kupovina trenutno nije moguca"),
            )
    ],
  );
}

Container slike(Artikal artikal) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
        Color.fromRGBO(189, 253, 218, 1),
        Color.fromRGBO(231, 248, 252, 0.712),
      ]),
    ),
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Container(
            width: 380,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 240,
              ),
              items: obradiSlike(artikal.slike!).map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(),
                      child: Image.network(
                        obradiSliku(image),
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}
