import 'package:flutter/material.dart';
import 'package:flutter_desktop/providers/artikli_provider.dart';
import 'package:flutter_desktop/providers/kategorije_provider.dart';
import 'package:flutter_desktop/providers/kupac_provider.dart';
import 'package:flutter_desktop/providers/login_register.dart';
import 'package:flutter_desktop/providers/narudzbe_provider.dart';
import 'package:flutter_desktop/providers/novosti_provider.dart';
import 'package:flutter_desktop/providers/osoba_provider.dart';
import 'package:flutter_desktop/providers/prodavac_provider.dart';
import 'package:flutter_desktop/providers/vrste_provider.dart';
import 'package:flutter_desktop/providers/zivotinje_provider.dart';
import 'package:flutter_desktop/screens/home_screen.dart';
import 'package:flutter_desktop/screens/registracija.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'models/login_response.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginRegisterProvider()),
        ChangeNotifierProvider(create: (_) => ZivotinjeProvider()),
        ChangeNotifierProvider(create: (_) => ArtikliProvider()),
        ChangeNotifierProvider(create: (_) => KupacProvider()),
        ChangeNotifierProvider(create: (_) => NovostiProvider()),
        ChangeNotifierProvider(create: (_) => VrsteProvider()),
        ChangeNotifierProvider(create: (_) => OsobaProvider()),
        ChangeNotifierProvider(create: (_) => ProdavacProvider()),
        ChangeNotifierProvider(create: (_) => KategorijeProvider()),
        ChangeNotifierProvider(create: (_) => NarudzbeProvider()),
      ],
      child: const MyMaterialApp(),
    ),
  );
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "eKucniLjubimci",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: LoginPage2(),
      ),
    );
  }
}

class LoginPage2 extends StatefulWidget {
  const LoginPage2({super.key});

  @override
  State<LoginPage2> createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late LoginRegisterProvider _loginRegisterProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _loginRegisterProvider = context.read<LoginRegisterProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxHeight: 500, maxWidth: 400),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      20.0), // Set the desired border radius
                  child: Image.asset(
                    "assets/images/logo.jpg",
                    height: 180,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Korisnicko ime",
                      prefixIcon: Icon(Icons.person),
                    ),
                    controller: _usernameController,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: 300,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Sifra",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    controller: _passwordController,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: 140,
                  child: FilledButton(
                    onPressed: () async {
                      try {
                        var username = _usernameController.text;
                        var password = _passwordController.text;

                        await _loginRegisterProvider.login(username, password);

                        print(
                            "RESPONSE  \n${LoginResponse.idLogiranogKorisnika} \n${LoginResponse.ulogaNaziv} \n${LoginResponse.token}");

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                        _usernameController.text = "";
                        _passwordController.text = "";
                      } on Exception catch (e) {
                        // TODO
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: (Text("Error")),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Ok"),
                                    )
                                  ],
                                ));
                      }
                    },
                    child: Text("Prijavi se"),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RegistracijaScreen(),
                      ),
                    );
                  },
                  child: Text("Niste registrovani?"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
