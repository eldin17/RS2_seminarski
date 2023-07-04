import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mobile/models/artikal.dart';
import 'package:flutter_mobile/models/narudzba_artikal.dart';
import 'package:flutter_mobile/models/zivotinja.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';

class StripeService {
  static String secretKey =
      "sk_test_51NKIziFfEoaxkl089RnSGEx4IuNXXr8hBDZlCj8xpJ0v7FuBMlOKsyYrSU4lNRBk2O7LGVPVVlnJFOQhrDRk6fT800DYvuiqU1";
  static String publishableKey = "";

  static Future<dynamic> createCheckoutSession(
    List<NarudzbaArtikal> artikli,
    List<Zivotinja> zivotinje,
    totalAmount,
  ) async {
    final uri = Uri.parse("https://api.stripe.com/v1/checkout/sessions");

    String lineItems = "";
    int index = 0;
    int qty = 1;

    artikli.forEach(
      (element) {
        var cijenaArtikla =
            ((element.artikal?.cijena)! * 100).round().toString();
        lineItems +=
            "&line_items[$index][price_data][product_data][name]=${element.artikal?.naziv}";
        lineItems +=
            "&line_items[$index][price_data][unit_amount]=$cijenaArtikla";
        lineItems += "&line_items[$index][price_data][currency]=BAM";
        lineItems += "&line_items[$index][quantity]=${qty.toString()}";
        index++;
      },
    );

    zivotinje.forEach(
      (element) {
        var cijenaZivotinja = ((element.cijena)! * 100).round().toString();
        lineItems +=
            "&line_items[$index][price_data][product_data][name]=${element.naziv}";
        lineItems +=
            "&line_items[$index][price_data][unit_amount]=$cijenaZivotinja";
        lineItems += "&line_items[$index][price_data][currency]=BAM";
        lineItems += "&line_items[$index][quantity]=${qty.toString()}";

        index++;
      },
    );

    final response = await http.post(
      uri,
      body:
          'success_url=https://checkout.stripe.dev/success&mode=payment$lineItems',
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );
    return json.decode(response.body)["id"];
  }

  static Future<dynamic> stripePaymentCheckout(
    pkStripe,
    artikli,
    zivotinje,
    subTotal,
    context,
    mounted, {
    onSuccess,
    onCancel,
    onError,
  }) async {
    final String sessionId =
        await createCheckoutSession(artikli, zivotinje, subTotal);
    final result = await redirectToCheckout(
        context: context,
        sessionId: sessionId,
        publishableKey: pkStripe,
        successUrl: "https://checkout.stripe.dev/success",
        canceledUrl: "https://checkout.stripe.dev/cancel");
    if (mounted) {
      final text = result.when(
        redirected: () => 'Redirected Successfuly',
        success: () => onSuccess(),
        canceled: () => onCancel(),
        error: (e) => onError(e),
      );
      return text;
    }
  }
}
