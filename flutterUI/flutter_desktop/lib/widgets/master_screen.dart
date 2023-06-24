import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  Widget? prikaz;
  MasterScreen({this.prikaz, super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 300),
              color: Colors.cyan,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 700),
                  child: widget.prikaz!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
