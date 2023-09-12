import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/login_response.dart';
import 'package:flutter_mobile/providers/kupac_provider.dart';
import 'package:flutter_mobile/providers/zivotinje_provider.dart';
import 'package:provider/provider.dart';

import '../models/artikal.dart';
import '../models/kupac.dart';
import '../models/narudzba_info.dart';
import '../models/rasa.dart';
import '../models/vrsta.dart';
import '../models/zivotinja.dart';
import '../providers/narudzbe_provider.dart';
import '../util/util.dart';
import '../widgets/master_screen.dart';
import 'artikli_detalji.dart';

class ZivotinjeDetalji extends StatefulWidget {
  Zivotinja zivotinja = Zivotinja();
  Vrsta? vrsta = Vrsta();

  ZivotinjeDetalji({super.key, required this.zivotinja, this.vrsta});

  @override
  State<ZivotinjeDetalji> createState() => _ZivotinjeDetaljiState();
}

class _ZivotinjeDetaljiState extends State<ZivotinjeDetalji> {
  Kupac kupac = Kupac();
  late KupacProvider _kupciProvider;
  bool isLoading = true;
  late NarudzbeProvider _narudzbeProvider;
  late ZivotinjeProvider _zivotinjeProvider;
  ValueNotifier<int> kolicina = ValueNotifier<int>(1);
  Vrsta? vrsta2 = Vrsta();
  List<Artikal> artikli = [];
  bool isLoading2 = true;

  @override
  void initState() {
    super.initState();
    _kupciProvider = context.read<KupacProvider>();
    _narudzbeProvider = context.read<NarudzbeProvider>();
    _zivotinjeProvider = context.read<ZivotinjeProvider>();

    initForm();
  }

  Future initForm() async {
    var obj = await _zivotinjeProvider.getId(widget.zivotinja.zivotinjaId!);
    widget.vrsta = obj.vrsta;
    var novi = await _kupciProvider
        .getByKorisnickiId(LoginResponse.idLogiranogKorisnika!);
    var preporuka = await _zivotinjeProvider
        .getRecommendation(widget.zivotinja.zivotinjaId!);
    setState(() {
      kupac = novi;
      isLoading = false;
      artikli = preporuka;
      isLoading2 = false;
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
                slike(widget.zivotinja),
                SizedBox(
                  height: 30,
                ),
                isLoading
                    ? Container()
                    : podaci(context, widget.zivotinja, kupac,
                        _narudzbeProvider, kolicina, widget.vrsta),
                SizedBox(
                  height: 50,
                ),
                isLoading2
                    ? Container()
                    : Column(
                        children: [
                          Container(
                            width: 350,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Mozda Vas interesuje nesto iz nase ponude?",
                                style: TextStyle(
                                    fontSize: 16, fontStyle: FontStyle.italic),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(225, 255, 216, 1),
                                Color.fromRGBO(231, 252, 232, 0.6)
                              ]),
                            ),
                          ),
                          Container(
                            height: 270,
                            child: GridView(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              scrollDirection: Axis.horizontal,
                              children: _recommended(context, artikli),
                            ),
                          ),
                        ],
                      ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Column podaci(
    BuildContext context,
    Zivotinja zivotinja,
    Kupac kupac,
    NarudzbeProvider _narudzbeProvider,
    ValueNotifier<int> kolicina,
    Vrsta? vrsta) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(189, 245, 253, 1),
            Color.fromRGBO(231, 236, 252, 0.71),
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
                    "${formatNumber(zivotinja.cijena)} KM",
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
            Color.fromRGBO(231, 236, 252, 0.71),
            Color.fromRGBO(189, 245, 253, 1),
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: zivotinja.vrsta != null
                      ? Text(
                          "Vrsta - ${zivotinja.vrsta?.rasa?.naziv}\nRasa - ${zivotinja.vrsta?.naziv}\nStarost - ${zivotinja.vrsta?.starost} godine",
                          style: TextStyle(fontSize: 17),
                        )
                      : Text(
                          "Vrsta - ${vrsta?.rasa?.naziv}\nRasa - ${vrsta?.naziv}\nStarost - ${vrsta?.starost} godine",
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
            Color.fromRGBO(189, 245, 253, 1),
            Color.fromRGBO(231, 236, 252, 0.71),
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
                  child: zivotinja.vrsta != null
                      ? Text(
                          "${zivotinja.vrsta?.opis}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 15,
                          style: TextStyle(
                              fontSize: 17, fontStyle: FontStyle.italic),
                        )
                      : Text(
                          "${vrsta?.opis}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 15,
                          style: TextStyle(
                              fontSize: 17, fontStyle: FontStyle.italic),
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
      zivotinja.napomena != ""
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(231, 236, 252, 0.71),
                  Color.fromRGBO(189, 245, 253, 1),
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
                          "${zivotinja.napomena}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 15,
                          style: TextStyle(
                              fontSize: 17, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SizedBox(
              height: 0,
            ),
      (kupac.dvoriste == false && kupac.kuca == false) &&
              (zivotinja.vrsta?.prostor == true || vrsta?.prostor == true)
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(253, 241, 189, 1),
                  Color.fromRGBO(252, 247, 231, 0.71),
                ]),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                    "Upozorenje!\nPotreban veci prostor za ovu zivotinju!"),
              ),
            )
          : SizedBox(
              height: 0,
            ),
      zivotinja.dostupnost == true && zivotinja.stateMachine == "Active"
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
                      var response = await _narudzbeProvider.addZivotinja(
                          NarudzbaInfo.narudzbaID!, zivotinja.zivotinjaId!);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text("Uspjeh"),
                                content: Text(
                                    "Uspjesno dodano\nProvjerite Vase narudzbe"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Ok"),
                                  )
                                ],
                              ));
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

Container slike(Zivotinja zivotinja) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
        Color.fromRGBO(231, 236, 252, 0.71),
        Color.fromRGBO(189, 245, 253, 1),
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
              items: obradiSlike(zivotinja.slike!).map((image) {
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

List<Widget> _recommended(BuildContext context, List<Artikal> artikli) {
  List<Widget> list = artikli
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
                            uslov: true,
                            child: ArtikliDetalji(
                              artikal: x,
                            ),
                            index: 0,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 180,
                      width: 280,
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
                  SizedBox(
                    height: 30,
                  ),
                  Text(x.naziv ?? ""),
                  Text(
                    "${formatNumber(x.cijena)} KM",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ))
      .cast<Widget>()
      .toList();

  return list;
}
