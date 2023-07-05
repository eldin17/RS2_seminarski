import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_desktop/models/korisnicki_nalog.dart';
import 'package:flutter_desktop/models/osoba.dart';
import 'package:flutter_desktop/models/registracija_model.dart';
import 'package:flutter_desktop/providers/login_register.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/prodavac.dart';
import '../providers/osoba_provider.dart';
import '../providers/prodavac_provider.dart';

class RegistracijaScreen extends StatefulWidget {
  const RegistracijaScreen({super.key});

  @override
  State<RegistracijaScreen> createState() => _RegistracijaScreenState();
}

class _RegistracijaScreenState extends State<RegistracijaScreen> {
  File? _imageFile;
  Osoba osoba = Osoba();
  RegisterModel registerModel = RegisterModel();
  Prodavac prodavac = Prodavac();
  int osobaIdhelper = 0;
  int korisnickiNalogIdhelper = 0;
  int prodavacIdhelper = 0;
  ValueNotifier<int> buttonProgressNotifier = ValueNotifier<int>(0);
  final _formKeyOsoba = GlobalKey<FormBuilderState>();
  final _formKeyProdavac = GlobalKey<FormBuilderState>();
  final _formKeyKorisnickiNalog = GlobalKey<FormBuilderState>();
  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController dateController = TextEditingController();

  late OsobaProvider _osobaProvider;
  late LoginRegisterProvider _loginRegisterProvider;
  late ProdavacProvider _prodavacProvider;

  Map<String, dynamic> _initialValueOsoba = {};
  Map<String, dynamic> _initialValueKorisnickiNalog = {};
  Map<String, dynamic> _initialValueProdavac = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValueOsoba = {
      'ime': osoba.ime,
      'prezime': osoba.prezime,
      'datumRodjenja': osoba.datumRodjenja,
    };

    _initialValueKorisnickiNalog = {
      'username': registerModel.username,
      'password': registerModel.password,
      'ulogaId': 1,
    };

    _initialValueProdavac = {
      'poslovnaJedinica': prodavac.poslovnaJedinica,
      'osobaId': 0,
      'korisnickiNalogId': 0,
      'slikaProdavca': 'http://localhost:7152/SlikeProdavaca/Logo.jpg',
    };

    _osobaProvider = context.read<OsobaProvider>();
    _loginRegisterProvider = context.read<LoginRegisterProvider>();
    _prodavacProvider = context.read<ProdavacProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Padding(
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
              _buttons(context, buttonProgressNotifier),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buttons(
      BuildContext context, ValueNotifier<int> buttonProgressNotifier) {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FilledButton(
                  onPressed: buttonProgressNotifier.value == 0
                      ? () async {
                          try {
                            if (_formKeyOsoba.currentState?.saveAndValidate() ==
                                true) {
                              _formKeyOsoba.currentState?.saveAndValidate();
                              print(_formKeyOsoba.currentState?.value);

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
                            }
                          } on Exception catch (e) {
                            // TODO
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Ok"),
                                        )
                                      ],
                                    ));
                          }
                        }
                      : null,
                  child: Text("1.Dodaj osobu")),
              FilledButton(
                  onPressed: buttonProgressNotifier.value == 1
                      ? () async {
                          try {
                            if (_formKeyKorisnickiNalog.currentState
                                    ?.saveAndValidate() ==
                                true) {
                              print(
                                  _formKeyKorisnickiNalog.currentState?.value);

                              var formData = Map<String, dynamic>.from(
                                  _formKeyKorisnickiNalog.currentState!.value);

                              formData['ulogaId'] = 1;

                              var response = await _loginRegisterProvider
                                  .register(RegisterModel.fromJson(formData));

                              korisnickiNalogIdhelper =
                                  response.korisnickiNalogId!;
                              setState(() {
                                buttonProgressNotifier.value++;
                              });
                            }
                          } on Exception catch (e) {
                            // TODO
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Ok"),
                                        )
                                      ],
                                    ));
                          }
                        }
                      : null,
                  child: Text("2.Dodaj korisnicki nalog")),
              FilledButton(
                  onPressed: buttonProgressNotifier.value == 2
                      ? () async {
                          try {
                            if (_formKeyProdavac.currentState
                                    ?.saveAndValidate() ==
                                true) {
                              print(_formKeyProdavac.currentState?.value);

                              var formData = Map<String, dynamic>.from(
                                  _formKeyProdavac.currentState!.value);

                              formData['osobaId'] = osobaIdhelper;
                              formData['korisnickiNalogId'] =
                                  korisnickiNalogIdhelper;
                              print("moje${formData}");

                              var response = await _prodavacProvider
                                  .add(Prodavac.fromJson(formData));
                              prodavacIdhelper = response.prodavacId!;
                              setState(() {
                                buttonProgressNotifier.value++;
                              });
                            }
                          } on Exception catch (e) {
                            // TODO
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Ok"),
                                        )
                                      ],
                                    ));
                          }
                        }
                      : null,
                  child: Text("3.Dodaj prodavca")),
              ElevatedButton(
                onPressed: buttonProgressNotifier.value == 3 &&
                        _imageFile != null
                    ? () async {
                        if (_formKey.currentState!.saveAndValidate()) {
                          _prodavacProvider.addSlikaProdavca(
                              prodavacIdhelper, _imageFile!);
                          setState(() {
                            buttonProgressNotifier.value++;
                          });
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Uspjeh"),
                                    content: Text("Uspjesna registracija"),
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
                child: Text('4.Postavi sliku'),
              ),
              ElevatedButton(
                onPressed: buttonProgressNotifier.value == 0 ||
                        buttonProgressNotifier.value == 4
                    ? () async {
                        Navigator.of(context).pop();
                        setState(() {
                          buttonProgressNotifier.value = 0;
                        });
                      }
                    : null,
                child: Text("Nazad"),
              ),
            ],
          );
        }),
      ),
    );
  }

  Row _buildForm1() {
    return Row(
      children: [
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
                                    decoration:
                                        InputDecoration(labelText: "Prezime"),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FormBuilder(
              key: _formKeyKorisnickiNalog,
              initialValue: _initialValueKorisnickiNalog,
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Container(
                            width: 500,
                            child: Row(
                              children: [
                                Expanded(
                                  child: FormBuilderTextField(
                                    name: 'username',
                                    decoration: InputDecoration(
                                        labelText: "Korisnicko ime"),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Korisnicko ime je obavezno';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: FormBuilderTextField(
                                    name: 'password',
                                    decoration:
                                        InputDecoration(labelText: "Sifra"),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Sifra je obavezna';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 0,
                            width: 0,
                            child: FormBuilderTextField(
                              name: 'ulogaId',
                              initialValue: '1',
                              enabled: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FormBuilder(
              key: _formKeyProdavac,
              initialValue: _initialValueProdavac,
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Container(
                            width: 500,
                            child: Row(
                              children: [
                                Expanded(
                                  child: FormBuilderTextField(
                                    name: 'poslovnaJedinica',
                                    decoration: InputDecoration(
                                        labelText: "Poslovna jedinica"),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Poslovna jedinica je obavezna';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 0,
                            width: 0,
                            child: FormBuilderTextField(
                              name: 'osobaId',
                              initialValue: '0',
                              enabled: false,
                            ),
                          ),
                          Container(
                            height: 0,
                            width: 0,
                            child: FormBuilderTextField(
                              name: 'korisnickiNalogId',
                              initialValue: '0',
                              enabled: false,
                            ),
                          ),
                          Container(
                            height: 0,
                            width: 0,
                            child: FormBuilderTextField(
                              name: 'slikaProdavca',
                              initialValue:
                                  'http://localhost:7152/SlikeProdavaca/Logo.jpg',
                              enabled: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      if (_imageFile != null)
                        Image.file(
                          _imageFile!,
                          width: 250,
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _selectImage,
                        child: Text('Odaberi sliku'),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
