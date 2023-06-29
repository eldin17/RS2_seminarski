import 'package:flutter/material.dart';
import 'package:flutter_desktop/providers/zivotinje_provider.dart';
import 'package:flutter_desktop/screens/zivotinje_screen.dart';
import 'package:flutter_desktop/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/login_response.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ZivotinjeProvider _zivotinjeProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _zivotinjeProvider = context.read<ZivotinjeProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return homeMethod();
  }

  Scaffold homeMethod() {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    20.0), // Set the desired border radius
                child: Image.asset(
                  "assets/images/logo.jpg",
                  height: 180,
                ),
              ),
              Text(
                "Dobro došli!",
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
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
                child: Text("Nastavi"),
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    LoginResponse.idLogiranogKorisnika = null;
                    LoginResponse.ulogaNaziv = null;
                    LoginResponse.token = null;
                    Navigator.of(context).pop();
                  });
                },
                child: Text("Odjavi se"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
