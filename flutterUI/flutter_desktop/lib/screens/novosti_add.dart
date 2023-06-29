import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/login_response.dart';
import 'package:flutter_desktop/models/novost.dart';
import 'package:flutter_desktop/providers/novosti_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class NovostiAdd extends StatefulWidget {
  final VoidCallback onRowUpdated;

  const NovostiAdd({super.key, required this.onRowUpdated});

  @override
  State<NovostiAdd> createState() => _NovostiAddState();
}

class _NovostiAddState extends State<NovostiAdd> {
  Novost novost = Novost();
  final _formKeyNovost = GlobalKey<FormBuilderState>();
  late NovostiProvider _novostiProvider;

  Map<String, dynamic> _initialValueNovost = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValueNovost = {
      'naslov': novost.naslov,
      'sadrzaj': novost.sadrzaj,
      'prodavacId': int.tryParse(LoginResponse.idLogiranogKorisnika.toString()),
    };

    _novostiProvider = context.read<NovostiProvider>();
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
              ],
            ),
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
                    _formKeyNovost.currentState?.saveAndValidate();
                    print(_formKeyNovost.currentState?.value);

                    try {
                      Map<String, dynamic> modifiedValue =
                          Map<String, dynamic>.from(
                              _formKeyNovost.currentState!.value);
                      modifiedValue['prodavacId'] =
                          LoginResponse.idLogiranogKorisnika;
                      print("moje${modifiedValue}");

                      var responseArtikal =
                          await _novostiProvider.add(modifiedValue);
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
                  child: Text("Dodaj novost")),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();

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
      key: _formKeyNovost,
      initialValue: _initialValueNovost,
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
                            name: 'naslov',
                            decoration: InputDecoration(labelText: "Naslov"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Naslov je obavezan';
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
                            name: 'sadrzaj',
                            maxLines: 5,
                            decoration: InputDecoration(labelText: "Sadrzaj"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Sadrzaj je obavezan';
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
                      name: 'prodavacId',
                      initialValue: '0',
                      enabled: false,
                    ),
                  ),
                  SizedBox(
                    height: 5,
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
