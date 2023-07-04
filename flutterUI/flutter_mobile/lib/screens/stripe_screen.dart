import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/narudzba.dart';
import 'package:flutter_mobile/providers/stripe.dart';

class CheckoutPage extends StatefulWidget {
  Narudzba narudzba = Narudzba();
  CheckoutPage({super.key, required this.narudzba});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _pkController = TextEditingController();

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
                  onSuccess: () {
                    print("SUCCESS");
                  },
                  onCancel: () {
                    print("CANCEL");
                  },
                  onError: (e) {
                    print("ERROR: ${e.toString()}");
                  },
                );
              },
              child: Text("Potvrdi publishable key"),
            ),
          ],
        ),
      ),
    );
  }
}
