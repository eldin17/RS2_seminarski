import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobile/screens/registracija_korisnicki.dart';
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
  ValueNotifier<int> buttonProgressNotifier = ValueNotifier<int>(0);
  final _formKeyOsoba = GlobalKey<FormBuilderState>();
  TextEditingController dateController = TextEditingController();
  late OsobaProvider _osobaProvider;
  Map<String, dynamic> _initialValueOsoba = {};

  @override
  void initState() {
    // TODO: implement initState
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
            key: _formKeyOsoba,
            initialValue: _initialValueOsoba,
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
                              name: 'ime',
                              decoration: InputDecoration(labelText: "Ime"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ime je obavezno';
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
                              name: 'prezime',
                              decoration: InputDecoration(labelText: "Prezime"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Prezime je obavezno';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 280,
                          child: Row(
                            children: [
                              Expanded(
                                child: FormBuilderDateTimePicker(
                                  name: 'datumRodjenja',
                                  controller: dateController,
                                  decoration: InputDecoration(
                                      labelText: "Datum rodjenja"),
                                  inputType: InputType.date,
                                  format: DateFormat('yyyy-MM-dd'),
                                  initialDate: DateTime.now(),
                                  onChanged: (value) {},
                                ),
                              ),
                            ],
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
                        _formKeyOsoba.currentState?.saveAndValidate();
                        print(_formKeyOsoba.currentState?.value);

                        try {
                          var selectedDate =
                              DateTime.parse(dateController.text);
                          Map<String, dynamic> formData =
                              Map<String, dynamic>.from(
                                  _formKeyOsoba.currentState!.value);
                          formData['datumRodjenja'] =
                              selectedDate.toUtc().toIso8601String();

                          var response = await _osobaProvider
                              .add(Osoba.fromJson(formData));

                          osobaIdhelper = response.osobaId!;
                          setState(() {
                            buttonProgressNotifier.value++;
                          });
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
                            builder: (context) => RegistracijaKorisnickiScreen(
                              osobaIdhelper: osobaIdhelper,
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
