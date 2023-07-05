import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/zivotinja.dart';
import 'package:flutter_desktop/providers/vrste_provider.dart';
import 'package:flutter_desktop/providers/zivotinje_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/vrsta.dart';
import '../util/util.dart';
import 'package:image_picker/image_picker.dart';

class ZivotinjeAdd extends StatefulWidget {
  final VoidCallback onRowUpdated;
  ZivotinjeAdd({super.key, required this.onRowUpdated});

  @override
  State<ZivotinjeAdd> createState() => _ZivotinjeAddState();
}

class _ZivotinjeAddState extends State<ZivotinjeAdd> {
  Zivotinja zivotinja = Zivotinja();
  Vrsta vrsta = Vrsta();
  int vrstaIdhelper = 0;
  int zivotinjaIdhelper = 0;
  ValueNotifier<int> buttonProgressNotifier = ValueNotifier<int>(0);

  final _formKeyVrsta = GlobalKey<FormBuilderState>();
  final _formKeyZivotinja = GlobalKey<FormBuilderState>();
  final _formKey = GlobalKey<FormBuilderState>();
  List<File> _selectedImages = [];

  late ZivotinjeProvider _zivotinjeProvider;
  late VrsteProvider _vrstaProvider;

  Map<String, dynamic> _initialValueVrsta = {};
  Map<String, dynamic> _initialValueZivotinja = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValueVrsta = {
      'naziv': vrsta.naziv,
      'rasa': vrsta.rasa,
      'opis': vrsta.opis,
      'boja': vrsta.boja,
      'starost': int.tryParse(vrsta.starost.toString()),
      'prostor': vrsta.prostor,
    };

    _initialValueZivotinja = {
      'naziv': zivotinja.naziv,
      'napomena': zivotinja.napomena,
      'cijena': double.tryParse(zivotinja.cijena.toString()),
      'vrstaId': 0,
    };

    _zivotinjeProvider = context.read<ZivotinjeProvider>();
    _vrstaProvider = context.read<VrsteProvider>();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                _buildForm1(),
                SizedBox(
                  height: 20,
                ),
                _buildForm2(),
              ],
            ),
            SizedBox(
              width: 15,
            ),
            _buildForm3(),
          ],
        ),
        _buttons(context, buttonProgressNotifier, widget.onRowUpdated),
      ],
    );
  }

  Expanded _buttons(BuildContext context,
      ValueNotifier<int> buttonProgressNotifier, VoidCallback funkcijaRefresh) {
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
                            if (_formKeyVrsta.currentState?.saveAndValidate() ==
                                    true &&
                                _formKeyZivotinja.currentState
                                        ?.saveAndValidate() ==
                                    true) {
                              print(_formKeyVrsta.currentState?.value);
                              print(_formKeyZivotinja.currentState?.value);
                              var response = await _vrstaProvider.add(
                                  Vrsta.fromJson(
                                      _formKeyVrsta.currentState!.value));

                              vrstaIdhelper = response.vrstaId!;

                              // var modifiedValue = Map<String, dynamic>.from(
                              //     _formKeyZivotinja.currentState!.value);

                              // modifiedValue['vrstaId'] = vrstaIdhelper;
                              // print("moje${modifiedValue}");

                              // await Future.delayed((Duration(seconds: 10)));

                              // var responseZivotinja = await _zivotinjeProvider
                              //     .add(Zivotinja.fromJson(modifiedValue));
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
                  child: Text("1.Dodaj vrstu")),
              FilledButton(
                  onPressed: buttonProgressNotifier.value == 1
                      ? () async {
                          try {
                            if (_formKeyVrsta.currentState?.saveAndValidate() ==
                                    true &&
                                _formKeyZivotinja.currentState
                                        ?.saveAndValidate() ==
                                    true) {
                              print(_formKeyVrsta.currentState?.value);
                              print(_formKeyZivotinja.currentState?.value);

                              Map<String, dynamic> modifiedValue =
                                  Map<String, dynamic>.from(
                                      _formKeyZivotinja.currentState!.value);
                              modifiedValue['vrstaId'] = vrstaIdhelper;
                              print("moje${modifiedValue}");

                              var responseZivotinja =
                                  await _zivotinjeProvider.add(modifiedValue);
                              zivotinjaIdhelper =
                                  responseZivotinja.zivotinjaId!;
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
                  child: Text("2.Dodaj zivotinju")),
              FilledButton(
                onPressed: buttonProgressNotifier.value == 2 &&
                        _selectedImages.length > 0
                    ? () async => {
                          await _submitForm(context),
                          setState(() {
                            buttonProgressNotifier.value++;
                          }),
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Uspjeh"),
                                    content: Text("Uspjesno dodavanje"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Ok"),
                                      )
                                    ],
                                  )),
                        }
                    : null,
                child: Text('3.Postavi slike'),
              ),
              ElevatedButton(
                onPressed: buttonProgressNotifier.value == 0 ||
                        buttonProgressNotifier.value == 3
                    ? () async {
                        Navigator.of(context).pop();
                        setState(() {
                          buttonProgressNotifier.value = 0;
                        });
                        funkcijaRefresh();
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

  FormBuilder _buildForm1() {
    return FormBuilder(
      key: _formKeyVrsta,
      initialValue: _initialValueVrsta,
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
                            name: 'naziv',
                            decoration: InputDecoration(labelText: "Naziv"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Naziv je obavezan';
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: FormBuilderTextField(
                            name: 'rasa',
                            decoration: InputDecoration(labelText: "Rasa"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Rasa je obavezna';
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
                          child: FormBuilderTextField(
                            name: 'boja',
                            decoration: InputDecoration(labelText: "Boja"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Boja je obavezna';
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: FormBuilderTextField(
                            name: 'starost',
                            decoration:
                                InputDecoration(labelText: "Starost (godine)"),
                            keyboardType: TextInputType.number,
                            valueTransformer: (value) =>
                                int.tryParse(value ?? ''),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Starost je obavezna';
                              }
                              final parsedValue = int.tryParse(value);
                              if (parsedValue == null) {
                                return 'Starost mora biti broj';
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: FormBuilderCheckbox(
                            initialValue: false,
                            title: Text("Potreban veci prostor"),
                            name: 'prostor',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 500,
                    child: FormBuilderTextField(
                      name: 'opis',
                      maxLines: 2,
                      decoration: InputDecoration(labelText: "Opis"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Opis je obavezan';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  FormBuilder _buildForm2() {
    return FormBuilder(
      key: _formKeyZivotinja,
      initialValue: _initialValueZivotinja,
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
                            name: 'naziv',
                            decoration: InputDecoration(labelText: "Naziv"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Naziv je obavezan';
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: FormBuilderTextField(
                            name: 'cijena',
                            decoration:
                                InputDecoration(labelText: "Cijena (KM)"),
                            keyboardType: TextInputType.number,
                            valueTransformer: (value) =>
                                double.tryParse(value ?? ''),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Cijena je obavezna';
                              }
                              final parsedValue = int.tryParse(value);
                              if (parsedValue == null) {
                                return 'Cijena mora biti broj';
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
                    child: FormBuilderTextField(
                      name: 'napomena',
                      maxLines: 2,
                      decoration: InputDecoration(labelText: "Napomena"),
                    ),
                  ),
                  Container(
                    height: 0,
                    width: 0,
                    child: FormBuilderTextField(
                      name: 'vrstaId',
                      initialValue: '0',
                      enabled: false,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //-----------------------------------------------
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildForm3() {
    return Expanded(
      child: Container(
        width: 340,
        height: 485,
        child: Card(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 16.0),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 250, // Adjust the height as needed
                            // Customize other options as per your requirement
                          ),
                          items: _selectedImages.map((image) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(),
                                  child: Image.file(
                                    image,
                                    fit: BoxFit.fitHeight,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 100.0),
                        ElevatedButton(
                          onPressed: _pickImages,
                          child: Text('Odaberi slike'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage(imageQuality: 80);
    if (pickedImages != null) {
      setState(() {
        _selectedImages =
            pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
      });
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.saveAndValidate()) {
      final provider = Provider.of<ZivotinjeProvider>(context, listen: false);
      // final id = _formKey.currentState!.fields['id']!.value as int;
      final id = zivotinjaIdhelper;

      await provider.uploadImages(id, _selectedImages);
      // Reset form and clear selected images
      _formKey.currentState!.reset();
      // setState(() {
      //   _selectedImages.clear();
      // });
    }
  }
}
