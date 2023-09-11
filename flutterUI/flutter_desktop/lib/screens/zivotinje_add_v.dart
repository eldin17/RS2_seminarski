import 'package:flutter/material.dart';
import 'package:flutter_desktop/screens/zivotinje_add_z.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/rasa.dart';
import '../models/search_result.dart';
import '../models/vrsta.dart';
import '../providers/rase_provider.dart';
import '../providers/vrste_provider.dart';
import '../widgets/master_screen.dart';

class ZivotinjaAddVScreen extends StatefulWidget {
  final VoidCallback onRowUpdated;
  const ZivotinjaAddVScreen({super.key, required this.onRowUpdated});

  @override
  State<ZivotinjaAddVScreen> createState() => _ZivotinjaAddVScreenState();
}

class _ZivotinjaAddVScreenState extends State<ZivotinjaAddVScreen> {
  Vrsta vrsta = Vrsta();
  int vrstaIdhelper = 0;
  ValueNotifier<int> buttonProgressNotifier = ValueNotifier<int>(0);
  final _formKeyVrsta = GlobalKey<FormBuilderState>();
  late VrsteProvider _vrstaProvider;
  late RaseProvider _raseProvider;

  Map<String, dynamic> _initialValueVrsta = {};
  SearchResult<Rasa>? raseData;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValueVrsta = {
      'naziv': vrsta.naziv,
      'rasaId': vrsta.rasaId,
      'opis': vrsta.opis,
      'boja': vrsta.boja,
      'starost': int.tryParse(vrsta.starost.toString()),
      'prostor': vrsta.prostor,
    };
    _vrstaProvider = context.read<VrsteProvider>();
    _raseProvider = context.read<RaseProvider>();

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
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        isLoading ? Container() : _buildForm1(),
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
        width: 550,
        alignment: Alignment.topRight,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: buttonProgressNotifier.value == 1
                    ? () async => {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => MasterScreen(
                                prikaz: ZivotinjaAddZScreen(
                                  onRowUpdated: widget.onRowUpdated,
                                  vrstaIdhelper: vrstaIdhelper,
                                ),
                              ),
                            ),
                          ),
                        }
                    : null,
                child: Text('Dalje'),
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
                              if (value != null &&
                                  (parsedValue > 100 || parsedValue < 1)) {
                                return 'Raspon 1-100';
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
                  Container(
                    width: 500,
                    child: Expanded(
                      child: FormBuilderCheckbox(
                        initialValue: false,
                        title: Text("Potreban veci prostor"),
                        name: 'prostor',
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
                                if (_formKeyVrsta.currentState
                                        ?.saveAndValidate() ==
                                    true) {
                                  print(_formKeyVrsta.currentState?.value);

                                  var response = await _vrstaProvider.add(
                                      Vrsta.fromJson(
                                          _formKeyVrsta.currentState!.value));

                                  vrstaIdhelper = response.vrstaId!;

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
}
