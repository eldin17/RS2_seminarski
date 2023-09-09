import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_desktop/screens/registracija_korisnicki.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/osoba.dart';
import '../providers/osoba_provider.dart';

class RegistracijaOsobaScreen extends StatefulWidget {
  const RegistracijaOsobaScreen({super.key});

  @override
  State<RegistracijaOsobaScreen> createState() =>
      _RegistracijaOsobaScreenState();
}

class _RegistracijaOsobaScreenState extends State<RegistracijaOsobaScreen> {
  Osoba osoba = Osoba();
  int osobaIdhelper = 0;
  final _formKeyOsoba = GlobalKey<FormBuilderState>();
  TextEditingController dateController = TextEditingController();
  late OsobaProvider _osobaProvider;
  Map<String, dynamic> _initialValueOsoba = {};
  ValueNotifier<int> buttonProgressNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _initialValueOsoba = {
      'ime': osoba.ime,
      'prezime': osoba.prezime,
      'datumRodjenja': osoba.datumRodjenja,
    };
    _osobaProvider = context.read<OsobaProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FormaUnos(buttonProgressNotifier),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                _buttons(context, buttonProgressNotifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buttons(
      BuildContext context, ValueNotifier<int> buttonProgressNotifier) {
    return Expanded(
      child: Container(
        width: 900,
        alignment: Alignment.topRight,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: buttonProgressNotifier.value == 1
                    ? () async {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => RegistracijaKorisnickiScreen(
                                osobaIdhelper: osobaIdhelper),
                          ),
                        );
                      }
                    : null,
                child: Text('Dalje'),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  setState(() {
                    buttonProgressNotifier.value = 0;
                  });
                },
                child: Text("Nazad"),
              ),
            ],
          );
        }),
      ),
    );
  }

  FormBuilder FormaUnos(ValueNotifier<int> buttonProgressNotifier) {
    return FormBuilder(
      key: _formKeyOsoba,
      initialValue: _initialValueOsoba,
      child: Row(
        children: [
          Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
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
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 500,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: FormBuilderTextField(
                                        name: 'ime',
                                        decoration:
                                            InputDecoration(labelText: "Ime"),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Ime je obavezno';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: FormBuilderTextField(
                                        name: 'prezime',
                                        decoration: InputDecoration(
                                            labelText: "Prezime"),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Prezime je obavezno';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 500,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: FormBuilderDateTimePicker(
                                        name: 'datumRodjenja',
                                        controller: dateController,
                                        decoration: InputDecoration(
                                            labelText: "Datum rodjenja"),
                                        // validator: (value) {
                                        //   if (value == null) {
                                        //     return 'Datum je obavezan';
                                        //   }
                                        //   return null;
                                        // },
                                        inputType: InputType.date,
                                        format: DateFormat('yyyy-MM-dd'),
                                        initialDate: DateTime.now(),
                                        onChanged: (value) {
                                          // Handle date changes
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FilledButton(
                                onPressed: buttonProgressNotifier.value == 0
                                    ? () async {
                                        try {
                                          if (_formKeyOsoba.currentState
                                                  ?.saveAndValidate() ==
                                              true) {
                                            _formKeyOsoba.currentState
                                                ?.saveAndValidate();
                                            print(_formKeyOsoba
                                                .currentState?.value);

                                            var selectedDate = DateTime.parse(
                                                dateController.text);
                                            Map<String, dynamic> formData =
                                                Map<String, dynamic>.from(
                                                    _formKeyOsoba
                                                        .currentState!.value);
                                            formData['datumRodjenja'] =
                                                selectedDate
                                                    .toUtc()
                                                    .toIso8601String();

                                            var response = await _osobaProvider
                                                .add(Osoba.fromJson(formData));

                                            setState(() {
                                              osobaIdhelper = response.osobaId!;
                                              buttonProgressNotifier.value++;
                                            });
                                          }
                                        } on Exception catch (e) {
                                          // TODO
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title: Text("Error"),
                                                    content: Text(e.toString()),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text("Ok"),
                                                      )
                                                    ],
                                                  ));
                                        }
                                      }
                                    : null,
                                child: Text('Potvrdi'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
