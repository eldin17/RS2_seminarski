import 'package:flutter/material.dart';
import 'package:flutter_mobile/screens/artikli_detalji.dart';
import 'package:provider/provider.dart';

import '../models/artikal.dart';
import '../models/kategorija.dart';
import '../providers/artikli_provider.dart';
import '../providers/kategorije_provider.dart';
import '../util/util.dart';
import '../widgets/master_screen.dart';

class ArtikliScreen extends StatefulWidget {
  const ArtikliScreen({super.key});

  @override
  State<ArtikliScreen> createState() => _ArtikliScreenState();
}

class _ArtikliScreenState extends State<ArtikliScreen> {
  List<Artikal> artikli = [];
  List<Kategorija> kategorije = [];
  late KategorijeProvider _kategorijeProvider;

  late ArtikliProvider _artikliProvider;
  bool isLoading = true;
  bool isFilterVisible = false;

  TextEditingController _nazivController = new TextEditingController();
  TextEditingController _cijenaDoController = new TextEditingController();
  TextEditingController _cijenaOdController = new TextEditingController();
  String? _odabranaKategorijaId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _kategorijeProvider = context.read<KategorijeProvider>();

    _artikliProvider = context.read<ArtikliProvider>();
    initForm();
  }

  Future initForm() async {
    var kategorije2 = await _kategorijeProvider.get();
    var artikli2 = await _artikliProvider.get();
    var kategorijaSve = new Kategorija();
    kategorijaSve.naziv = "Sve";
    kategorijaSve.kategorijaId = 0;
    setState(() {
      kategorije = kategorije2.data;
      kategorije.add(kategorijaSve);
      artikli = artikli2.data;
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _artikliProvider = context.read<ArtikliProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isFilterVisible = !isFilterVisible;
                      });
                    },
                    child: Row(
                      children: [Icon(Icons.search), Text("Filteri")],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isFilterVisible,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                child: fliteri(),
              ),
            ),
            isLoading
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height -
                                200, // Adjust the height here
                            width: 280,
                            child: GridView(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              scrollDirection: Axis.vertical,
                              children: _artikliList(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Container fliteri() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(colors: [
          Color.fromRGBO(231, 231, 252, 0.6),
          Color.fromRGBO(216, 247, 255, 1),
        ]),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.abc),
                      labelText: "Naziv",
                      hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 207, 207, 207)),
                    ),
                    controller: _nazivController,
                  ),
                ),
              ],
            ),
            Container(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Kategorija",
                  prefixIcon: Icon(Icons.category),
                ),
                value: _odabranaKategorijaId,
                onChanged: (String? newValue) {
                  setState(() {
                    _odabranaKategorijaId = newValue;
                  });
                },
                items: kategorije.map((Kategorija kategorija) {
                  return DropdownMenuItem<String>(
                    value: kategorija.kategorijaId.toString(),
                    child: Text(kategorija.naziv!),
                  );
                }).toList(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Cijena od",
                      prefixIcon: Icon(Icons.monetization_on),
                    ),
                    controller: _cijenaOdController,
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Cijena do",
                      prefixIcon: Icon(Icons.monetization_on),
                    ),
                    controller: _cijenaDoController,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 350,
              height: 30,
              child: ElevatedButton(
                  onPressed: () async {
                    var cijenaDo;
                    var cijenaOd;
                    try {
                      cijenaDo = double.parse(_cijenaDoController.text);
                    } catch (e) {
                      cijenaDo = 0;
                    }
                    try {
                      cijenaOd = double.parse(_cijenaOdController.text);
                    } catch (e) {
                      cijenaOd = 0;
                    }
                    if (cijenaDo > 0 && cijenaOd > 0 && (cijenaDo < cijenaOd)) {
                      setState(() {
                        var temp = _cijenaDoController.text;
                        _cijenaDoController.text = _cijenaOdController.text;
                        _cijenaOdController.text = temp;
                      });
                      var temp = cijenaDo;
                      cijenaDo = cijenaOd;
                      cijenaOd = temp;
                    }
                    var data = await _artikliProvider.get(filter: {
                      'naziv': _nazivController.text,
                      'cijenaDo': cijenaDo,
                      'cijenaOd': cijenaOd,
                      'kategorijaId': int.tryParse(_odabranaKategorijaId ?? "")
                    });
                    setState(() {
                      artikli = data.data;
                      isFilterVisible = false;
                    });
                  },
                  child: Text("Pretraži")),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () async {
                var data = await _artikliProvider.get();

                setState(() {
                  _nazivController.value = TextEditingValue.empty;
                  _odabranaKategorijaId = '0';
                  _cijenaDoController.value = TextEditingValue.empty;
                  _cijenaOdController.value = TextEditingValue.empty;
                  artikli = data.data;
                  isFilterVisible = false;
                });
              },
              child: Row(
                children: [
                  Icon(Icons.cancel_outlined),
                  Text(" Obriši filtere")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _artikliList(BuildContext context) {
    List<Widget> list = artikli
        .map((x) => Container(
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(231, 252, 232, 0.6),
                  Color.fromRGBO(225, 255, 216, 1),
                ]),
              ),
              child: Container(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: Duration.zero,
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    MasterScreen(
                              uslov: true,
                              child: ArtikliDetalji(
                                artikal: x,
                              ),
                              index: 2,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 180,
                        width: 280,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10), // Set the border radius here
                          child: Image.network(
                            obradiSliku(x.slike![0].putanja!),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(x.naziv ?? ""),
                    Text(
                      "${formatNumber(x.cijena)} KM",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }
}
