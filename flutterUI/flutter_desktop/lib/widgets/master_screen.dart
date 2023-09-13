import 'package:flutter/material.dart';
import 'package:flutter_desktop/main.dart';
import 'package:flutter_desktop/providers/artikli_provider.dart';
import 'package:flutter_desktop/providers/narudzbe_provider.dart';
import 'package:flutter_desktop/providers/novosti_provider.dart';
import 'package:flutter_desktop/screens/artikli_screen.dart';
import 'package:flutter_desktop/screens/izvjestaji.dart';
import 'package:flutter_desktop/screens/kupci_screen.dart';
import 'package:flutter_desktop/screens/narudzbe_screen.dart';
import 'package:flutter_desktop/screens/novosti_screen.dart';
import 'package:flutter_desktop/screens/ostalo.dart';
import 'package:provider/provider.dart';

import '../models/login_response.dart';
import '../providers/kupac_provider.dart';
import '../providers/zivotinje_provider.dart';
import '../screens/zivotinje_screen.dart';

class MasterScreen extends StatefulWidget {
  Widget? prikaz;
  MasterScreen({this.prikaz, super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  late ZivotinjeProvider _zivotinjeProvider;
  late ArtikliProvider _artikliProvider;
  late KupacProvider _kupacProvider;
  late NovostiProvider _novostiProvider;
  late NarudzbeProvider _narudzbeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _artikliProvider = context.read<ArtikliProvider>();
    _zivotinjeProvider = context.read<ZivotinjeProvider>();
    _kupacProvider = context.read<KupacProvider>();
    _novostiProvider = context.read<NovostiProvider>();
    _narudzbeProvider = context.read<NarudzbeProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 300),
              color: Colors.cyan,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          15.0), // Set the desired border radius
                      child: Image.asset(
                        "assets/images/logo.jpg",
                        height: 100,
                      ),
                    ),
                    SizedBox(
                      height: 55,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 200,
                            child: ElevatedButton(
                                onPressed: () async {
                                  var obj = await _zivotinjeProvider.get();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MasterScreen(
                                        prikaz: ZivotinjeScreen(
                                          podaci: obj,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Text("Zivotinje"))),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 200,
                          child: ElevatedButton(
                              onPressed: () async {
                                var obj = await _artikliProvider.get();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MasterScreen(
                                      prikaz: ArtilkliScreen(
                                        podaci: obj,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Text("Artikli")),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 200,
                          child: ElevatedButton(
                              onPressed: () async {
                                var obj = await _artikliProvider.get();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MasterScreen(
                                      prikaz: OstaloScreen(),
                                    ),
                                  ),
                                );
                              },
                              child: Text("Ostalo")),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 200,
                          child: ElevatedButton(
                              onPressed: () async {
                                var obj = await _kupacProvider.get();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MasterScreen(
                                      prikaz: KupciScreen(
                                        podaci: obj,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Text("Kupci")),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 200,
                          child: ElevatedButton(
                              onPressed: () async {
                                var obj = await _novostiProvider.get();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MasterScreen(
                                      prikaz: NovostiScreen(
                                        podaci: obj,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Text("Novosti")),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 200,
                          child: ElevatedButton(
                              onPressed: () async {
                                var obj = await _narudzbeProvider.get();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MasterScreen(
                                      prikaz: NarudzbeScreen(
                                        podaci: obj,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Text("Narudzbe")),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 200,
                          child: ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MasterScreen(
                                      prikaz: PoslovniIzvjestaji(),
                                    ),
                                  ),
                                );
                              },
                              child: Text("Poslovni izjvestaji")),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              LoginResponse.idLogiranogKorisnika = null;
                              LoginResponse.ulogaNaziv = null;
                              LoginResponse.token = null;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                          body: LoginPage2(),
                                        )),
                              );
                            });
                          },
                          child: Text("Odjavi se"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 700),
                  child: widget.prikaz!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
