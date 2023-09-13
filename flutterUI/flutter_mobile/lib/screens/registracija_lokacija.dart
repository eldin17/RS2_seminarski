import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobile/screens/registracija_kupac.dart';
import 'package:provider/provider.dart';

import '../models/lokacija.dart';
import '../providers/lokacija.dart';

class RegistracijaLokacijaScreen extends StatefulWidget {
  int osobaIdhelper;
  int korisnickiNalogIdhelper;

  RegistracijaLokacijaScreen(
      {super.key,
      required this.korisnickiNalogIdhelper,
      required this.osobaIdhelper});

  @override
  State<RegistracijaLokacijaScreen> createState() =>
      _RegistracijaLokacijaScreenState();
}

class _RegistracijaLokacijaScreenState
    extends State<RegistracijaLokacijaScreen> {
  Lokacija lokacija = Lokacija();
  int lokacijaIdhelper = 0;
  ValueNotifier<int> buttonProgressNotifier = ValueNotifier<int>(0);
  final _formKeyLokacija = GlobalKey<FormBuilderState>();
  late LokacijaProvider _lokacijaProvider;
  Map<String, dynamic> _initialValueLokacija = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValueLokacija = {
      'drzava': lokacija.drzava,
      'grad': lokacija.grad,
      'ulica': lokacija.ulica,
    };

    _lokacijaProvider = context.read<LokacijaProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Registracija"),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        _buildForm1(),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildForm1() {
    return Row(children: [
      Column(
        children: [
          FormBuilder(
            key: _formKeyLokacija,
            initialValue: _initialValueLokacija,
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        Container(
                          width: 280,
                          child: Expanded(
                            child: FormBuilderTextField(
                              name: 'drzava',
                              decoration: InputDecoration(labelText: "Drzava"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Drzava je obavezna';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 280,
                          child: Expanded(
                            child: FormBuilderTextField(
                              name: 'grad',
                              decoration: InputDecoration(labelText: "Grad"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Grad je obavezan';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 280,
                          child: Expanded(
                            child: FormBuilderTextField(
                              name: 'ulica',
                              decoration: InputDecoration(labelText: "Ulica"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ulica je obavezna';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 325,
            child: FilledButton(
                onPressed: buttonProgressNotifier.value == 0
                    ? () async {
                        _formKeyLokacija.currentState?.saveAndValidate();
                        print(_formKeyLokacija.currentState?.value);

                        try {
                          var formData = Map<String, dynamic>.from(
                              _formKeyLokacija.currentState!.value);

                          var response = await _lokacijaProvider.add(
                              Lokacija.fromJson(
                                  _formKeyLokacija.currentState!.value));
                          lokacijaIdhelper = response.lokacijaId!;
                          setState(() {
                            buttonProgressNotifier.value++;
                          });
                        } on Exception catch (e) {
                          // TODO
                          // showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) => AlertDialog(
                          //           title: Text("Error"),
                          //           content: Text(e.toString()),
                          //           actions: [
                          //             TextButton(
                          //               onPressed: () => Navigator.pop(context),
                          //               child: Text("Ok"),
                          //             )
                          //           ],
                          //         ));
                        }
                      }
                    : null,
                child: Text("Potvrdi")),
          ),
          Container(
            width: 325,
            child: FilledButton(
                onPressed: buttonProgressNotifier.value == 1
                    ? () async {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => RegistracijaKupacScreen(
                              korisnickiNalogIdhelper:
                                  widget.korisnickiNalogIdhelper,
                              osobaIdhelper: widget.osobaIdhelper,
                              lokacijaIdhelper: lokacijaIdhelper,
                            ),
                          ),
                        );
                      }
                    : null,
                child: Text("Dalje")),
          ),
          SizedBox(
            height: 70,
          ),
          Container(
            width: 325,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  buttonProgressNotifier.value = 0;
                });
              },
              child: Text("Odustani"),
            ),
          ),
        ],
      )
    ]);
  }
}
