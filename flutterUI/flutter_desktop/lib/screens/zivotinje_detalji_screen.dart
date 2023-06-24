import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/zivotinja.dart';

import '../util/util.dart';

class ZivotinjeDetalji extends StatefulWidget {
  Zivotinja item;
  ZivotinjeDetalji({required this.item, super.key});

  @override
  State<ZivotinjeDetalji> createState() => _ZivotinjeDetaljiState();
}

class _ZivotinjeDetaljiState extends State<ZivotinjeDetalji> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _topPartSlike(context, widget.item),
        _bottomPartData(context, widget.item),
      ],
    );
  }
}

Row _topPartSlike(BuildContext context, Zivotinja item) {
  return Row(
    children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            width: 400,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 250, // Adjust the height as needed
                // Customize other options as per your requirement
              ),
              items: item.slike?.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(),
                      child: Image.network(
                        image.putanja!,
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
      Column(
        children: [
          Container(
            width: 400,
            height: 148,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(children: [
                  Row(
                    children: [
                      Text(
                        "Vrsta",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" - ${item.vrsta?.naziv}"),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Rasa",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" - ${item.vrsta?.rasa}"),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Starost",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" - ${item.vrsta?.starost} godina"),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Boja",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" - ${item.vrsta?.boja}"),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Prostor",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" - ${getProstor(item.vrsta?.prostor)}"),
                    ],
                  ),
                ]),
              ),
            ),
          ),
          Container(
            width: 400,
            height: 148,
            child: Card(
              child: Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Container(
                          width: 300,
                          child: Text(
                            "${item.vrsta?.opis}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ],
  );
}

Row _bottomPartData(BuildContext context, Zivotinja item) {
  return Row(
    children: [
      Container(
        width: 445,
        height: 148,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(children: [
              Row(
                children: [
                  Text(
                    "Cijena",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(" - ${formatNumber(item.cijena)} KM"),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Naziv",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(" - ${item.naziv}"),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Napomena",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(" - ${item.napomena}"),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Dostupnost",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(" - ${getDostupnost(item.dostupnost)}"),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Status",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " - ${item.stateMachine}",
                    style: TextStyle(color: getTextColor(item.stateMachine)),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
      Container(
        width: 400,
        height: 148,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(children: [
              FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Nazad")),
            ]),
          ),
        ),
      ),
    ],
  );
}

String getProstor(bool? prostor) {
  if (prostor != null && prostor) {
    return "Potreban je veci prostor za ovu zivotinju";
  }
  return "Dovoljan je manji prostor za ovu zivotinju";
}

String getDostupnost(bool? dostupnost) {
  if (dostupnost != null && dostupnost) {
    return "Dostupna";
  }
  return "Nije dostupna";
}
