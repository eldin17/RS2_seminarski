import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/artikal.dart';
import 'package:flutter_mobile/models/login_response.dart';
import 'package:flutter_mobile/models/narudzba_info.dart';
import 'package:flutter_mobile/models/zivotinja.dart';
import 'package:flutter_mobile/providers/artikli_provider.dart';
import 'package:flutter_mobile/providers/kupac_provider.dart';
import 'package:flutter_mobile/screens/artikli_detalji.dart';
import 'package:flutter_mobile/screens/zivotinje_detalji.dart';
import 'package:provider/provider.dart';

import '../providers/zivotinje_provider.dart';
import '../util/util.dart';
import '../widgets/master_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Zivotinja> zivotinje = [];
  List<Artikal> artikli = [];
  late ZivotinjeProvider _zivotinjeProvider;
  late ArtikliProvider _artikliProvider;
  late KupacProvider _kupciProvider;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _zivotinjeProvider = context.read<ZivotinjeProvider>();
    _artikliProvider = context.read<ArtikliProvider>();
    _kupciProvider = context.read<KupacProvider>();
    initForm();
  }

  Future initForm() async {
    var zivotinje2 = await _zivotinjeProvider.get();
    var artikli2 = await _artikliProvider.get();
    var kupac = await _kupciProvider
        .getByKorisnickiId(LoginResponse.idLogiranogKorisnika!);
    setState(() {
      NarudzbaInfo.kupacID = kupac.kupacId;
      zivotinje = zivotinje2.data;
      artikli = artikli2.data;
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _artikliProvider = context.read<ArtikliProvider>();
    _zivotinjeProvider = context.read<ZivotinjeProvider>();
    //_kupacProvider = context.read<KupacProvider>();
    //_novostiProvider = context.read<NovostiProvider>();
    //_narudzbeProvider = context.read<NarudzbeProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      height: 20,
                      alignment: Alignment.center,
                      child: Text("Zivotinje"),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(231, 231, 252, 0.6),
                          Color.fromRGBO(216, 247, 255, 1),
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 270,
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        scrollDirection: Axis.horizontal,
                        children: _zivotinjeList(context),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 200,
                      height: 20,
                      alignment: Alignment.center,
                      child: Text("Artikli"),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(231, 252, 232, 0.6),
                          Color.fromRGBO(225, 255, 216, 1),
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 270,
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        scrollDirection: Axis.horizontal,
                        children: _artikliList(context),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  List<Widget> _zivotinjeList(BuildContext context) {
    List<Widget> list = zivotinje
        .map((x) => Container(
              height: 270,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(216, 247, 255, 1),
                  Color.fromRGBO(231, 231, 252, 0.6)
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }

  List<Widget> _artikliList(BuildContext context) {
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }
}
