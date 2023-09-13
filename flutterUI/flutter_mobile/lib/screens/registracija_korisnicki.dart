import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobile/screens/registracija_lokacija.dart';
import 'package:provider/provider.dart';

import '../models/registracija_model.dart';
import '../providers/login_register.dart';

class RegistracijaKorisnickiScreen extends StatefulWidget {
  int osobaIdhelper;

  RegistracijaKorisnickiScreen({super.key, required this.osobaIdhelper});

  @override
  State<RegistracijaKorisnickiScreen> createState() =>
      _RegistracijaKorisnickiScreenState();
}

class _RegistracijaKorisnickiScreenState
    extends State<RegistracijaKorisnickiScreen> {
  RegisterModel registerModel = RegisterModel();
  int korisnickiNalogIdhelper = 0;
  ValueNotifier<int> buttonProgressNotifier = ValueNotifier<int>(0);
  final _formKeyKorisnickiNalog = GlobalKey<FormBuilderState>();
  late LoginRegisterProvider _loginRegisterProvider;
  Map<String, dynamic> _initialValueKorisnickiNalog = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValueKorisnickiNalog = {
      'username': registerModel.username,
      'password': registerModel.password,
      'ulogaId': 2,
    };

    _loginRegisterProvider = context.read<LoginRegisterProvider>();
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
                              obscureText: true,
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
                onPressed: buttonProgressNotifier.value == 0
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
                            builder: (context) => RegistracijaLokacijaScreen(
                              korisnickiNalogIdhelper: korisnickiNalogIdhelper,
                              osobaIdhelper: widget.osobaIdhelper,
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
