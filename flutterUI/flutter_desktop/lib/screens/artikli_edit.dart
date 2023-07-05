import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desktop/screens/artikli_screen.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/artikal.dart';
import '../models/kategorija.dart';
import '../models/search_result.dart';
import '../models/slika.dart';
import '../providers/artikli_provider.dart';
import '../providers/kategorije_provider.dart';
import '../widgets/master_screen.dart';

class ArtikliEdit extends StatefulWidget {
  Artikal artikal = Artikal();
  final VoidCallback onRowUpdated;

  ArtikliEdit({super.key, required this.onRowUpdated, required this.artikal});

  @override
  State<ArtikliEdit> createState() => _ArtikliEditState();
}

class _ArtikliEditState extends State<ArtikliEdit> {
  final _formKeyArtikal = GlobalKey<FormBuilderState>();
  final _formKey = GlobalKey<FormBuilderState>();
  List<File> _selectedImages = [];
  List<Slika> _loadedImages = [];

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
      'naziv': widget.artikal.naziv,
      'cijena': widget.artikal.cijena,
      'opis': widget.artikal.opis,
      'kategorijaId': widget.artikal.kategorijaId,
    };

    _artikliProvider = context.read<ArtikliProvider>();
    _kategorijeProvider = context.read<KategorijeProvider>();

    _loadedImages = widget.artikal.slike!;

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
          crossAxisAlignment: CrossAxisAlignment.start,
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
        _buttons(context, widget.onRowUpdated),
      ],
    );
  }

  Expanded _buttons(BuildContext context, VoidCallback funkcijaRefresh) {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FilledButton(
                  onPressed: () async {
                    try {
                      if (_formKeyArtikal.currentState?.saveAndValidate() ==
                              true &&
                          _formKey.currentState?.saveAndValidate() == true) {
                        _formKey.currentState?.saveAndValidate();
                        print(_formKeyArtikal.currentState?.value);

                        var responseArtikal = await _artikliProvider.update(
                            widget.artikal.artikalId!,
                            _formKeyArtikal.currentState?.value);

                        if (_selectedImages.isNotEmpty) {
                          await _submitForm(context);
                        }
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Uspjeh"),
                                  content: Text("Promjene sacuvane"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Ok"),
                                    )
                                  ],
                                ));
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
              ElevatedButton(
                onPressed: () async {
                  var podaci = await _artikliProvider.get();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MasterScreen(
                        prikaz: ArtilkliScreen(
                          podaci: podaci,
                        ),
                      ),
                    ),
                  );
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
                            initialValue:
                                widget.artikal.cijena?.toStringAsFixed(2),
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
                        initialValue: widget.artikal.kategorijaId.toString(),
                        items: kategorijeResult?.data
                                .map((item) => DropdownMenuItem(
                                      alignment: AlignmentDirectional.center,
                                      value: item.kategorijaId.toString(),
                                      child: Text(item.naziv ?? ""),
                                    ))
                                .toList() ??
                            [],
                      ),
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
                          items: _selectedImages.isEmpty
                              ? (_loadedImages.map((image) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        decoration: BoxDecoration(),
                                        child: Image.network(
                                          image.putanja!,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      );
                                    },
                                  );
                                }).toList())
                              : (_selectedImages.map((image) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        decoration: BoxDecoration(),
                                        child: Image.file(
                                          image,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      );
                                    },
                                  );
                                }).toList()),
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

      await provider.uploadImages(widget.artikal.artikalId!, _selectedImages);

      _formKey.currentState!.reset();
    }
  }
}
