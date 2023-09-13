import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/kategorija.dart';
import 'package:flutter_desktop/providers/kategorije_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/rasa.dart';
import '../providers/rase_provider.dart';

class OstaloScreen extends StatefulWidget {
  const OstaloScreen({super.key});

  @override
  State<OstaloScreen> createState() => _OstaloScreenState();
}

class _OstaloScreenState extends State<OstaloScreen> {
  TextEditingController _kategorijaController = new TextEditingController();
  TextEditingController _rasaController = new TextEditingController();
  late KategorijeProvider _kategorijeProvider;
  late RaseProvider _raseProvider;
  Map<String, dynamic> _initialValueRasa = {};
  Map<String, dynamic> _initialValueKategorija = {};
  Rasa rasa = new Rasa();
  Kategorija kategorija = new Kategorija();
  final _formKeyRasa = GlobalKey<FormBuilderState>();
  final _formKeyKategorija = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValueRasa = {'naziv': rasa.naziv};
    _initialValueKategorija = {'naziv': kategorija.naziv};

    _kategorijeProvider = context.read<KategorijeProvider>();
    _raseProvider = context.read<RaseProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Želite proširiti poslovanje na nove vrste životinja i nove kategorije artikala?\nDodajte nove ovdje"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _rasa(context),
              _kategorija(context),
            ],
          ),
        ],
      ),
    );
  }

  FormBuilder _rasa(BuildContext context) {
    return FormBuilder(
      key: _formKeyRasa,
      initialValue: _initialValueRasa,
      child: Column(
        children: [
          Text("Životinje"),
          SizedBox(
            height: 20,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Container(
                    width: 250,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: FormBuilderTextField(
                            name: 'naziv',
                            decoration: InputDecoration(
                                labelText: "Nova vrsta zivotinja"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Naziv je obavezan';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  FilledButton(
                      onPressed: () async {
                        try {
                          if (_formKeyRasa.currentState?.saveAndValidate() ==
                              true) {
                            print(_formKeyRasa.currentState?.value);

                            var response = await _raseProvider.add(
                                Rasa.fromJson(
                                    _formKeyRasa.currentState!.value));
                          }
                          setState(() {
                            _formKeyRasa.currentState?.reset();
                          });
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Uspjeh"),
                                    content: Text("Uspjesno dodavanje!"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Ok"),
                                      )
                                    ],
                                  ));
                        } on Exception catch (e) {
                          // TODO
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Error"),
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
                      child: Text("Dodaj")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  FormBuilder _kategorija(BuildContext context) {
    return FormBuilder(
      key: _formKeyKategorija,
      initialValue: _initialValueKategorija,
      child: Column(
        children: [
          Text("Artikli"),
          SizedBox(
            height: 20,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Container(
                    width: 250,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: FormBuilderTextField(
                            name: 'naziv',
                            decoration: InputDecoration(
                                labelText: "Nova kategorija artikala"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Naziv je obavezan';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  FilledButton(
                      onPressed: () async {
                        try {
                          if (_formKeyKategorija.currentState
                                  ?.saveAndValidate() ==
                              true) {
                            print(_formKeyKategorija.currentState?.value);

                            var response = await _kategorijeProvider.add(
                                Kategorija.fromJson(
                                    _formKeyKategorija.currentState!.value));
                          }
                          setState(() {
                            _formKeyKategorija.currentState?.reset();
                          });
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Uspjeh"),
                                    content: Text("Uspjesno dodavanje!"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Ok"),
                                      )
                                    ],
                                  ));
                        } on Exception catch (e) {
                          // TODO
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Error"),
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
                      child: Text("Dodaj")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
