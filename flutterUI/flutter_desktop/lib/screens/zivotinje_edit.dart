import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/slika.dart';
import 'package:flutter_desktop/screens/zivotinje_screen.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../models/rasa.dart';
import '../models/search_result.dart';
import '../models/vrsta.dart';
import '../models/zivotinja.dart';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_desktop/providers/vrste_provider.dart';
import 'package:flutter_desktop/providers/zivotinje_provider.dart';
import 'package:provider/provider.dart';

import '../providers/rase_provider.dart';
import '../util/util.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/master_screen.dart';

class ZivotinjeEdit extends StatefulWidget {
  final VoidCallback onRowUpdated;
  Zivotinja zivotinja = Zivotinja();
  Vrsta vrsta = Vrsta();

  ZivotinjeEdit(
      {super.key,
      required this.onRowUpdated,
      required this.zivotinja,
      required this.vrsta});

  @override
  State<ZivotinjeEdit> createState() => _ZivotinjeEditState();
}

class _ZivotinjeEditState extends State<ZivotinjeEdit> {
  final _formKeyVrsta = GlobalKey<FormBuilderState>();
  final _formKeyZivotinja = GlobalKey<FormBuilderState>();
  final _formKey = GlobalKey<FormBuilderState>();
  List<File> _selectedImages = [];
  List<Slika> _loadedImages = [];

  late ZivotinjeProvider _zivotinjeProvider;
  late VrsteProvider _vrstaProvider;
  late RaseProvider _raseProvider;

  Map<String, dynamic> _initialValueVrsta = {};
  Map<String, dynamic> _initialValueZivotinja = {};

  SearchResult<Rasa>? raseData;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValueVrsta = {
      'naziv': widget.vrsta.naziv,
      'rasa': widget.vrsta.rasa,
      'rasaId': widget.vrsta.rasaId,
      'opis': widget.vrsta.opis,
      'boja': widget.vrsta.boja,
      'starost': int.tryParse(widget.vrsta.starost.toString()),
      'prostor': widget.vrsta.prostor,
    };
    //'starost': widget.vrsta.starost,

    _initialValueZivotinja = {
      'naziv': widget.zivotinja.naziv,
      'napomena': widget.zivotinja.napomena,
      'cijena': widget.zivotinja.cijena,
      'vrstaId': widget.zivotinja.vrstaId,
    };

    _zivotinjeProvider = context.read<ZivotinjeProvider>();
    _vrstaProvider = context.read<VrsteProvider>();
    _raseProvider = context.read<RaseProvider>();

    _loadedImages = widget.zivotinja.slike!;
    initForm();
  }

  Future initForm() async {
    raseData = await _raseProvider.get();
    print(raseData);
    setState(() {
      isLoading = false;
    });
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
                      if (_formKeyVrsta.currentState?.saveAndValidate() ==
                              true &&
                          _formKeyZivotinja.currentState?.saveAndValidate() ==
                              true &&
                          _formKey.currentState?.saveAndValidate() == true) {
                        print(_formKeyVrsta.currentState?.value);
                        print(_formKeyZivotinja.currentState?.value);

                        await _vrstaProvider.update(widget.vrsta.vrstaId!,
                            Vrsta.fromJson(_formKeyVrsta.currentState!.value));

                        Map<String, dynamic> modifiedValue =
                            Map<String, dynamic>.from(
                                _formKeyZivotinja.currentState!.value);
                        modifiedValue['vrstaId'] = widget.vrsta.vrstaId;
                        print("moje${modifiedValue}");

                        await _zivotinjeProvider.update(
                            widget.zivotinja.zivotinjaId!, modifiedValue);

                        if (_selectedImages.isNotEmpty) {
                          await _submitForm(context);
                        }

                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Uspjeh"),
                                  content: Text("Promjene spasene"),
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
                  var podaci = await _zivotinjeProvider.get();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MasterScreen(
                        prikaz: ZivotinjeScreen(
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
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                          child: FormBuilderDropdown<int>(
                            name: 'rasaId',
                            decoration: InputDecoration(
                              labelText: 'Vrsta',
                              suffix: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _formKeyVrsta.currentState!.fields['rasaId']
                                      ?.reset();
                                },
                              ),
                              hintText: 'Vrsta',
                            ),
                            items: raseData?.data
                                    .map((item) => DropdownMenuItem(
                                          alignment:
                                              AlignmentDirectional.center,
                                          value: item.rasaId,
                                          child: Text(item.naziv ?? ""),
                                        ))
                                    .toList() ??
                                [],
                            validator: (value) {
                              if (value == null || value == 0) {
                                return 'Vrsta je obavezna';
                              }
                              return null;
                            },
                          ),
                        ),
                        // Expanded(
                        //   child: FormBuilderTextField(
                        //     name: 'rasa',
                        //     decoration: InputDecoration(labelText: "Rasa"),
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return 'Rasa je obavezna';
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        // ),
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
                            initialValue: widget.vrsta.starost
                                .toString(), // Convert int to String
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
                            initialValue: widget.zivotinja.vrsta?.prostor,
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
                            initialValue:
                                widget.zivotinja.cijena?.toStringAsFixed(2),
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
                            height: 250,
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
      final provider = Provider.of<ZivotinjeProvider>(context, listen: false);

      await provider.uploadImages(
          widget.zivotinja.zivotinjaId!, _selectedImages);

      _formKey.currentState!.reset();
    }
  }
}
