import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobile/screens/registracija_slika.dart';
import 'package:provider/provider.dart';

import '../models/kupac.dart';
import '../providers/kupac_provider.dart';

class RegistracijaKupacScreen extends StatefulWidget {
  int osobaIdhelper;
  int korisnickiNalogIdhelper;
  int lokacijaIdhelper;

  RegistracijaKupacScreen(
      {super.key,
      required this.korisnickiNalogIdhelper,
      required this.osobaIdhelper,
      required this.lokacijaIdhelper});

  @override
  State<RegistracijaKupacScreen> createState() =>
      _RegistracijaKupacScreenState();
}

class _RegistracijaKupacScreenState extends State<RegistracijaKupacScreen> {
  Kupac kupac = Kupac();
  int kupacIdhelper = 0;
  ValueNotifier<int> buttonProgressNotifier = ValueNotifier<int>(0);
  final _formKeyKupac = GlobalKey<FormBuilderState>();
  late KupacProvider _kupacProvider;
  Map<String, dynamic> _initialValueKupac = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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

    _kupacProvider = context.read<KupacProvider>();
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
                onPressed: buttonProgressNotifier.value == 0
                    ? () async {
                        _formKeyKupac.currentState?.saveAndValidate();
                        print(_formKeyKupac.currentState?.value);

                        try {
                          var formData = Map<String, dynamic>.from(
                              _formKeyKupac.currentState!.value);

                          formData['brojNarudzbi'] = 0;
                          formData['lokacijaId'] = widget.lokacijaIdhelper;
                          formData['osobaId'] = widget.osobaIdhelper;
                          formData['korisnickiNalogId'] =
                              widget.korisnickiNalogIdhelper;
                          print("moje${formData}");

                          var response = await _kupacProvider
                              .add(Kupac.fromJson(formData));
                          kupacIdhelper = response.kupacId!;
                          setState(() {
                            buttonProgressNotifier.value++;
                          });
                        } on Exception catch (e) {
                          // TODO
                          // showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) => AlertDialog(
                          //           title: Text("Error"),
                          //           content: Text(e.toString()),
                          //           actions: [
                          //             TextButton(
                          //               onPressed: () => Navigator.pop(context),
                          //               child: Text("Ok"),
                          //             )
                          //           ],
                          //         ));
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
                            builder: (context) => RegistracijaSlikaScreen(
                              kupacIdHelper: kupacIdhelper,
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
