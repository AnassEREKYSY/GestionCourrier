import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../provider/navigation_provider.dart';
import '../widget/navigation_drawer_widget.dart';
import '../widget/navigation_drawer_widget.dart';


class details extends StatefulWidget {
  File ? image;
  String? objet;
  String? destinataire;
  String? expiditeur;
  String? date;
  String? tags;
  details(
      {Key? key,
        this.image,
        this.objet,
        this.destinataire,
        this.expiditeur,
        this.date,
        this.tags}): super(key: key);

  @override
  State<details> createState() => _detailsState();
}

class _detailsState extends State<details> {
  @override
  Widget build(BuildContext context) {

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool? checkBoxValue=false;
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text('courrier'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              _buildtype(),
              SizedBox(height: 10,),
              _buildObjet(),
              SizedBox(height: 10,),
              _buildDestinataire(),
              SizedBox(height: 10,),
              _buildExpiditeur(),
              SizedBox(height: 10,),
              _buildDate(),
              SizedBox(height: 10,),
              _buildTags(),
              SizedBox(height: 40,),
              Row(
                children: [
                  SizedBox(width: 230,),
                  Checkbox(
                    value: checkBoxValue,
                    onChanged: (bool? value){
                      print(value);
                      setState(() {
                        checkBoxValue=value;
                      });
                    },
                  ),
                  Text(
                    'Urgent',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),


              SizedBox(height: 10,),


              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.document_scanner_sharp),
                    iconSize: 50,

                    onPressed: (){
                      _getFromCamera();
                    },
                  ),
                  SizedBox(width: 40,),
                  IconButton(
                    icon: const Icon(Icons.image),
                    iconSize: 50,
                    onPressed: (){
                      _getFromGallery();
                    },
                  ),
                ],
              ),
              SizedBox(height: 25,),
              Row(
                children: [
                  RaisedButton(
                      child: Text(
                        'Annuler',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                        ) ,
                      ),
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                      }
                  ),
                  Spacer(),
                  RaisedButton(
                    child: Text(
                      'Ajouter',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                      ) ,
                    ),
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      formKey.currentState!.save();

                      //Send to API
                    },

                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget _buildDestinataire(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Destinataire'),
      validator: (value){
        if(value==null){
          return 'Destionataire est obligatoire';
        }
        return null;
      },
      onSaved: (value){
        widget.destinataire=value!;
      },
    );
  }
  Widget _buildExpiditeur(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Expiditeur'),
      validator: (value){
        if(value==null){
          return 'Expiditeur est obligatoire';
        }
        return null;
      },
      onSaved: (value){
        widget.expiditeur=value!;
      },
    );
  }
  Widget _buildDate(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Date'),
      keyboardType: TextInputType.datetime,
      validator: (value){
        if(value==null){
          return 'La date est obligatoire';
        }
        return null;
      },
      onSaved: (value){
        widget.date=value!;
      },
    );
  }
  Widget _buildTags(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Tags'),
      validator: (value){
        if(value==null){
          return 'Les tags sont obligatoire';
        }
        return null;
      },
      onSaved: (value){
        widget.tags=value!;
      },
    );
  }
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
    }
  }
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
    }
  }
  Widget _buildObjet(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Objet'),
      validator: (value){
        if(value==null){
          return 'Objet est obligatoire';
        }
        return null;
      },
      onSaved: (value){
        widget.objet=value!;
      },
    );
  }

  Widget _buildtype(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Type'),
      validator: (value){
        if(value==null){
          return 'type est obligatoire';
        }
        return null;
      },
      onSaved: (value){
        widget.objet=value!;
      },
    );
  }
}




