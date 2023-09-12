import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/novost.dart';
import 'package:flutter_mobile/providers/novosti_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/master_screen.dart';
import 'novosti_detalji.dart';

class NovostiScreen extends StatefulWidget {
  const NovostiScreen({super.key});

  @override
  State<NovostiScreen> createState() => _NovostiScreenState();
}

class _NovostiScreenState extends State<NovostiScreen> {
  List<Novost> novosti = [];
  late NovostiProvider _novostiProvider;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _novostiProvider = context.read<NovostiProvider>();
    initForm();
  }

  Future initForm() async {
    var novosti2 = await _novostiProvider.get();
    setState(() {
      novosti = novosti2.data;
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _novostiProvider = context.read<NovostiProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Scaffold(
          body: SingleChildScrollView(
            child: isLoading
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 620, // Adjust the height here
                            width: 400,

                            child: GridView(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 2.8,
                                crossAxisCount: 1,
                                crossAxisSpacing: 50,
                                mainAxisSpacing: 50,
                              ),
                              scrollDirection: Axis.vertical,
                              children: _novostiList(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  List<Widget> _novostiList(BuildContext context) {
    List<Widget> list = novosti
        .map((x) => Container(
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(216, 217, 255, 1),
                  Color.fromRGBO(244, 252, 231, 0.6)
                ]),
              ),
              child: Container(
                height: 60,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration: Duration.zero,
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      MasterScreen(
                                uslov: true,
                                child: NovostiDetalji(
                                  novost: x,
                                ),
                                index: 4,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          height: 95,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${x.naslov}",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${DateFormat('dd.MM.yyyy').format(DateTime.parse(x.datumPostavljanja!))}",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                x.sadrzaj ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                        ),
                      ),
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
