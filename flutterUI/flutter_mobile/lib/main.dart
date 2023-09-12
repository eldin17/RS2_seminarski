import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mobile/providers/artikli_provider.dart';
import 'package:flutter_mobile/providers/kategorije_provider.dart';
import 'package:flutter_mobile/providers/kupac_provider.dart';
import 'package:flutter_mobile/providers/login_register.dart';
import 'package:flutter_mobile/providers/lokacija.dart';
import 'package:flutter_mobile/providers/narudzbe_provider.dart';
import 'package:flutter_mobile/providers/novosti_provider.dart';
import 'package:flutter_mobile/providers/osoba_provider.dart';
import 'package:flutter_mobile/providers/zivotinje_provider.dart';
import 'package:flutter_mobile/screens/home.dart';
import 'package:flutter_mobile/screens/registracija.dart';
import 'package:flutter_mobile/screens/registracija_osoba.dart';
import 'package:flutter_mobile/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import 'models/login_response.dart';

// void main() {
//   runApp(const MyMaterialApp());
// }

void main() async {
  // await dotenv.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginRegisterProvider()),
        ChangeNotifierProvider(create: (_) => ZivotinjeProvider()),
        ChangeNotifierProvider(create: (_) => ArtikliProvider()),
        ChangeNotifierProvider(create: (_) => KupacProvider()),
        ChangeNotifierProvider(create: (_) => LokacijaProvider()),
        ChangeNotifierProvider(create: (_) => NovostiProvider()),
        // ChangeNotifierProvider(create: (_) => VrsteProvider()),
        ChangeNotifierProvider(create: (_) => OsobaProvider()),
        // ChangeNotifierProvider(create: (_) => ProdavacProvider()),
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
      home: const Scaffold(
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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/Logo.jpg"),
                  fit: BoxFit.contain,
                )),
              ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: "Korisnicko ime",
                    prefixIcon: Icon(Icons.person),
                  ),
                  controller: _usernameController,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Sifra",
                    prefixIcon: Icon(Icons.lock),
                  ),
                  controller: _passwordController,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: FilledButton(
                  onPressed: () async {
                    try {
                      var username = _usernameController.text.trim();
                      var password = _passwordController.text.trim();

                      await _loginRegisterProvider.login(username, password);

                      print(
                          "RESPONSE  \n${LoginResponse.idLogiranogKorisnika} \n${LoginResponse.ulogaNaziv} \n${LoginResponse.token}");

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => MasterScreen(
                            uslov: true,
                            child: HomeScreen(),
                            index: 0,
                          ),
                        ),
                      );

                      _usernameController.text = "";
                      _passwordController.text = "";
                    } on Exception catch (e) {
                      // TODO
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: (const Text("Greska")),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Ok"),
                                  )
                                ],
                              ));
                    }
                  },
                  child: const Text("Prijavi se"),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RegistracijaOsobaScreen(),
                    ),
                  );
                },
                child: const Text("Niste registrovani?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
