import 'dart:convert';

import 'package:flutter_mobile/models/narudzba.dart';
import 'package:flutter_mobile/models/narudzba_artikal.dart';
import 'package:flutter_mobile/models/narudzba_info.dart';
import 'package:flutter_mobile/models/zivotinja.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';

import '../models/login_response.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StripeService with ChangeNotifier {
  static String secretKey =
      "sk_test_51NKIziFfEoaxkl089RnSGEx4IuNXXr8hBDZlCj8xpJ0v7FuBMlOKsyYrSU4lNRBk2O7LGVPVVlnJFOQhrDRk6fT800DYvuiqU1";
  static String publishableKey = "";

  static String _baseUrl = "http://10.0.2.2:7152/";
  static String _endpoint = "api/Narudzba";

  StripeService() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:7152/");
  }

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

    final sessionData = await retrieveCheckoutSession(sessionId);

    final paymentId = sessionData["id"];
    final paymentIntent = sessionData["payment_intent"];
    final referenceResponose = await stripeReference(NarudzbaInfo.narudzbaID!,
        paymentId.toString(), paymentIntent.toString());

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

  static Future<Map<String, dynamic>> retrieveCheckoutSession(
    String sessionId,
  ) async {
    final uri =
        Uri.parse("https://api.stripe.com/v1/checkout/sessions/$sessionId");

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    final sessionData = json.decode(response.body);
    return sessionData;
  }

  static Future<Narudzba> stripeReference(
      int id, String PaymentId, String PaymentIntent) async {
    var url = "$_baseUrl$_endpoint/stripeReference/$id";

    var headers = {
      "Authorization": "Bearer ${LoginResponse.token}",
      'accept': 'text/plain',
      'Content-Type': 'application/json',
    };
    var uri = Uri.parse(url);
    var body = jsonEncode({
      "paymentId": PaymentId,
      "paymentIntent": PaymentIntent,
    });

    var response = await http.put(
      uri,
      headers: headers,
      body: body,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return Narudzba.fromJson(data);
    } else {
      throw Exception("Greska!");
    }
  }
}

bool isValidResponse(http.Response response) {
  if (response.statusCode < 299) {
    return true;
  } else if (response.statusCode == 401) {
    throw Exception("Unauthorized");
  } else {
    throw Exception(
        "Greska. Molimo pokusajte ponovo. Code:${response.statusCode}");
  }
}
