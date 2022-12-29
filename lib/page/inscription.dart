import 'dart:convert';
import 'dart:io';

import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:collapsible_navigation_drawer_example/page/loginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../SqlDb.dart';
import 'acceuil.dart';

class inscription extends StatefulWidget {

  @override
  State<inscription> createState() => _inscriptionState();
}

class _inscriptionState extends State<inscription> {
  String? photo;
  SqlDb sqlDb=SqlDb();
  TextEditingController _nomController = new TextEditingController();
  TextEditingController _prenomController = new TextEditingController();
  TextEditingController _adresseController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _mdpController = new TextEditingController();
  TextEditingController _cinController = new TextEditingController();
  TextEditingController _telephoneController = new TextEditingController();
  String? cin,nom,prenom,email,adresse,mdp,telephone,images1;
  @override
  Widget build(BuildContext context) {
    photo==null;
    late File imageFile;
    void _getFromGallery() async {
      String base64;
      final myfile =await ImagePicker().getImage(
        source: ImageSource.camera,
      );

      setState(() {
        if(myfile!=null){
          base64=base64Encode(File(myfile.path).readAsBytesSync());
          photo=base64;
        }
      });
    }
    File file=new File(photo.toString());
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
     body: SingleChildScrollView(
       child: Container(
         margin: EdgeInsets.only(top: 15, right: 18, left: 18),
         child: Column(
           children: [
             SizedBox(height: 40,),
             Column(
               children: [
                 photo==null?IconButton(
                         onPressed: (){
                   _getFromGallery();
                   },
                     icon:Icon(Icons.account_circle,color: Colors.purple[200],),iconSize: 170,
                   ):CircleAvatar(
                   radius: 90,
                   backgroundImage: FileImage(file),
                   child: IconButton(
                     color: Colors.transparent,
                     onPressed: (){_getFromGallery();},
                     padding: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                     icon:Icon(Icons.account_circle,color: Colors.transparent,),iconSize: 120,
                   ),

                 ),
                 Text(
                   '  Inscription',
                   style: TextStyle(
                     fontSize: 30,
                     fontWeight: FontWeight.w700,
                     color: Colors.indigo[300],
                   ),
                 ),
               ],
             ),
             SizedBox(height: 10,),
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
                     controller: _adresseController,
                     decoration: InputDecoration(
                       hintText: 'Adresse',
                       prefixIcon: Icon(
                         Icons.add_location,
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
                     controller: _telephoneController,
                     decoration: InputDecoration(
                       hintText: 'Télèphone',
                       prefixIcon: Icon(
                         Icons.phone,
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
                   SizedBox(height: 15,),
                   TextFormField(
                     obscureText: true,
                     controller: _mdpController,
                     decoration: InputDecoration(
                       hintText: 'Mot de passe',
                       prefixIcon: Icon(
                         Icons.lock,
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
                           String photo_final='';
                           photo==null?photo_final='null':photo_final=photo!;
                           _nomController.text.isEmpty?nom=null:nom=_nomController.text;
                           _prenomController.text.isEmpty?prenom=null:prenom=_prenomController.text;
                           _adresseController.text.isEmpty?adresse=null:adresse=_adresseController.text;
                           _emailController.text.isEmpty?email=null:email=_emailController.text;
                           _mdpController.text.isEmpty?mdp=null:mdp=_mdpController.text;
                           _telephoneController.text.isEmpty?telephone=null:telephone=_telephoneController.text;
                           _cinController.text.isEmpty?cin=null:cin=_cinController.text;

                           var formdata=formKey.currentState;
                           if (formdata!.validate()) {
                             formdata.save();
                           }
                           if(cin!=null && telephone!=null && email!=null && mdp!=null && adresse!=null && prenom!=null && nom!=null){
                              List<Map> response_1=await sqlDb.user_readData("SELECT * FROM user WHERE  cin='"+cin.toString()+"'");
                              if(response_1.isEmpty){
                                List<Map> response_1=await sqlDb.user_readData("SELECT * FROM user WHERE email='"+email.toString()+"'");
                                if(response_1.isEmpty){
                                  List<Map> response_1=await sqlDb.user_readData("SELECT * FROM user WHERE telephone='"+telephone.toString()+"'");
                                  if(response_1.isEmpty){
                                    int response=await sqlDb.user_insertData("INSERT INTO user(cin,nom,prenom,adresse,email,mot_de_passe,telephone,photo) values('"+cin!+"','"+nom!+"','"+prenom!+"','"+adresse!+"','"+email!+"','"+mdp!+"','"+telephone!+"',"+photo_final+")");
                                     List<Map> response1= await sqlDb.user_readData("SELECT * FROM user");
                                     if(response!=0){
                                       AchievementView(
                                         context,
                                         title: "Succés!",
                                         subTitle: "inscription avec succés!",
                                         icon: Icon(Icons.verified,size: 30,color: Colors.white,),
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
                                         color: Colors.lightGreen,

                                       )..show();
                                       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                           builder: (context)=>LoginScreen()),ModalRoute.withName('/login'));
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
                                  }else{
                                    AchievementView(
                                      context,
                                      title: "Attention!!",
                                      subTitle: "cet télèphone existe déjà",
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
                                }else{
                                  AchievementView(
                                    context,
                                    title: "Attention!!",
                                    subTitle: "cet email existe déjà",
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
                              }else{
                                AchievementView(
                                  context,
                                  title: "Attention!!",
                                  subTitle: "ce CIN existe déjà",
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
                           'Inscription',
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