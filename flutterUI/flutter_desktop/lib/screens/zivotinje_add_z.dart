import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/zivotinja.dart';
import '../providers/zivotinje_provider.dart';
import '../widgets/master_screen.dart';

class ZivotinjaAddZScreen extends StatefulWidget {
  int vrstaIdhelper;
  final VoidCallback onRowUpdated;

  ZivotinjaAddZScreen(
      {super.key, required this.onRowUpdated, required this.vrstaIdhelper});

  @override
  State<ZivotinjaAddZScreen> createState() => _ZivotinjaAddZScreenState();
}

class _ZivotinjaAddZScreenState extends State<ZivotinjaAddZScreen> {
  Zivotinja zivotinja = Zivotinja();
  int zivotinjaIdhelper = 0;
  ValueNotifier<int> buttonProgressNotifier = ValueNotifier<int>(0);
  final _formKeyZivotinja = GlobalKey<FormBuilderState>();
  final _formKey = GlobalKey<FormBuilderState>();
  List<File> _selectedImages = [];
  late ZivotinjeProvider _zivotinjeProvider;
  Map<String, dynamic> _initialValueZivotinja = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValueZivotinja = {
      'naziv': zivotinja.naziv,
      'napomena': "",
      'cijena': double.tryParse(zivotinja.cijena.toString()),
      'vrstaId': 0,
    };

    _zivotinjeProvider = context.read<ZivotinjeProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Row(
          children: [
            _buildForm1(),
            SizedBox(
              width: 15,
            ),
            _buildForm2(),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        _buttons(context, buttonProgressNotifier, widget.onRowUpdated),
      ],
    );
  }

  Expanded _buttons(BuildContext context,
      ValueNotifier<int> buttonProgressNotifier, VoidCallback funkcijaRefresh) {
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
                onPressed: buttonProgressNotifier.value == 1 &&
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
                child: Text('Završi'),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  setState(() {
                    buttonProgressNotifier.value = 0;
                  });
                  funkcijaRefresh();
                },
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
                    child: Expanded(
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
                  ),
                  Container(
                    width: 500,
                    child: Expanded(
                      child: FormBuilderTextField(
                        name: 'cijena',
                        decoration: InputDecoration(labelText: "Cijena (KM)"),
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
                    height: 40,
                  ),
                  FilledButton(
                      onPressed: buttonProgressNotifier.value == 0
                          ? () async {
                              try {
                                if (_formKeyZivotinja.currentState
                                        ?.saveAndValidate() ==
                                    true) {
                                  print(_formKeyZivotinja.currentState?.value);

                                  Map<String, dynamic> modifiedValue =
                                      Map<String, dynamic>.from(
                                          _formKeyZivotinja
                                              .currentState!.value);
                                  modifiedValue['vrstaId'] =
                                      widget.vrstaIdhelper;
                                  print("moje${modifiedValue}");

                                  var responseZivotinja =
                                      await _zivotinjeProvider
                                          .add(modifiedValue);
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
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildForm2() {
    return Expanded(
      child: Container(
        width: 340,
        height: 420,
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
                        SizedBox(height: 50.0),
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
      final id = zivotinjaIdhelper;

      await provider.uploadImages(id, _selectedImages);
      _formKey.currentState!.reset();
    }
  }
}
