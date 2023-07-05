import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile/models/korisnicki_nalog.dart';
import 'package:flutter_mobile/models/kupac.dart';
import 'package:flutter_mobile/models/lokacija.dart';
import 'package:flutter_mobile/models/osoba.dart';
import 'package:flutter_mobile/models/registracija_model.dart';
import 'package:flutter_mobile/providers/kupac_provider.dart';
import 'package:flutter_mobile/providers/login_register.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../providers/lokacija.dart';
import '../providers/osoba_provider.dart';

class RegistracijaScreen extends StatefulWidget {
  const RegistracijaScreen({super.key});

  @override
  State<RegistracijaScreen> createState() => _RegistracijaScreenState();
}

class _RegistracijaScreenState extends State<RegistracijaScreen> {
  File? _imageFile;
  Osoba osoba = Osoba();
  RegisterModel registerModel = RegisterModel();
  Kupac kupac = Kupac();
  Lokacija lokacija = Lokacija();
  int osobaIdhelper = 0;
  int korisnickiNalogIdhelper = 0;
  int kupacIdhelper = 0;
  int lokacijaIdhelper = 0;
  ValueNotifier<int> buttonProgressNotifier = ValueNotifier<int>(0);
  final _formKeyOsoba = GlobalKey<FormBuilderState>();
  final _formKeyKupac = GlobalKey<FormBuilderState>();
  final _formKeyKorisnickiNalog = GlobalKey<FormBuilderState>();
  final _formKeyLokacija = GlobalKey<FormBuilderState>();
  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController dateController = TextEditingController();

  late OsobaProvider _osobaProvider;
  late LoginRegisterProvider _loginRegisterProvider;
  late KupacProvider _kupacProvider;
  late LokacijaProvider _lokacijaProvider;

  Map<String, dynamic> _initialValueOsoba = {};
  Map<String, dynamic> _initialValueKorisnickiNalog = {};
  Map<String, dynamic> _initialValueLokacija = {};
  Map<String, dynamic> _initialValueKupac = {};

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
      'ulogaId': 2,
    };

    _initialValueLokacija = {
      'drzava': lokacija.drzava,
      'grad': lokacija.grad,
      'ulica': lokacija.ulica,
    };

    _initialValueKupac = {
      'brojNarudzbi': 0,
      'kuca': kupac.kuca,
      'dvoriste': kupac.dvoriste,
      'stan': kupac.stan,
      'osobaId': 0,
      'lokacijaId': 1,
      'slikaKupca': 'http://localhost:7152/SlikeKupaca/Logo.jpg',
      'korisnickiNalogId': 0,
    };

    _osobaProvider = context.read<OsobaProvider>();
    _loginRegisterProvider = context.read<LoginRegisterProvider>();
    _kupacProvider = context.read<KupacProvider>();
    _lokacijaProvider = context.read<LokacijaProvider>();
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
        appBar: AppBar(
            title: Text("Registracija"),
            leading: buttonProgressNotifier.value == 0 ||
                    buttonProgressNotifier.value == 4
                ? IconButton(
                    onPressed: () {
                      Navigator.of(context).pop;
                    },
                    icon: Icon(Icons.arrow_back),
                  )
                : null),
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
                child: Text("1.Dodaj osobu")),
          ),
          SizedBox(
            height: 20,
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
                          width: 280,
                          child: Expanded(
                            child: FormBuilderTextField(
                              name: 'username',
                              decoration:
                                  InputDecoration(labelText: "Korisnicko ime"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Korisnicko ime je obavezno';
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
                              name: 'password',
                              decoration: InputDecoration(labelText: "Sifra"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Sifra je obavezna';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 0,
                          width: 0,
                          child: FormBuilderTextField(
                            name: 'ulogaId',
                            initialValue: '2',
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
          Container(
            width: 325,
            child: FilledButton(
                onPressed: buttonProgressNotifier.value == 1
                    ? () async {
                        _formKeyKorisnickiNalog.currentState?.saveAndValidate();
                        print(_formKeyKorisnickiNalog.currentState?.value);

                        try {
                          var formData = Map<String, dynamic>.from(
                              _formKeyKorisnickiNalog.currentState!.value);

                          formData['ulogaId'] = 2;

                          var response = await _loginRegisterProvider
                              .register(RegisterModel.fromJson(formData));

                          korisnickiNalogIdhelper = response.korisnickiNalogId!;
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
                child: Text("2.Dodaj korisnicki nalog")),
          ),
          SizedBox(
            height: 20,
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
                              decoration: InputDecoration(labelText: "Drzava"),
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
          Container(
            width: 325,
            child: FilledButton(
                onPressed: buttonProgressNotifier.value == 2
                    ? () async {
                        _formKeyLokacija.currentState?.saveAndValidate();
                        print(_formKeyLokacija.currentState?.value);

                        try {
                          var formData = Map<String, dynamic>.from(
                              _formKeyLokacija.currentState!.value);

                          var response = await _lokacijaProvider.add(
                              Lokacija.fromJson(
                                  _formKeyLokacija.currentState!.value));
                          lokacijaIdhelper = response.lokacijaId!;
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
                child: Text("3.Dodaj lokaciju")),
          ),
          SizedBox(
            height: 20,
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
                        Container(
                          height: 0,
                          width: 0,
                          child: FormBuilderTextField(
                            name: 'brojNarudzbi',
                            initialValue: '0',
                            enabled: false,
                          ),
                        ),
                        Container(
                          width: 280,
                          child: Expanded(
                            child: FormBuilderCheckbox(
                              initialValue: false,
                              title: Text("Zivim u kuci"),
                              name: 'kuca',
                            ),
                          ),
                        ),
                        Container(
                          width: 280,
                          child: Expanded(
                            child: FormBuilderCheckbox(
                              initialValue: false,
                              title: Text("Imam dvoriste"),
                              name: 'dvoriste',
                            ),
                          ),
                        ),
                        Container(
                          width: 280,
                          child: Expanded(
                            child: FormBuilderCheckbox(
                              initialValue: false,
                              title: Text("Zivim u stanu"),
                              name: 'stan',
                            ),
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
                            name: 'lokacijaId',
                            initialValue: '1',
                            enabled: false,
                          ),
                        ),
                        Container(
                          height: 0,
                          width: 0,
                          child: FormBuilderTextField(
                            name: 'slikaKupca',
                            initialValue:
                                'http://localhost:7152/SlikeKupaca/Logo.jpg',
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
                onPressed: buttonProgressNotifier.value == 3
                    ? () async {
                        _formKeyKupac.currentState?.saveAndValidate();
                        print(_formKeyKupac.currentState?.value);

                        try {
                          var formData = Map<String, dynamic>.from(
                              _formKeyKupac.currentState!.value);

                          formData['brojNarudzbi'] = 0;
                          formData['lokacijaId'] = lokacijaIdhelper;
                          formData['osobaId'] = osobaIdhelper;
                          formData['korisnickiNalogId'] =
                              korisnickiNalogIdhelper;
                          print("moje${formData}");

                          var response = await _kupacProvider
                              .add(Kupac.fromJson(formData));
                          kupacIdhelper = response.kupacId!;
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
                child: Text("4.Dodaj kupca")),
          ),
          SizedBox(
            height: 20,
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
                      if (_imageFile != null)
                        Image.file(
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
            child: ElevatedButton(
              onPressed: buttonProgressNotifier.value == 4 && _imageFile != null
                  ? () async {
                      if (_formKey.currentState!.saveAndValidate()) {
                        // Access the selected image file using _imageFile
                        // and pass it to the upload function
                        _kupacProvider.addSlikaKupca(
                            kupacIdhelper, _imageFile!);
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
              child: Text('5.Postavi sliku'),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 325,
            child: ElevatedButton(
              onPressed: buttonProgressNotifier.value == 0 ||
                      buttonProgressNotifier.value == 5
                  ? () async {
                      Navigator.of(context).pop();
                      setState(() {
                        buttonProgressNotifier.value = 0;
                      });
                    }
                  : null,
              child: Text("Nazad"),
            ),
          ),
        ],
      )
    ]);
  }
}
