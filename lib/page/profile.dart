
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


class Profil extends StatefulWidget {
  String? nom,prenom,email,mdp,adresse,tel,cin,photo;
  int? id;
  Profil({
    Key? key,
    this.id,
    this.cin,
    this.nom,
    this.prenom,
    this.email,
    this.mdp,
    this.adresse,
    this.tel,
    this.photo
  }):super(key: key);
  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  Image? imgs;
  late File imageFile;
  String? nom1,prenom1,email1,mdp1,adresse1,tel1,cin1,photo;
  late DateTime dateTime = new DateTime(2022);
  SqlDb sqlDb=new SqlDb();
  TextEditingController _cinController = new TextEditingController();
  TextEditingController _nomController = new TextEditingController();
  TextEditingController _prenomController = new TextEditingController();
  TextEditingController _adresseController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _telephoneController = new TextEditingController();
  TextEditingController _mdpController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    String base64 = '';
    String? img;
    void _getFromCamera() async {
      String base64;
      final myfile =await ImagePicker().getImage(
        source: ImageSource.camera,
      );
      setState(() {
        if(myfile!=null){
          base64=base64Encode(File(myfile.path).readAsBytesSync());
          img=base64.toString();
        }
      });
    }
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigo[200],
        title:Row(
          children: [
            IconButton(
                onPressed: ()async{
                  List<Map> response2=await sqlDb.user_readData("SELECT * FROM user WHERE id="+widget.id.toString());
                  String? nom,prenom;
                  nom=response2[0]['nom'].toString();
                  prenom=response2[0]['prenom'].toString();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context)=>Acceuil(id: widget.id,nom: nom,prenom: prenom,photo: widget.photo,)),ModalRoute.withName('/home'));

                },
                  icon: Icon(Icons.arrow_back, size: 27,)),
            SizedBox(width: 110,),
            Text('Profile',style: TextStyle(fontSize: 25),),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 5, right: 18, left: 18),
          child: Column(
            children: [
              imgs==null?IconButton(
                onPressed: (){
                  _getFromCamera();
                },
                icon:Icon(Icons.account_circle),iconSize: 150,
              ):CircleAvatar(
                radius: 80,
                backgroundImage: MemoryImage(base64Decode(base64)),
                child: IconButton(
                  color: Colors.transparent,
                  onPressed: (){_getFromCamera();},
                  padding: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                  icon:Icon(Icons.account_circle,color: Colors.transparent,),iconSize: 120,
                ),

              ),

              Center(
               child:  Text(
                 (widget.prenom.toString()+' '+widget.nom.toString())==null?'Utilisateur':(widget.prenom.toString()+' '+widget.nom.toString()),
                 style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
               ),
              ),
              SizedBox(height: 20,),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller:_cinController,
                      decoration: InputDecoration(
                        hintText:  widget.cin,
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
                    SizedBox(height: 7,),
                    TextFormField(
                      controller:_nomController,
                      decoration: InputDecoration(
                        hintText: widget.nom==null?'--aucun nom--':widget.nom,
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
                    SizedBox(height: 7,),
                    TextFormField(
                      controller:_prenomController,
                      decoration: InputDecoration(
                        hintText:   widget.prenom==null?'--aucun prenom--':widget.prenom,
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
                    SizedBox(height: 7,),
                    TextFormField(
                      controller:_emailController,
                      decoration: InputDecoration(
                        hintText:   widget.email==null?'--aucun email--':widget.email,
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
                    SizedBox(height: 7,),
                    TextFormField(
                      controller:_adresseController,
                      decoration: InputDecoration(
                        hintText:   widget.adresse==null?'--aucun adresse--':widget.adresse,
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
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
                    SizedBox(height: 7,),
                    TextFormField(
                      controller:_telephoneController,
                      decoration: InputDecoration(
                        hintText:   widget.tel==null?'--aucun téléphone--':widget.tel,
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
                    SizedBox(height: 7,),
                    TextFormField(
                      controller:_mdpController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText:  widget.mdp!=null?'*************':'--aucun mot de passe--',
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
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        SizedBox(width: 50,),
                        RaisedButton(
                          child: Text(
                            'Retouner',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          color: Colors.indigo[200],
                          onPressed: () async{
                            nom1=_nomController.text.isEmpty?widget.nom:_nomController.text;
                            prenom1=_prenomController.text.isEmpty?widget.prenom:_prenomController.text;
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                builder: (context)=>Acceuil(id: widget.id,nom: nom1,prenom: prenom1,photo: widget.photo,)),ModalRoute.withName('/home'));
                          },
                        ),
                        SizedBox(width: 40,),
                        RaisedButton(
                          child: Text(
                            'Modifier',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          color: Colors.indigo[200],
                          onPressed: () async{
                            var formdata=formKey.currentState;
                            if (formdata!.validate()) {
                              formdata.save();
                            }
                            nom1=_nomController.text.isEmpty?widget.nom:_nomController.text;
                            prenom1=_prenomController.text.isEmpty?widget.prenom:_prenomController.text;
                            adresse1=_adresseController.text.isEmpty?widget.adresse:_adresseController.text;
                            email1=_emailController.text.isEmpty?widget.email:_emailController.text;
                            tel1=_telephoneController.text.isEmpty?widget.tel:_telephoneController.text;
                            cin1=_cinController.text.isEmpty?widget.cin:_cinController.text;
                            mdp1=_mdpController.text.isEmpty?widget.mdp:_mdpController.text;
                            if(img==null){
                              img=null;
                            }else{
                              img=img;
                            }
                            int reponse = await sqlDb.user_updateData("UPDATE user SET cin='"+cin1.toString()+"', nom='"+nom1.toString()+"', prenom='"+prenom1.toString()+"', adresse='"+adresse1.toString()+"', email='"+email1.toString()+"', telephone='"+tel1.toString()+"', mot_de_passe='"+mdp1.toString()+"', photo='"+img.toString()+"' WHERE id="+widget.id.toString());
                            if(reponse!=0){
                             List<Map> reponse = await sqlDb.user_readData("SELECT * FROM user WHERE id="+widget.id.toString());
                             nom1=reponse[0]['nom'].toString();
                             prenom1=reponse[0]['prenom'].toString();
                             adresse1=reponse[0]['adresse'].toString();
                             email1=reponse[0]['email'].toString();
                             tel1=reponse[0]['telephone'].toString();
                             cin1=reponse[0]['cin'].toString();
                             mdp1=reponse[0]['mot_de_passe'].toString();
                             photo=reponse[0]['photo'].toString();
                             setState(() {
                               Uint8List image = base64Decode(reponse[0]['photo']);
                               imgs=Image.memory(image);
                               widget.photo=photo;
                               widget.nom=nom1;
                               widget.prenom=prenom1;
                               widget.cin=cin1;
                               widget.adresse=adresse1;
                               widget.tel=tel1;
                               widget.email=email1;
                               widget.mdp=mdp1;
                             });
                              AchievementView(
                                context,
                                title: "Succés!",
                                subTitle: "modification avec succés!",
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
                              // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                              //     builder: (context)=>Acceuil(id: widget.id,nom: nom1,prenom: prenom1,)),ModalRoute.withName('/home'));

                            }else{
                              AchievementView(
                              context,
                              title: "Erreur!",
                              subTitle: "Il y a un erreur dans la modification du profile!",
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
                            //Send to API
                          },

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




