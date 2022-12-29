import 'package:collapsible_navigation_drawer_example/page/acceuil.dart';
import 'package:collapsible_navigation_drawer_example/page/ajouter.dart';
import 'package:collapsible_navigation_drawer_example/page/courrier_details.dart';
import 'package:collapsible_navigation_drawer_example/page/inscription.dart';
import 'package:collapsible_navigation_drawer_example/page/loginScreen.dart';
import 'package:collapsible_navigation_drawer_example/page/mdp_oubli%C3%A9.dart';
import 'package:collapsible_navigation_drawer_example/page/modifier.dart';
import 'package:collapsible_navigation_drawer_example/page/supprimer.dart';
import 'package:collapsible_navigation_drawer_example/page/supprimer_compte.dart';
import 'package:collapsible_navigation_drawer_example/provider/navigation_provider.dart';
import 'package:collapsible_navigation_drawer_example/widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'model/Listview.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'model/slidable_action.dart';

Future main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Courrier';
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => NavigationProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(primarySwatch: Colors.deepOrange),
          routes: {
            '/home':(context)=> Acceuil(),
            '/archive':(context)=> Acceuil(),
            '/details':(context)=> Details(),
            '/ajouter':(context)=>Ajouter(),
            '/modifier':(context)=>modifier(),
            '/supprimer':(context)=>supprimer(),
            '/inscription':(context)=>inscription(),
            '/login':(context)=>LoginScreen(),
            '/supprimer_compte':(context)=>supprimer_compte(),
            '/mdp':(context)=>MDP(),
            // '/archives':(context)=>LoginScreen(),
          },
          home: LoginScreen(),
        ),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}