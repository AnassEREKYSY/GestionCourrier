
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:collapsible_navigation_drawer_example/SqlDb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../provider/navigation_provider.dart';
import '../widget/navigation_drawer_widget.dart';
import '../widget/navigation_drawer_widget.dart';
import 'acceuil.dart';
import 'loginScreen.dart';


class MDP extends StatefulWidget {
  String? nom,prenom,email,mdp,adresse,tel,cin,photo;
  int? id;
  @override
  State<MDP> createState() => _MDPState();
}

class _MDPState extends State<MDP> {
  SqlDb sqlDb=new SqlDb();
  TextEditingController _cinController = new TextEditingController();
  TextEditingController _nomController = new TextEditingController();
  TextEditingController _prenomController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  String? cin,nom,prenom,email,mdp;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[300],
        title:Row(
          children: [
            IconButton(
                onPressed: ()async{

                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context)=>LoginScreen()),ModalRoute.withName('/login'));

                },
                icon: Icon(Icons.arrow_back, size: 27,)),
            SizedBox(width: 40,),
            Text('Mot de passe oublié',style: TextStyle(fontSize: 25),),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 5, right: 18, left: 18),
          child: Column(
            children: [
              SizedBox(height: 190,),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _cinController,
                      decoration: InputDecoration(
                        hintText: 'Cin',
                        prefixIcon: Icon(
                          Icons.perm_identity_sharp,
                        ),
                        contentPadding: EdgeInsets.all(10),
                        focusedBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.7),
                          borderSide: BorderSide(
                              color: Colors.red,
                              width: 5.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: _nomController,
                      decoration: InputDecoration(
                        hintText: 'Nom',
                        prefixIcon: Icon(
                          Icons.account_circle,
                        ),
                        contentPadding: EdgeInsets.all(10),
                        focusedBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.7),
                          borderSide: BorderSide(
                              color: Colors.red,
                              width: 5.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: _prenomController,
                      decoration: InputDecoration(
                        hintText: 'Prénom',
                        prefixIcon: Icon(
                          Icons.account_circle,
                        ),
                        contentPadding: EdgeInsets.all(10),
                        focusedBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.7),
                          borderSide: BorderSide(
                              color: Colors.red,
                              width: 5.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                        contentPadding: EdgeInsets.all(10),
                        focusedBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.7),
                          borderSide: BorderSide(
                              color: Colors.red,
                              width: 5.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Row(
                      children: [
                        SizedBox(width: 90,),
                        RaisedButton(
                          onPressed: ()async{
                            _nomController.text.isEmpty?nom=null:nom=_nomController.text;
                            _prenomController.text.isEmpty?prenom=null:prenom=_prenomController.text;
                            _emailController.text.isEmpty?email=null:email=_emailController.text;
                            _cinController.text.isEmpty?cin=null:cin=_cinController.text;

                            var formdata=formKey.currentState;
                            if (formdata!.validate()) {
                              formdata.save();
                            }
                            if(cin!=null && email!=null && prenom!=null && nom!=null){
                              List<Map> response_1=await sqlDb.user_readData("SELECT * FROM user WHERE  cin='"+cin.toString()+"'");
                              if(response_1.isNotEmpty){
                                List<Map> response_1=await sqlDb.user_readData("SELECT * FROM user WHERE email='"+email.toString()+"'");
                                if(response_1.isNotEmpty){
                                  List<Map> response_1=await sqlDb.user_readData("SELECT * FROM user WHERE  cin='"+cin.toString()+"'");
                                  if(response_1.isNotEmpty){
                                    mdp=response_1[0]['mot_de_passe'].toString();
                                    AchievementView(
                                      context,
                                      title: 'Votre mot de passe est ',
                                      subTitle: mdp.toString(),
                                      icon: Icon(Icons.verified,size: 30,color: Colors.white,),
                                      listener: (status){
                                      },
                                      typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
                                      alignment: Alignment.topCenter,
                                      duration: Duration(milliseconds: 10000),
                                      elevation: 10,
                                      borderRadius:  BorderRadius.circular(45),
                                      textStyleTitle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                      textStyleSubTitle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                      color: Colors.green,

                                    )..show();
                                  }
                                  else{
                                  AchievementView(
                                    context,
                                    title: "Erreur!",
                                    subTitle: "Vérifier tous les champs!",
                                    icon: Icon(Icons.warning,size: 30,color: Colors.white,),
                                    listener: (status){
                                    },
                                    typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
                                    alignment: Alignment.topCenter,
                                    duration: Duration(milliseconds: 400),
                                    elevation: 10,
                                    borderRadius:  BorderRadius.circular(45),
                                    textStyleTitle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    textStyleSubTitle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    color: Colors.redAccent,

                                  )..show();
                                }
                                }
                                else{
                                  AchievementView(
                                    context,
                                    title: "Attention!!",
                                    subTitle: "cet email n'existe pas",
                                    icon: Icon(Icons.warning,size: 30,color: Colors.white,),
                                    listener: (status){
                                    },
                                    typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
                                    alignment: Alignment.topCenter,
                                    duration: Duration(milliseconds: 400),
                                    elevation: 10,
                                    borderRadius:  BorderRadius.circular(45),
                                    textStyleTitle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    textStyleSubTitle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    color: Colors.redAccent,

                                  )..show();
                                }
                              }
                              else{
                                AchievementView(
                                  context,
                                  title: "Attention!!",
                                  subTitle: "ce CIN n'existe pas",
                                  icon: Icon(Icons.warning,size: 30,color: Colors.white,),
                                  listener: (status){
                                  },
                                  typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
                                  alignment: Alignment.topCenter,
                                  duration: Duration(milliseconds: 400),
                                  elevation: 10,
                                  borderRadius:  BorderRadius.circular(45),
                                  textStyleTitle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                  textStyleSubTitle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                  color: Colors.redAccent,

                                )..show();
                              }
                            }
                            else {
                              AchievementView(
                                context,
                                title: "Attention!!",
                                subTitle: "Tous les champs sont obligatoire.",
                                icon: Icon(Icons.warning,size: 30,color: Colors.white,),
                                listener: (status){
                                },
                                typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
                                alignment: Alignment.topCenter,
                                duration: Duration(milliseconds: 400),
                                elevation: 10,
                                borderRadius:  BorderRadius.circular(45),
                                textStyleTitle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                textStyleSubTitle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                color: Colors.redAccent,

                              )..show();
                            }
                          },
                          child: Text(
                            'Récuperer',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          color: Colors.indigo[200],
                        ),
                        SizedBox(width: 20,),
                        RaisedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                          },
                          child: Text(
                            'Annuler',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          color: Colors.purple[200],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




