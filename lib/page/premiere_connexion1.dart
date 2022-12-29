import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'acceuil.dart';

class premiere_connexion extends StatefulWidget {

  @override
  State<premiere_connexion> createState() => _premiere_connexionState();
}

class _premiere_connexionState extends State<premiere_connexion> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 290,top: 20),
                child: FlatButton(
                    onPressed:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Acceuil()));

                    },
                    child: Text('passer'),
                ),
              ),
              SizedBox(height: 80,),
              Text(
                'Bienvenue dans votre espace de travail',
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 60,),
              Image.asset('assets/images/image1.jpg'),
              SizedBox(height: 120,),
              Text(
                'votre espace de travail où vous pouvez gérer tous vos document dans un environement trés sécurisé qui protège vos données',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}