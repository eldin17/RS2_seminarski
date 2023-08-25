import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/artikal.dart';
import 'package:flutter_mobile/models/narudzba.dart';
import 'package:flutter_mobile/models/narudzba_artikal.dart';
import 'package:intl/intl.dart';

import '../models/zivotinja.dart';
import '../util/util.dart';

class NarudzbeDetalji extends StatefulWidget {
  Narudzba narudzba = Narudzba();
  NarudzbeDetalji({super.key, required this.narudzba});

  @override
  State<NarudzbeDetalji> createState() => _NarudzbeDetaljiState();
}

class _NarudzbeDetaljiState extends State<NarudzbeDetalji> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${DateFormat('dd.MM.yyyy').format(DateTime.parse(widget.narudzba.datumNarudzbe!))}",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              Text(
                                "${formatNumber(widget.narudzba.totalFinal)} KM",
                                style: TextStyle(
                                    fontSize: 19,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "PaymentId\n${widget.narudzba.paymentId}",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "PaymentIntent\n${widget.narudzba.paymentIntent}",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      widget.narudzba.narudzbeArtikli != null
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: DataTable(
                                columns: [
                                  const DataColumn(
                                    label: const Expanded(
                                      child: Text(
                                        "",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  const DataColumn(
                                    label: const Expanded(
                                      child: const Text(
                                        "",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: widget.narudzba.narudzbeArtikli
                                        ?.map((NarudzbaArtikal e) =>
                                            DataRow(cells: [
                                              DataCell(
                                                Text(e.artikal?.naziv
                                                        ?.toString() ??
                                                    ""),
                                              ),
                                              DataCell(
                                                Text(formatNumber(
                                                            e.artikal?.cijena)
                                                        ?.toString() ??
                                                    ""),
                                              ),
                                            ]))
                                        .toList() ??
                                    [],
                              ),
                            )
                          : Container(),
                      widget.narudzba.zivotinje != null
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: DataTable(
                                columns: [
                                  const DataColumn(
                                    label: const Expanded(
                                      child: const Text(
                                        "",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  const DataColumn(
                                    label: const Expanded(
                                      child: const Text(
                                        "",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: widget.narudzba.zivotinje!
                                        .map((Zivotinja e) => DataRow(cells: [
                                              DataCell(
                                                Text(e.naziv?.toString() ?? ""),
                                              ),
                                              DataCell(
                                                Text(formatNumber(e.cijena)
                                                        ?.toString() ??
                                                    ""),
                                              ),
                                            ]))
                                        .toList() ??
                                    [],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
