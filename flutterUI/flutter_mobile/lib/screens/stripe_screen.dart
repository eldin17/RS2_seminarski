import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/narudzba.dart';
import 'package:flutter_mobile/models/narudzba_info.dart';
import 'package:flutter_mobile/providers/narudzbe_provider.dart';
import 'package:flutter_mobile/providers/stripe.dart';
import 'package:provider/provider.dart';

import '../widgets/master_screen.dart';
import 'narudzbe_screen.dart';

class CheckoutPage extends StatefulWidget {
  Narudzba narudzba = Narudzba();
  CheckoutPage({super.key, required this.narudzba});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _pkController = TextEditingController();
  late NarudzbeProvider _narudzbeProvider;
  String stripePublishableKey = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stripePublishableKey = const String.fromEnvironment(
      "stripePublishableKey",
    );
    _narudzbeProvider = context.read<NarudzbeProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            stripePublishableKey != ""
                ? Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                            "Ako želite koristiti Publishable Key iz Environment-a, odaberite opciju Nastavi"),
                      ),
                      Container(
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(216, 255, 239, 0.78),
                            Color.fromRGBO(216, 255, 242, 1),
                          ]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: FilledButton(
                            onPressed: () async {
                              await StripeService.stripePaymentCheckout(
                                stripePublishableKey,
                                widget.narudzba.narudzbeArtikli,
                                widget.narudzba.zivotinje,
                                widget.narudzba.totalFinal,
                                context,
                                mounted,
                                onSuccess: () async {
                                  print("SUCCESS");
                                  var response = await _narudzbeProvider
                                      .addPayment(widget.narudzba.narudzbaId!);
                                  setState(() {
                                    NarudzbaInfo.narudzbaID = null;
                                  });
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration: Duration.zero,
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          MasterScreen(
                                        uslov: true,
                                        child: NarudzbeScreen(),
                                        index: 3,
                                      ),
                                    ),
                                  );
                                },
                                onCancel: () async {
                                  print("CANCEL"); //cancel
                                  var response = await _narudzbeProvider
                                      .cancel(widget.narudzba.narudzbaId!);
                                },
                                onError: (e) async {
                                  print("ERROR: ${e.toString()}"); //cancel
                                  var response = await _narudzbeProvider
                                      .cancel(widget.narudzba.narudzbaId!);
                                },
                              );
                            },
                            child: Text("Nastavi"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                            "Ako želite promijeniti Publishable Key, unesite novi i odaberite opciju Promijeni"),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(216, 255, 239, 0.78),
                            Color.fromRGBO(216, 255, 242, 1),
                          ]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 300,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: "Publishable Key",
                                    prefixIcon: Icon(Icons.key),
                                  ),
                                  controller: _pkController,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: 300,
                                child: FilledButton(
                                  onPressed: () async {
                                    await StripeService.stripePaymentCheckout(
                                      _pkController.text,
                                      widget.narudzba.narudzbeArtikli,
                                      widget.narudzba.zivotinje,
                                      widget.narudzba.totalFinal,
                                      context,
                                      mounted,
                                      onSuccess: () async {
                                        print("SUCCESS");
                                        var response =
                                            await _narudzbeProvider.addPayment(
                                                widget.narudzba.narudzbaId!);
                                        setState(() {
                                          NarudzbaInfo.narudzbaID = null;
                                        });
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            transitionDuration: Duration.zero,
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                MasterScreen(
                                              uslov: true,
                                              child: NarudzbeScreen(),
                                              index: 3,
                                            ),
                                          ),
                                        );
                                      },
                                      onCancel: () async {
                                        print("CANCEL"); //cancel
                                        var response =
                                            await _narudzbeProvider.cancel(
                                                widget.narudzba.narudzbaId!);
                                      },
                                      onError: (e) async {
                                        print(
                                            "ERROR: ${e.toString()}"); //cancel
                                        var response =
                                            await _narudzbeProvider.cancel(
                                                widget.narudzba.narudzbaId!);
                                      },
                                    );
                                  },
                                  child: Text("Promijeni"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  )
                : _noEnvPK(),
            Container(
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  var response = await _narudzbeProvider
                      .deactivate(NarudzbaInfo.narudzbaID!);
                  Navigator.of(context).pop();
                },
                child: Text("Odustani"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _noEnvPK() {
    return Container(
        child: Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text("Potrebno je unijeti Publishable Key!\n"),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(216, 255, 239, 0.78),
              Color.fromRGBO(216, 255, 242, 1),
            ]),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Publishable Key",
                      prefixIcon: Icon(Icons.key),
                    ),
                    controller: _pkController,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FilledButton(
                  onPressed: () async {
                    await StripeService.stripePaymentCheckout(
                      _pkController.text,
                      widget.narudzba.narudzbeArtikli,
                      widget.narudzba.zivotinje,
                      widget.narudzba.totalFinal,
                      context,
                      mounted,
                      onSuccess: () async {
                        print("SUCCESS");
                        var response = await _narudzbeProvider
                            .addPayment(widget.narudzba.narudzbaId!);
                        setState(() {
                          NarudzbaInfo.narudzbaID = null;
                        });
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: Duration.zero,
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    MasterScreen(
                              uslov: true,
                              child: NarudzbeScreen(),
                              index: 3,
                            ),
                          ),
                        );
                      },
                      onCancel: () async {
                        print("CANCEL"); //cancel
                        var response = await _narudzbeProvider
                            .cancel(widget.narudzba.narudzbaId!);
                      },
                      onError: (e) async {
                        print("ERROR: ${e.toString()}"); //cancel
                        var response = await _narudzbeProvider
                            .cancel(widget.narudzba.narudzbaId!);
                      },
                    );
                  },
                  child: Text("Potvrdi Publishable Key"),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
