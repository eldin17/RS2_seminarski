import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/kupac_provider.dart';

class RegistracijaSlikaScreen extends StatefulWidget {
  int kupacIdHelper;
  RegistracijaSlikaScreen({super.key, required this.kupacIdHelper});

  @override
  State<RegistracijaSlikaScreen> createState() =>
      _RegistracijaSlikaScreenState();
}

class _RegistracijaSlikaScreenState extends State<RegistracijaSlikaScreen> {
  File? _imageFile;
  ValueNotifier<int> buttonProgressNotifier = ValueNotifier<int>(0);
  final _formKey = GlobalKey<FormBuilderState>();
  late KupacProvider _kupacProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _kupacProvider = context.read<KupacProvider>();
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
            child: FilledButton(
              onPressed: buttonProgressNotifier.value == 0 && _imageFile != null
                  ? () async {
                      if (_formKey.currentState!.saveAndValidate()) {
                        // Access the selected image file using _imageFile
                        // and pass it to the upload function
                        _kupacProvider.addSlikaKupca(
                            widget.kupacIdHelper, _imageFile!);
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
              child: Text('Završi'),
            ),
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
              child: Text("Nazad"),
            ),
          ),
        ],
      )
    ]);
  }
}
