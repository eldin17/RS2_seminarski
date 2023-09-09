import 'package:flutter/material.dart';
import 'package:flutter_desktop/screens/registracija_prodavac.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
      'ulogaId': 1,
    };
    _loginRegisterProvider = context.read<LoginRegisterProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FormaUnos(buttonProgressNotifier),
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
              FilledButton(
                onPressed: buttonProgressNotifier.value == 1
                    ? () async {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => RegistracijaProdavacScreen(
                              korisnickiNalogIdhelper: korisnickiNalogIdhelper,
                              osobaIdhelper: widget.osobaIdhelper,
                            ),
                          ),
                        );
                      }
                    : null,
                child: Text('Dalje'),
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
      key: _formKeyKorisnickiNalog,
      initialValue: _initialValueKorisnickiNalog,
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
                        width: 500,
                        child: Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'username',
                                decoration: InputDecoration(
                                    labelText: "Korisnicko ime"),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Korisnicko ime je obavezno';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Expanded(
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
                          ],
                        ),
                      ),
                      Container(
                        height: 0,
                        width: 0,
                        child: FormBuilderTextField(
                          name: 'ulogaId',
                          initialValue: '1',
                          enabled: false,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FilledButton(
                          onPressed: buttonProgressNotifier.value == 0
                              ? () async {
                                  try {
                                    if (_formKeyKorisnickiNalog.currentState
                                            ?.saveAndValidate() ==
                                        true) {
                                      print(_formKeyKorisnickiNalog
                                          .currentState?.value);

                                      var formData = Map<String, dynamic>.from(
                                          _formKeyKorisnickiNalog
                                              .currentState!.value);

                                      formData['ulogaId'] = 1;

                                      var response =
                                          await _loginRegisterProvider.register(
                                              RegisterModel.fromJson(formData));

                                      korisnickiNalogIdhelper =
                                          response.korisnickiNalogId!;
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
}
