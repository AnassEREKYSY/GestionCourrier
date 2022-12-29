import 'dart:io';

import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:collapsible_navigation_drawer_example/SqlDb.dart';
import 'package:collapsible_navigation_drawer_example/main.dart';
import 'package:collapsible_navigation_drawer_example/page/archive.dart';
import 'package:collapsible_navigation_drawer_example/page/loginScreen.dart';
import 'package:collapsible_navigation_drawer_example/page/profile.dart';
import 'package:collapsible_navigation_drawer_example/page/supprimer_compte.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/drawer_items.dart';
import '../model/drawer_item.dart';
import '../page/ajouter.dart';
import '../page/supprimer.dart';
import '../page/deconnexion.dart';
import '../page/modifier.dart';
import '../provider/navigation_provider.dart';

class NavigationDrawerWidget extends StatefulWidget{
  int? id;
  String? photo,nom,prenom;
  NavigationDrawerWidget({
    Key? key,
    this.id,
    this.nom,
    this.prenom,
    this.photo
  }):super(key: key);
  @override
  _NavigationDrawerWidgetState createState()=>_NavigationDrawerWidgetState();

}

class _NavigationDrawerWidgetState  extends  State<NavigationDrawerWidget>{
  SqlDb sqlDb =new SqlDb();
  String? nom,prenom,tel,email,mdp,adresse,cin;
  final padding = EdgeInsets.symmetric(horizontal: 20);
  void readData() async{
    List<Map> reponse = await sqlDb.readData("SELECT * FROM courrier WHERE id="+widget.id.toString());
    cin=reponse[0]['cin'].toString();
    // nom=reponse[0]['nom'].toString();
    // prenom=reponse[0]['prenom'].toString();
    email=reponse[0]['email'].toString();
    mdp=reponse[0]['mot_de_passe'].toString();
    tel=reponse[0]['telephone'].toString();
    adresse=reponse[0]['adresse'].toString();
    widget.photo=reponse[0]['photo'].toString();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

    final provider = Provider.of<NavigationProvider>(context);
    final isCollapsed = provider.isCollapsed;

    return Container(
      width: isCollapsed ? MediaQuery.of(context).size.width * 0.2 : null,
      child: Drawer(
        child: Container(
          color: Colors.deepPurple[700],
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 25).add(safeArea),
                width: double.infinity,
                color: Colors.deepPurple[700],
                child: buildHeader(isCollapsed,context),
              ),
              Divider(color: Colors.white70, thickness: 1,),
              const SizedBox(height: 10),
              buildList(items: itemsFirst, isCollapsed: isCollapsed,),
              const SizedBox(height: 10),
              Divider(color: Colors.white70,thickness: 1,),
              Spacer(),
              buildCollapseIcon(context, isCollapsed),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );

  }

  Widget buildList({
    required bool isCollapsed,
    required List<DrawerItem> items,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItem(
            isCollapsed: isCollapsed,
            text: item.title,
            icon: item.icon,
            onClicked: () => selectItem(context, indexOffset + index),
          );
        },
      );

  void selectItem(BuildContext context, int index) {
    final navigateTo = (page) => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));

    Navigator.of(context).pop();

    switch (index) {
      case 0:
        navigateTo(Ajouter(id:widget.id,));
        break;
      case 1:
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Archive(id: widget.id,)), ModalRoute.withName('/login'));
        break;
      case 2:
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => supprimer_compte(iduser: widget.id,)), ModalRoute.withName('/suppriemr_compte'));
        break;
      case 3:
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), ModalRoute.withName('/login'));
        break;
      default:break;
    }
  }

  Widget buildMenuItem({
    required bool isCollapsed,
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final leading = Icon(icon, color: color);

    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(
              title: leading,
              onTap: onClicked,
            )
          : ListTile(
              leading: leading,
              title: Text(text, style: TextStyle(color: color, fontSize: 20)),
              onTap: onClicked,
            ),
    );
  }

  Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
    final double size = 52;

    final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
    final margin = isCollapsed ? null : EdgeInsets.only(right: 16);
    final width = isCollapsed ? double.infinity : size;

    return Container(
      alignment: alignment,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            width: width,
            height: size,
          ),
          onTap: () {
            final provider =
                Provider.of<NavigationProvider>(context, listen: false);

            provider.toggleIsCollapsed();
          },
        ),
      ),
    );
  }

  Widget buildHeader(bool isCollapsed,BuildContext context) => isCollapsed
      ? Icon(Icons.folder,color: Colors.white,size: 40,)
      : Row(
          children: [
            FlatButton(
              onPressed: ()async{
                List<Map> reponse=await sqlDb.user_readData('SELECT * FROM user WHERE id='+widget.id.toString());
                cin=reponse[0]['cin'].toString();
                // nom=reponse[0]['nom'].toString();
                // prenom=reponse[0]['prenom'].toString();
                email=reponse[0]['email'].toString();
                mdp=reponse[0]['mot_de_passe'].toString();
                tel=reponse[0]['telephone'].toString();
                adresse=reponse[0]['adresse'].toString();
                widget.photo=reponse[0]['photo'].toString();

                Navigator.push(context, MaterialPageRoute(builder: (context)=>Profil(id:widget.id,cin:cin,nom: widget.nom,prenom: widget.prenom,email: email,mdp: mdp,adresse: adresse,tel: tel,photo: widget.photo,)));
              },
              child: Container(
                margin: EdgeInsets.only(right: 40, left: 40),
                child: Column(
                  children: [
                    SizedBox(height: 40,),
                  File(widget.photo.toString()).toString()==null?Icon(Icons.account_circle,color: Colors.white,size: 40,)
                    :CircleAvatar(
                      radius: 95,
                      backgroundImage: FileImage(File(widget.photo.toString())),
                      child: IconButton(
                      color: Colors.transparent,
                        onPressed: ()async{
                          List<Map> reponse=await sqlDb.user_readData('SELECT * FROM user WHERE id='+widget.id.toString());
                          cin=reponse[0]['cin'].toString();
                          // nom=reponse[0]['nom'].toString();
                          // prenom=reponse[0]['prenom'].toString();
                          email=reponse[0]['email'].toString();
                          mdp=reponse[0]['mot_de_passe'].toString();
                          tel=reponse[0]['telephone'].toString();
                          adresse=reponse[0]['adresse'].toString();
                          widget.photo=reponse[0]['photo'].toString();

                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Profil(id:widget.id,cin:cin,nom: widget.nom,prenom: widget.prenom,email: email,mdp: mdp,adresse: adresse,tel: tel,photo: widget.photo,)));
                        },
                      padding: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                      icon:Icon(Icons.account_circle,color: Colors.transparent,),iconSize: 120,
                      ),

                      ),
                    SizedBox(height: 40,),
                    Text(
                      (widget.prenom.toString()+' '+widget.nom.toString())==null?'Utilisateur':(widget.prenom.toString()+' '+widget.nom.toString()),
                      style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),

          ],
        );
}
