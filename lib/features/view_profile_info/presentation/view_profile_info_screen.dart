import 'package:flutter/material.dart';

import '../../../helper/ui_helpers.dart';

class ViewProfileInfoScreen extends StatefulWidget {
  const ViewProfileInfoScreen({super.key});

  @override
  State<ViewProfileInfoScreen> createState() => _ViewProfileInfoScreenState();
}

class _ViewProfileInfoScreenState extends State<ViewProfileInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
            child: Center(child: Text("View Profile Info Screen")),
          ),
        ),
      ),
    );
  }
}
