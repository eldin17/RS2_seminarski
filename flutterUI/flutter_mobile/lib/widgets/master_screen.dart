import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/narudzba.dart';
import 'package:flutter_mobile/models/narudzba_info.dart';
import 'package:flutter_mobile/providers/kupac_provider.dart';
import 'package:flutter_mobile/screens/artikli_screen.dart';
import 'package:flutter_mobile/screens/home.dart';
import 'package:flutter_mobile/screens/novosti_screen.dart';
import 'package:flutter_mobile/screens/profil_screen.dart';
import 'package:flutter_mobile/screens/zivotinje_screen.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/login_response.dart';
import '../screens/narudzbe_screen.dart';

class MasterScreen extends StatefulWidget {
  int index;
  Widget child;
  bool uslov;
  MasterScreen(
      {super.key,
      required this.child,
      required this.index,
      required this.uslov});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int currentIndex = 0;
  late KupacProvider _kupciProvider;

  void _onItemTapped(int index) async {
    setState(() {
      currentIndex = index;
    });
    if (currentIndex == 0) {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, animation, secondaryAnimation) => MasterScreen(
            uslov: true,
            child: HomeScreen(),
            index: currentIndex,
          ),
        ),
      );
    } else if (currentIndex == 1) {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, animation, secondaryAnimation) => MasterScreen(
            uslov: true,
            child: ZivotinjeScreen(),
            index: currentIndex,
          ),
        ),
      );
    } else if (currentIndex == 2) {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, animation, secondaryAnimation) => MasterScreen(
            uslov: true,
            child: ArtikliScreen(),
            index: currentIndex,
          ),
        ),
      );
    } else if (currentIndex == 3) {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, animation, secondaryAnimation) => MasterScreen(
            uslov: true,
            child: NarudzbeScreen(),
            index: currentIndex,
          ),
        ),
      );
    } else if (currentIndex == 4) {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, animation, secondaryAnimation) => MasterScreen(
            uslov: true,
            child: NovostiScreen(),
            index: currentIndex,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _kupciProvider = context.read<KupacProvider>();
    setState(() {
      currentIndex = widget.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.uslov
          ? AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration.zero,
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  MasterScreen(
                            uslov: true,
                            child: ProfilScreen(),
                            index: currentIndex,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.person)),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        LoginResponse.idLogiranogKorisnika = null;
                        LoginResponse.ulogaNaziv = null;
                        LoginResponse.token = null;
                        NarudzbaInfo.kupacID = null;

                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => Scaffold(
                                    body: LoginPage2(),
                                  )),
                        );
                      });
                    },
                    icon: Icon(Icons.logout)),
                SizedBox(
                  width: 10,
                )
              ],
            )
          : AppBar(
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration.zero,
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  MasterScreen(
                            uslov: true,
                            child: ProfilScreen(),
                            index: currentIndex,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.person)),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        LoginResponse.idLogiranogKorisnika = null;
                        LoginResponse.ulogaNaziv = null;
                        LoginResponse.token = null;
                        NarudzbaInfo.kupacID = null;

                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => Scaffold(
                                    body: LoginPage2(),
                                  )),
                        );
                      });
                    },
                    icon: Icon(Icons.logout)),
                SizedBox(
                  width: 10,
                )
              ],
            ),
      //drawer: eProdajaDrawer(),
      body: SafeArea(
        child: widget.child!,
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Pocetna',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Zivotinje',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Artikli',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Narudzbe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Novosti',
          ),
        ],
        selectedItemColor: Colors.blue,
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
