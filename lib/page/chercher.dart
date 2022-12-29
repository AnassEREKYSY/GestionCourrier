import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:collapsible_navigation_drawer_example/SqlDb.dart';
import 'package:collapsible_navigation_drawer_example/model/CourrierDataBase.dart';
import 'package:collapsible_navigation_drawer_example/model/courrier.dart';
import 'package:collapsible_navigation_drawer_example/page/courrier_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../model/Listview.dart';
import '../model/slidable_action.dart';
import '../provider/navigation_provider.dart';
import '../widget/navigation_drawer_widget.dart';
import 'acceuil.dart';
import 'modifier.dart';
import 'supprimer.dart';

class chercher extends StatefulWidget {
  static final String title = 'Courrier';
  int? id,route;
  chercher({
    Key? key,
    this.id,this.route
  }):super(key: key);
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => NavigationProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: chercher(),
    ),
  );
  @override
  State<chercher> createState() => _chercherState();
}


class _chercherState extends State<chercher> {
  String? valeur;
  String filtre='Filtre';
  int index = 0;
  int refraiche=0;
  late String objetm,expiditeurm,destinatairem,datem,typem,photosm,tagsm;
  late int urgentm,test12,test2,archive,id_cour;
  late String test1;
  SqlDb sqlDb=SqlDb();
  Future<List<Map>> readData() async{
    List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE archive=0");
    return response;
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    filtre='Filtre';
  }
  Future<List<Map>> readData_search(String search,String filtre) async{
    if(filtre=='Filtre'){
      List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE (objet like '%"+search+"%' OR expiditeur like '%"+search+"%' OR destinataire like '%"+search+"%' OR date like '%"+search+"%' OR tags like '%"+search+"%') AND archive=0 AND id_user="+widget.id.toString());
      return response;
    }else if(filtre=='Objet'){
      List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE objet like '%"+search+"%'  AND archive=0 AND id_user="+widget.id.toString());
      return response;
    }else if(filtre=='Destinataire'){
      List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE destinataire like '%"+search+"%'  AND archive=0 AND id_user="+widget.id.toString());
      return response;
    }else if(filtre=='Expiditeur'){
      List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE expiditeur like '%"+search+"%'  AND archive=0 AND id_user="+widget.id.toString());
      return response;
    }else if(filtre=='Tags'){
      List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE tags like '%"+search+"%'  AND archive=0 AND id_user="+widget.id.toString());
      return response;
    }return [];

  }
  Future<List<Map>> readData_search1(String search,String filtre) async{
    if(filtre=='Filtre'){
      List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE (objet like '%"+search+"%' OR expiditeur like '%"+search+"%' OR destinataire like '%"+search+"%' OR date like '%"+search+"%' OR tags like '%"+search+"%') AND archive=1 AND id_user="+widget.id.toString());
      return response;
    }else if(filtre=='Objet'){
      List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE objet like '%"+search+"%'  AND archive=1 AND id_user="+widget.id.toString());
      return response;
    }else if(filtre=='Destinataire'){
      List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE destinataire like '%"+search+"%'  AND archive=1 AND id_user="+widget.id.toString());
      return response;
    }else if(filtre=='Expiditeur'){
      List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE expiditeur like '%"+search+"%'  AND archive=1 AND id_user="+widget.id.toString());
      return response;
    }else if(filtre=='Tags'){
      List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE tags like '%"+search+"%'  AND archive=1 AND id_user="+widget.id.toString());
      return response;
    }return [];

  }
  late String keyword='';

  late courrier courr;
  final items=['   Tous','Objet','Expiditeur','Destinataire','Tags'];
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.teal[600],
      title: Row(
        children: [
          SizedBox(width: 98,),
          Text('Courrier',style: TextStyle(fontSize: 25),),
        ],
      ),
      centerTitle: true,

    ),
    body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    decoration: InputDecoration(
                     labelText: 'Chercher un courrier',
                      prefixIcon: Icon(
                        Icons.search,
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
                    onChanged: (value){
                      keyword=value;
                      setState(() {

                      });
                    },
                  ),
                ),
                Container(
                  width: 110,
                  height: 40,
                  margin: EdgeInsets.all(3),
                  padding:EdgeInsets.symmetric(horizontal: 5),
                  decoration:BoxDecoration(
                    border: Border.all(color: Colors.black38,width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint:Text("   Filtre",style: TextStyle(fontSize: 15),),
                        value:  valeur,
                        isExpanded: true,
                        iconSize: 36,
                        icon: Icon(Icons.arrow_drop_down,color: Colors.black,),
                        // items: items.map(buildMenuItem).toList(),
                        onChanged: (value){
                          this.valeur=value.toString();
                          filtre=value.toString();
                          setState(() {

                          });
                        },
                        items: items.map<DropdownMenuItem<String> >(
                                (String item){
                              return DropdownMenuItem<String>(

                                value: item,
                                child: Text(item.toString(),style: TextStyle(fontSize: 13),),
                              );
                            }
                        ).toList()
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
                future: widget.route==1?readData_search1(keyword,filtre):readData_search(keyword,filtre),
                builder: (BuildContext context,AsyncSnapshot<List<Map>> snapshot){
                  if(snapshot.hasData){
                    return SingleChildScrollView(
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (context,i){
                            test1=snapshot.data![i]['type'].toString();
                            snapshot.data![i]['urgent']==null?test12=0:test12=1;
                            test2=test12;
                            id_cour=snapshot.data![i]['id'];
                            objetm=snapshot.data![i]['objet'];
                            expiditeurm=snapshot.data![i]['expiditeur'];
                            destinatairem=snapshot.data![i]['destinataire'];
                            datem=snapshot.data![i]['date'];
                            typem=snapshot.data![i]['type'];
                            snapshot.data![i]['urgent'] == 0 ? urgentm = 0 : urgentm = 1;
                            photosm=snapshot.data![i]['photos'].toString();
                            tagsm=snapshot.data![i]['tags'];
                            snapshot.data![i]['archive']==0? archive=0:archive=1;
                            return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(90),
                                      topRight: Radius.circular(90),
                                      bottomLeft: Radius.circular(90),
                                      bottomRight: Radius.circular(90)
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 15,
                                      offset: Offset(7, 7), // changes position of shadow
                                    ),
                                  ],
                                ),
                                height: 80,
                                child: Slidable(
                                  key: Key(snapshot.data![i]['objet']),
                                  dismissal: SlidableDismissal(
                                    child: SlidableDrawerDismissal(),
                                    onDismissed: (type){
                                      final action=type==SlideActionType.primary ? SlidableAction.modifier:SlidableAction.supprimer;
                                      onDismissed(index, action);
                                    },
                                  ),
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.23,
                                  actions: [
                                    IconSlideAction(
                                      caption: 'Modifier',
                                      color: Colors.blue,
                                      icon: Icons.edit,
                                      onTap: ()async{
                                        if(widget.route==1){
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (context)=>modifier(iduser:widget.id,id:snapshot.data![i]['id'],typ:snapshot.data![i]['type'],obj:snapshot.data![i]['objet'],exp:snapshot.data![i]['expiditeur'],des:snapshot.data![i]['destinataire'],dat:snapshot.data![i]['date'],tag:snapshot.data![i]['tags'],urg:urgentm,ph:snapshot.data![i]['photos'],route: 1,)
                                          ));
                                        }
                                        else{
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (context)=>modifier(iduser:widget.id,id:snapshot.data![i]['id'],typ:snapshot.data![i]['type'],obj:snapshot.data![i]['objet'],exp:snapshot.data![i]['expiditeur'],des:snapshot.data![i]['destinataire'],dat:snapshot.data![i]['date'],tag:snapshot.data![i]['tags'],urg:urgentm,ph:snapshot.data![i]['photos'],)
                                          ));
                                        }

                                      },
                                    ),
                                  ],
                                  secondaryActions: [
                                    IconSlideAction(
                                      caption: 'supprimer',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: ()async{
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context)=>supprimer(id:snapshot.data![i]['id'] ,iduser:widget.id,route: 1,)
                                        ));
                                      },
                                    ),
                                    IconSlideAction(
                                      caption: 'archiver',
                                      color: Colors.teal,
                                      icon: Icons.folder,
                                      onTap: ()async{
                                        int response=await sqlDb.updateData("UPDATE courrier SET archive=1 WHERE id="+snapshot.data![i]['id'].toString()+" AND id_user="+widget.id.toString());
                                        if(response!=0){
                                          AchievementView(
                                            context,
                                            title: "Succés!",
                                            subTitle: "courrier archivé avec succés!",
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
                                        }
                                        setState(() {
                                          readData();
                                        });
                                      },
                                    ),
                                  ],
                                  child: Card(child: ListTile(
                                    contentPadding:EdgeInsets.symmetric(vertical: 7,horizontal: 30) ,
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => Details(id:widget.id,idcour:snapshot.data![i]['id'],typ:snapshot.data![i]['type'],obj:snapshot.data![i]['objet'],exp:snapshot.data![i]['expiditeur'],des:snapshot.data![i]['destinataire'],dat:snapshot.data![i]['date'],tag:snapshot.data![i]['tags'],urg:urgentm,ph:snapshot.data![i]['photos'],route: 1,)));
                                    },
                                    title: Text(
                                      "Objet: "+" ${snapshot.data![i]['objet']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,

                                      ),
                                    ),
                                    subtitle: Text(
                                      "à: "+"${snapshot.data![i]['destinataire']}"+"\nde: "+"${snapshot.data![i]['expiditeur']}",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    leading: FlatButton(
                                      child: test1=='Sortant'?Icon(Icons.arrow_circle_up_rounded,color: Colors.red,):Icon(Icons.arrow_circle_down_rounded,color: Colors.green,),
                                      minWidth: 5,
                                      padding: EdgeInsets.all(0),
                                      onPressed: ()async{
                                        String type_changed;
                                        if(snapshot.data![i]['type'].toString()=='Sortant'){
                                          type_changed='Entrant';
                                        }else{
                                          type_changed='Sortant';
                                        }
                                        int response=await sqlDb.updateData("UPDATE courrier SET type='"+type_changed.toString()+"'WHERE id="+snapshot.data![i]['id'].toString());
                                        setState(() {
                                          readData();
                                        });
                                      },

                                    ),
                                    trailing: FlatButton(
                                      child: snapshot.data![i]['urgent']==1?Icon(Icons.whatshot_rounded,color: Colors.red,):Icon(Icons.whatshot_rounded,color: Colors.grey,),
                                      minWidth: 5,
                                      padding: EdgeInsets.all(0),
                                      onPressed: ()async{
                                        int urg_changed;
                                        if(snapshot.data![i]['urgent']==1){
                                          urg_changed=0;
                                        }else{
                                          urg_changed=1;
                                        }
                                        int response=await sqlDb.updateData("UPDATE courrier SET urgent="+urg_changed.toString()+" WHERE id="+snapshot.data![i]['id'].toString());

                                        setState(() {
                                          readData();
                                        });
                                      },

                                    ),
                                  ),),
                                ));
                          }),
                    );
                  }
                  else{
                    return Center(child: Text('aucun courrier est trouvé'),);
                  }
                })
          ],
        ),
    ),
  );
  void onDismissed(int index, SlidableAction action) {
    if(action==SlidableAction.modifier){
      Navigator.push(context, MaterialPageRoute(
          builder: (context)=>modifier(iduser:widget.id,typ:typem,obj:objetm,exp:expiditeurm,des:destinatairem,dat:datem,tag:tagsm,urg:urgentm,ph:photosm,)
      ));
    }else{
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>supprimer()));
    }
  }
}


