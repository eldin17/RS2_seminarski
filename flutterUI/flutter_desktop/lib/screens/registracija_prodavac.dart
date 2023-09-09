import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import '../models/prodavac.dart';
import '../providers/prodavac_provider.dart';

class RegistracijaProdavacScreen extends StatefulWidget {
  int korisnickiNalogIdhelper;
  int osobaIdhelper;
  RegistracijaProdavacScreen(
      {super.key,
      required this.korisnickiNalogIdhelper,
      required this.osobaIdhelper});

  @override
  State<RegistracijaProdavacScreen> createState() =>
      _RegistracijaProdavacScreenState();
}

class _RegistracijaProdavacScreenState
    extends State<RegistracijaProdavacScreen> {
  Prodavac prodavac = Prodavac();
  int prodavacIdhelper = 0;
  ValueNotifier<int> buttonProgressNotifier = ValueNotifier<int>(0);
  final _formKeyProdavac = GlobalKey<FormBuilderState>();
  late ProdavacProvider _prodavacProvider;
  Map<String, dynamic> _initialValueProdavac = {};
  File? _imageFile;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _initialValueProdavac = {
      'poslovnaJedinica': prodavac.poslovnaJedinica,
      'osobaId': 0,
      'korisnickiNalogId': 0,
      'slikaProdavca': 'http://localhost:7152/SlikeProdavaca/Logo.jpg',
    };
    _prodavacProvider = context.read<ProdavacProvider>();
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            height: 550,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FormaUnos(buttonProgressNotifier),
                    FormaSlika(buttonProgressNotifier)
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
              ElevatedButton(
                onPressed: buttonProgressNotifier.value == 1 &&
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
                child: Text('Završi'),
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
      key: _formKeyProdavac,
      initialValue: _initialValueProdavac,
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
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
                        width: 300,
                        height: 150,
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
                      SizedBox(
                        height: 40,
                      ),
                      FilledButton(
                          onPressed: buttonProgressNotifier.value == 0
                              ? () async {
                                  try {
                                    if (_formKeyProdavac.currentState
                                            ?.saveAndValidate() ==
                                        true) {
                                      print(
                                          _formKeyProdavac.currentState?.value);

                                      var formData = Map<String, dynamic>.from(
                                          _formKeyProdavac.currentState!.value);

                                      formData['osobaId'] =
                                          widget.osobaIdhelper;
                                      formData['korisnickiNalogId'] =
                                          widget.korisnickiNalogIdhelper;
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
                                        builder: (BuildContext context) =>
                                            AlertDialog(
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
                          child: Text("Potvrdi")),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  FormBuilder FormaSlika(ValueNotifier<int> buttonProgressNotifier) {
    return FormBuilder(
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
    );
  }
}
