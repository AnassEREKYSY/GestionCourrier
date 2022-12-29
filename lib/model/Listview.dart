import 'package:flutter/cupertino.dart';

class Listview{
  late String objet;
  late String destinataire;
  late String expiditeur;
  late String date;
  late Icon imageetat;
  late Icon urgent;

  Listview(String objet, String destinataire, String expiditeur,String date, Icon imageetat,Icon urgent) {
    this.objet = objet;
    this.destinataire = destinataire;
    this.expiditeur = expiditeur;
    this.date = date;
    this.imageetat = imageetat;
    this.urgent=urgent;
  }
}