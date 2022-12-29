import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:collapsible_navigation_drawer_example/main.dart';
import 'package:collapsible_navigation_drawer_example/page/acceuil.dart';
import 'package:collapsible_navigation_drawer_example/page/inscription.dart';
import 'package:collapsible_navigation_drawer_example/page/premiere_connexion1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../SqlDb.dart';
import 'mdp_oublié.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState()=>_LoginScreenState();

}
class _LoginScreenState extends  State<LoginScreen>{
  final formKey = new GlobalKey<FormState>();
  String? email,password,nom,prenom,photo;
  int? iduser;
  SqlDb sqlDb=new SqlDb();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    _emailController.text='ereanass@gmail.com';
    _passwordController.text='AZERTY123';

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
        child:GestureDetector(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 120,),
                          Container(
                            child: Text(
                              'Connexion',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 120,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20,bottom: 5),
                                child: Text('Email'),
                              ),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                  ),
                                  // icon: Icon(Icons.email),
                                  hintText: 'Email',
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
                              Padding(
                                padding: const EdgeInsets.only(left: 20,bottom: 5),
                                child: Text('Mot de passe'),

                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                validator: (value){
                                  if(value == ''){
                                    return 'errrr';
                                  }else{
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                  ),
                                  // icon: Icon(Icons.lock),
                                  hintText: 'Mot de passe',
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
                              FlatButton(
                                onPressed: (){
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MDP()), ModalRoute.withName('/mdp'));
                                },
                                child:Text('Mot de passe oublié?'),
                              ),
                              SizedBox(height: 50,),
                              Container(
                                  child: Center(
                                    child: RaisedButton(
                                      onPressed: () async {
                                          email=_emailController.text.toString();
                                          password=_passwordController.text.toString();
                                          if(email.toString()!=null && password.toString()!=null) {
                                            List<Map> reponse = await sqlDb.user_readData('SELECT * FROM user where email like "'+ email! +'" and mot_de_passe like "'+password!+'"');
                                            if (reponse.isNotEmpty) {
                                                  iduser=reponse[0]['id'];
                                                  nom=reponse[0]['nom'];
                                                  prenom=reponse[0]['prenom'];
                                                  photo=reponse[0]['photo'];
                                                  AchievementView(
                                                    context,
                                                    title: "Succés!",
                                                    subTitle: "connexion avec succés!",
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
                                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Acceuil(id: iduser,nom:nom,prenom:prenom,photo:photo,)), ModalRoute.withName('/home'));
                                            }
                                            else {
                                              AchievementView(
                                                context,
                                                title: "Erreur!!",
                                                subTitle: "Mot de passe ou Email sont incorrecte",
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
                                              title: "Erreur!!",
                                              subTitle: "Il y a une erreur lors de la connexion!",
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
                                        'Connexion',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      color: Colors.white,
                                    ),
                                  )
                              ),
                              SizedBox(height: 80,),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    FlatButton(
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>inscription()));
                                      },
                                      child:Text(
                                        'Si vous êtes nouveau esseyer de créer un compte',
                                        style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
  
}