import 'package:ai_man_app/utils/Color.dart';
import 'package:ai_man_app/utils/Family.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Menu Screen',
            style: TextStyle(
                fontSize: 17,
                fontFamily: Family.InterExtraBold,
                color: ColorRes.appTheme),
          )),

    );
  }
}
