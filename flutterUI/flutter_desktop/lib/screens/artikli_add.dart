import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/artikal.dart';
import 'package:flutter_desktop/models/kategorija.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../providers/artikli_provider.dart';
import '../providers/kategorije_provider.dart';
import '../util/util.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ArtikliAdd extends StatefulWidget {
  final VoidCallback onRowUpdated;

  const ArtikliAdd({super.key, required this.onRowUpdated});

  @override
  State<ArtikliAdd> createState() => _ArtikliAddState();
}

class _ArtikliAddState extends State<ArtikliAdd> {
  Artikal artikal = Artikal();
  int artikalIdhelper = 0;
  int kategorijaIdhelper = 0;
  ValueNotifier<int> buttonProgressNotifier = ValueNotifier<int>(0);

  final _formKeyArtikal = GlobalKey<FormBuilderState>();
  final _formKey = GlobalKey<FormBuilderState>();
  List<File> _selectedImages = [];

  late ArtikliProvider _artikliProvider;
  late KategorijeProvider _kategorijeProvider;
  bool isLoading = true;

  SearchResult<Kategorija>? kategorijeResult;
  Map<String, dynamic> _initialValueArtikal = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValueArtikal = {
      'naziv': artikal.naziv,
      'cijena': double.tryParse(artikal.cijena.toString()),
      'opis': artikal.opis,
      'kategorijaId': int.tryParse(artikal.kategorijaId.toString()),
    };

    _artikliProvider = context.read<ArtikliProvider>();
    _kategorijeProvider = context.read<KategorijeProvider>();

    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future initForm() async {
    kategorijeResult = await _kategorijeProvider.get();
    print(kategorijeResult?.data);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                isLoading ? Container() : _buildForm1(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            SizedBox(
              width: 15,
            ),
            _buildForm3(),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        _buttons(context, buttonProgressNotifier, widget.onRowUpdated),
      ],
    );
  }

  Expanded _buttons(BuildContext context,
      ValueNotifier<int> buttonProgressNotifier, VoidCallback funkcijaRefresh) {
    return Expanded(
      child: Container(
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
                width: 15,
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
      key: _formKeyArtikal,
      initialValue: _initialValueArtikal,
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                              final parsedValue = double.tryParse(value);
                              if (parsedValue == null) {
                                return 'Cijena mora biti broj';
                              }
                              if (value != null &&
                                  (parsedValue > 100000 || parsedValue < 1)) {
                                return 'Raspon 1-100000';
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
                  Flexible(
                    child: Container(
                      width: 500,
                      child: FormBuilderDropdown<String>(
                        name: 'kategorijaId',
                        decoration: InputDecoration(
                          labelText: 'Kategorija',
                          suffix: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _formKeyArtikal
                                  .currentState!.fields['kategorijaId']
                                  ?.reset();
                            },
                          ),
                          hintText: 'Vrsta proizvoda',
                        ),
                        items: kategorijeResult?.data
                                .map((item) => DropdownMenuItem(
                                      alignment: AlignmentDirectional.center,
                                      value: item.kategorijaId.toString(),
                                      child: Text(item.naziv ?? ""),
                                    ))
                                .toList() ??
                            [],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kategorija je obavezna';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  FilledButton(
                      onPressed: buttonProgressNotifier.value == 0
                          ? () async {
                              try {
                                if (_formKeyArtikal.currentState
                                        ?.saveAndValidate() ==
                                    true) {
                                  print(_formKeyArtikal.currentState?.value);

                                  var responseArtikal = await _artikliProvider
                                      .add(_formKeyArtikal.currentState?.value);
                                  artikalIdhelper = responseArtikal.artikalId!;
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
      final provider = Provider.of<ArtikliProvider>(context, listen: false);
      // final id = _formKey.currentState!.fields['id']!.value as int;
      final id = artikalIdhelper;

      await provider.uploadImages(id, _selectedImages);
      // Reset form and clear selected images
      _formKey.currentState!.reset();
      // setState(() {
      //   _selectedImages.clear();
      // });
    }
  }
}
