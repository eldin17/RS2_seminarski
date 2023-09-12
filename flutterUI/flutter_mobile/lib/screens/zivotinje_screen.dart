import 'package:flutter/material.dart';
import 'package:flutter_mobile/screens/zivotinje_detalji.dart';
import 'package:provider/provider.dart';

import '../models/zivotinja.dart';
import '../providers/zivotinje_provider.dart';
import '../util/util.dart';
import '../widgets/master_screen.dart';

class ZivotinjeScreen extends StatefulWidget {
  const ZivotinjeScreen({super.key});

  @override
  State<ZivotinjeScreen> createState() => _ZivotinjeScreenState();
}

class _ZivotinjeScreenState extends State<ZivotinjeScreen> {
  List<Zivotinja> zivotinje = [];
  late ZivotinjeProvider _zivotinjeProvider;
  bool isLoading = true;
  bool isFilterVisible = false;
  TextEditingController _rasaController = new TextEditingController();
  TextEditingController _rasa2Controller = new TextEditingController();
  TextEditingController _cijenaDoController = new TextEditingController();
  TextEditingController _cijenaOdController = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _zivotinjeProvider = context.read<ZivotinjeProvider>();
    initForm();
  }

  Future initForm() async {
    var zivotinje2 = await _zivotinjeProvider.get();
    setState(() {
      zivotinje = zivotinje2.data;
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _zivotinjeProvider = context.read<ZivotinjeProvider>();
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
                              children: _zivotinjeList(context),
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
                      prefixIcon: Icon(Icons.pets),
                      labelText: "Vrsta (pas, macka...)",
                      hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 207, 207, 207)),
                    ),
                    controller: _rasaController,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.pets),
                      labelText: "Rasa (labrador, papagaj...)",
                      hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 207, 207, 207)),
                    ),
                    controller: _rasa2Controller,
                  ),
                ),
              ],
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
                    var data = await _zivotinjeProvider.get(filter: {
                      'rasa': _rasaController.text,
                      'vrsta': _rasa2Controller.text,
                      'cijenaDo': cijenaDo,
                      'cijenaOd': cijenaOd,
                    });
                    setState(() {
                      zivotinje = data.data;
                      isFilterVisible = false;
                    });
                  },
                  child: Text("Pretrazi")),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () async {
                var data = await _zivotinjeProvider.get();

                setState(() {
                  _rasa2Controller.value = TextEditingValue.empty;
                  _rasaController.value = TextEditingValue.empty;
                  _cijenaDoController.value = TextEditingValue.empty;
                  _cijenaOdController.value = TextEditingValue.empty;
                  zivotinje = data.data;
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

  List<Widget> _zivotinjeList(BuildContext context) {
    List<Widget> list = zivotinje
        .map((x) => Container(
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(216, 247, 255, 1),
                  Color.fromRGBO(231, 231, 252, 0.6)
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
                              child: ZivotinjeDetalji(
                                zivotinja: x,
                              ),
                              index: 1,
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
