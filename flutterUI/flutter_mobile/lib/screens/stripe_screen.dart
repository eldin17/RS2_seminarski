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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _narudzbeProvider = context.read<NarudzbeProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
            ElevatedButton(
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
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            MasterScreen(
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
    );
  }
}
