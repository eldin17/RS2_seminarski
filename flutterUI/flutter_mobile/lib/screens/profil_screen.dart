import 'package:flutter/material.dart';
import 'package:flutter_mobile/screens/profil_edit.dart';
import 'package:flutter_mobile/util/util.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/kupac.dart';
import '../models/login_response.dart';
import '../providers/kupac_provider.dart';
import '../widgets/master_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  Kupac kupac = Kupac();
  late KupacProvider _kupciProvider;
  bool isLoading = true;
  var slika = "";

  @override
  void initState() {
    super.initState();
    _kupciProvider = context.read<KupacProvider>();
    initForm();
  }

  void refreshProfil() async {
    var novi = await _kupciProvider
        .getByKorisnickiId(LoginResponse.idLogiranogKorisnika!);
    setState(() {
      kupac = novi;
      slika = kupac.slikaKupca!;
    });
  }

  Future initForm() async {
    Kupac novi = await _kupciProvider
        .getByKorisnickiId(LoginResponse.idLogiranogKorisnika!);
    setState(() {
      kupac = novi;
      slika = kupac.slikaKupca!;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : Container(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      slikaKupca(kupac),
                      SizedBox(
                        height: 30,
                      ),
                      podaci(kupac),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            var data = await _kupciProvider.getByKorisnickiId(
                                LoginResponse.idLogiranogKorisnika!);
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: Duration.zero,
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        MasterScreen(
                                  uslov: true,
                                  child: ProfilEdit(
                                    kupacid: data.kupacId!,
                                    lokacijaid: data.lokacijaId!,
                                    osobaid: data.osobaId!,
                                    kupac: data,
                                    onEditFinished: refreshProfil,
                                  ),
                                  index: 0,
                                ),
                              ),
                            );
                          },
                          child: Text("Uredi"))
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

Container slikaKupca(Kupac kupac) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(colors: [
        Color.fromRGBO(231, 239, 252, 0.836),
        Color.fromRGBO(189, 253, 189, 1),
      ]),
    ),
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Container(
            width: 380,
            child: CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(obradiSliku(kupac.slikaKupca!)),
            ),
          ),
        ],
      ),
    ),
  );
}

Column podaci(Kupac kupac) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(189, 253, 189, 1),
            Color.fromRGBO(231, 239, 252, 0.836),
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Icon(Icons.person_2_outlined),
              Container(
                width: 380,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${kupac.osoba?.ime}",
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      "${kupac.osoba?.prezime}",
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      "${DateFormat('dd.MM.yyyy').format(kupac.osoba!.datumRodjenja!)}",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 30,
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(231, 239, 252, 0.836),
            Color.fromRGBO(189, 253, 189, 1),
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Icon(Icons.location_on_outlined),
              Container(
                width: 380,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${kupac.lokacija?.drzava}",
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      "${kupac.lokacija?.grad}",
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      "${kupac.lokacija?.ulica}",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
