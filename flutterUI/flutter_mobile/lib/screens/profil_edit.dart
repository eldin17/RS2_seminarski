import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobile/models/kupac.dart';
import 'package:flutter_mobile/providers/kupac_provider.dart';
import 'package:flutter_mobile/providers/lokacija.dart';
import 'package:flutter_mobile/providers/osoba_provider.dart';
import 'package:flutter_mobile/screens/profil_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/lokacija.dart';
import '../models/osoba.dart';
import '../util/util.dart';
import '../widgets/master_screen.dart';

class ProfilEdit extends StatefulWidget {
  Kupac kupac = Kupac();
  int osobaid;
  int lokacijaid;
  int kupacid;
  final VoidCallback onEditFinished;

  ProfilEdit(
      {super.key,
      required this.kupac,
      required this.onEditFinished,
      required this.osobaid,
      required this.lokacijaid,
      required this.kupacid});

  @override
  State<ProfilEdit> createState() => _ProfilEditState();
}

class _ProfilEditState extends State<ProfilEdit> {
  final _formKeyKupac = GlobalKey<FormBuilderState>();
  final _formKeyOsoba = GlobalKey<FormBuilderState>();
  final _formKeyLokacija = GlobalKey<FormBuilderState>();
  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController dateController = TextEditingController();

  File? _imageFile;

  late KupacProvider _kupacProvider;
  late OsobaProvider _osobaProvider;
  late LokacijaProvider _lokacijaProvider;

  Map<String, dynamic> _initialValueOsoba = {};
  Map<String, dynamic> _initialValueLokacija = {};
  Map<String, dynamic> _initialValueKupac = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValueOsoba = {
      'ime': widget.kupac.osoba?.ime,
      'prezime': widget.kupac.osoba?.prezime,
      'datumRodjenja': widget.kupac.osoba?.datumRodjenja,
    };

    _initialValueLokacija = {
      'drzava': widget.kupac.lokacija?.drzava,
      'grad': widget.kupac.lokacija?.grad,
      'ulica': widget.kupac.lokacija?.ulica,
    };

    _initialValueKupac = {
      //'brojNarudzbi': widget.kupac.brojNarudzbi!.toInt(),
      'kuca': widget.kupac.kuca,
      'dvoriste': widget.kupac.dvoriste,
      'stan': widget.kupac.stan,
      // 'osobaId': widget.kupac.osobaId,
      // 'lokacijaId': widget.kupac.lokacijaId,
      // 'slikaKupca': widget.kupac.slikaKupca,
      // 'korisnickiNalogId': widget.kupac.korisnickiNalogId,
    };

    _osobaProvider = context.read<OsobaProvider>();
    _kupacProvider = context.read<KupacProvider>();
    _lokacijaProvider = context.read<LokacijaProvider>();
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    podaci(),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Row podaci() {
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
                                    initialDate:
                                        widget.kupac.osoba?.datumRodjenja,
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
                                decoration:
                                    InputDecoration(labelText: "Drzava"),
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
            FormBuilder(
              key: _formKeyKupac,
              initialValue: _initialValueKupac,
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          // Container(
                          //   height: 0,
                          //   width: 0,
                          //   child: FormBuilderTextField(
                          //     name: 'brojNarudzbi',
                          //     initialValue:
                          //         widget.kupac.brojNarudzbi.toString(),
                          //     enabled: false,
                          //   ),
                          // ),
                          Container(
                            width: 280,
                            child: Expanded(
                              child: FormBuilderCheckbox(
                                initialValue: widget.kupac.kuca,
                                title: Text("Zivim u kuci"),
                                name: 'kuca',
                              ),
                            ),
                          ),
                          Container(
                            width: 280,
                            child: Expanded(
                              child: FormBuilderCheckbox(
                                initialValue: widget.kupac.dvoriste,
                                title: Text("Imam dvoriste"),
                                name: 'dvoriste',
                              ),
                            ),
                          ),
                          Container(
                            width: 280,
                            child: Expanded(
                              child: FormBuilderCheckbox(
                                initialValue: widget.kupac.stan,
                                title: Text("Zivim u stanu"),
                                name: 'stan',
                              ),
                            ),
                          ),
                          // Container(
                          //   height: 0,
                          //   width: 0,
                          //   child: FormBuilderTextField(
                          //     name: 'osobaId',
                          //     enabled: false,
                          //   ),
                          // ),
                          // Container(
                          //   height: 0,
                          //   width: 0,
                          //   child: FormBuilderTextField(
                          //     name: 'lokacijaId',
                          //     enabled: false,
                          //   ),
                          // ),
                          // Container(
                          //   height: 0,
                          //   width: 0,
                          //   child: FormBuilderTextField(
                          //     name: 'slikaKupca',
                          //     enabled: false,
                          //   ),
                          // ),
                          // Container(
                          //   height: 0,
                          //   width: 0,
                          //   child: FormBuilderTextField(
                          //     name: 'korisnickiNalogId',
                          //     enabled: false,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FormBuilder(
              key: _formKey,
              child: Container(
                width: 335,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        _imageFile == null
                            ? Image.network(
                                obradiSliku(widget.kupac.slikaKupca!),
                                width: 280,
                              )
                            : Image.file(
                                _imageFile!,
                                width: 280,
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
              ),
            ),
            Container(
              width: 325,
              child: FilledButton(
                  onPressed: () async {
                    try {
                      if (_formKeyOsoba.currentState?.saveAndValidate() == true &&
                          _formKeyLokacija.currentState?.saveAndValidate() ==
                              true &&
                          _formKeyKupac.currentState?.saveAndValidate() ==
                              true &&
                          _formKey.currentState?.saveAndValidate() == true) {
                        print(_formKeyOsoba.currentState?.value);
                        print(_formKeyLokacija.currentState?.value);
                        print(_formKeyKupac.currentState?.value);

                        var selectedDate = DateTime.parse(dateController.text);

                        Map<String, dynamic> formData =
                            Map<String, dynamic>.from(
                                _formKeyOsoba.currentState!.value);
                        formData['datumRodjenja'] =
                            selectedDate.toUtc().toIso8601String();

                        var responseOsoba = await _osobaProvider.update(
                            widget.osobaid, Osoba.fromJson(formData));

                        var responseLokacija = await _lokacijaProvider.update(
                            widget.lokacijaid,
                            Lokacija.fromJson(
                                _formKeyLokacija.currentState!.value));

                        var responseKupac = await _kupacProvider.update(
                            widget.kupacid,
                            Kupac.fromJson(_formKeyKupac.currentState!.value));

                        if (_imageFile != null) {
                          _kupacProvider.addSlikaKupca(
                              widget.kupacid, _imageFile!);
                        }

                        // showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) => AlertDialog(
                        //           title: Text("Uspjeh"),
                        //           content: Text("Uspjesan edit"),
                        //           actions: [
                        //             TextButton(
                        //               onPressed: () => Navigator.pop(context),
                        //               child: Text("Ok"),
                        //             )
                        //           ],
                        //         ));

                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            transitionDuration: Duration.zero,
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    MasterScreen(
                              child: ProfilScreen(),
                              index: 0,
                            ),
                          ),
                        );
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
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Ok"),
                                  )
                                ],
                              ));
                    }
                  },
                  child: Text("Spasi promjene")),
            ),
          ],
        )
      ],
    );
  }
}
