import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/novost.dart';
import 'package:intl/intl.dart';

class NovostiDetalji extends StatefulWidget {
  Novost novost = Novost();
  NovostiDetalji({super.key, required this.novost});

  @override
  State<NovostiDetalji> createState() => _NovostiDetaljiState();
}

class _NovostiDetaljiState extends State<NovostiDetalji> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: podaci(widget.novost),
          ),
        ),
      ),
    );
  }
}

Column podaci(Novost novost) {
  return Column(
    children: [
      SizedBox(
        height: 30,
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(216, 217, 255, 1),
            Color.fromRGBO(244, 252, 231, 0.6),
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Text(
                    "${novost.naslov}",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(244, 252, 231, 0.6),
            Color.fromRGBO(216, 217, 255, 1),
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 300,
                  child: Text(
                    "${novost.sadrzaj}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 15,
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "${DateFormat('dd.MM.yyyy').format(DateTime.parse(novost.datumPostavljanja!))}",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
