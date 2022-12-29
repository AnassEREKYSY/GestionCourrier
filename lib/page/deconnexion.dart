import 'package:flutter/material.dart';

import '../widget/navigation_drawer_widget.dart';

class deconnexion extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('Deconnexion'),
          centerTitle: true,
          backgroundColor: Colors.pink,
        ),
      );
}
