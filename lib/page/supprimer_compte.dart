import 'dart:io';

import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:collapsible_navigation_drawer_example/model/courrier.dart';
import 'package:collapsible_navigation_drawer_example/page/loginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../SqlDb.dart';
import '../main.dart';
import 'acceuil.dart';
class supprimer_compte extends StatefulWidget {
  int? iduser;
  supprimer_compte(
      {Key? key, this.iduser}): super(key: key);
  @override
  State<supprimer_compte> createState() => _supprimer_compteState();

}

class _supprimer_compteState extends  State<supprimer_compte>{
  SqlDb sqlDb=SqlDb();
  String? urgentcocher;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String _objet;
  late String _date;
  bool? checkBoxValue=false;
  late courrier courr;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.red[400],
      title: Row(
        children: [
          IconButton(
            onPressed:()async{
              List<Map> response=await sqlDb.user_readData("SELECT * FROM user WHERE id="+widget.iduser.toString());
              String? nom,prenom,photo;
              nom=response[0]['nom'].toString();
              prenom=response[0]['prenom'].toString();
              photo=response[0]['photo'].toString();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (context)=>Acceuil(id: widget.iduser,nom: nom,prenom: prenom,photo: photo,)),ModalRoute.withName('/home'));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          SizedBox(width: 45,),
          Text('Supprimer votre compte'),
        ],
      ),
      centerTitle: true,
    ),
    body: Container(
      margin: EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning,
                  size: 30,
                  color: Colors.red,
                ),
                SizedBox(width: 10,),
                Text(
                  'Attention !!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: checkBoxValue,
                  onChanged: (bool? value){
                    setState(() {
                      checkBoxValue=value;
                      value==false?urgentcocher='false':urgentcocher='true';
                    });
                  },
                ),
                Text(
                  'si vous supprimeriez votre \n  compte tous vous données \n  vont etre supprimées!!',
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            SizedBox(height: 50,),
            Row(
              children: [
                SizedBox(width: 50,),
                RaisedButton(
                    child: Text(
                      'Annuler',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.grey[100],
                    onPressed: () async{
                      List<Map> response=await sqlDb.user_readData("SELECT * FROM user WHERE id="+widget.iduser.toString());
                      String? nom,prenom,photo;
                      nom=response[0]['nom'].toString();
                      prenom=response[0]['prenom'].toString();
                      photo=response[0]['photo'].toString();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                          builder: (context)=>Acceuil(id: widget.iduser,nom: nom,prenom: prenom,photo: photo,)),ModalRoute.withName('/home'));
                    }
                ),
                SizedBox(width: 40,),
                RaisedButton(
                  child: Text(
                    'Supprimer',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.grey[100],
                  onPressed: ()async{
                    var formdata=formKey.currentState;
                    if (formdata!.validate()) {
                      formdata.save();
                    }
                    if(urgentcocher=='true'){
                      int response=await sqlDb.user_deleteData("DELETE FROM user WHERE id='"+widget.iduser.toString());
                      if(response!=0){
                        List<Map> response=await sqlDb.user_readData("SELECT * FROM user WHERE id="+widget.iduser.toString());
                        AchievementView(
                          context,
                          title: "Succés!",
                          subTitle: "suppression avec succés!",
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
                      }else{
                        AchievementView(
                          context,
                          title: "Erreur!",
                          subTitle: "il y a une erreur lors de la suppression!",
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
                        title: "Erreur!",
                        subTitle: "Vous devez cochez la case ci-dessus!",
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
                ),
              ],
            ),
          ],
        ),
      ),

    ),
  );
}
