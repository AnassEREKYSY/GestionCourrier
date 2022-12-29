import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:collapsible_navigation_drawer_example/SqlDb.dart';
import 'package:collapsible_navigation_drawer_example/model/CourrierDataBase.dart';
import 'package:collapsible_navigation_drawer_example/model/courrier.dart';
import 'package:collapsible_navigation_drawer_example/page/courrier_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../model/Listview.dart';
import '../model/slidable_action.dart';
import '../provider/navigation_provider.dart';
import '../widget/navigation_drawer_widget.dart';
import 'acceuil.dart';
import 'chercher.dart';
import 'modifier.dart';
import 'supprimer.dart';

class Archive extends StatefulWidget {
  static final String title = 'Archive';
  int? id;
  Archive({
    Key? key,
    this.id,
  }):super(key: key);
  @override
  State<Archive> createState() => _ArchiveState();
}


class _ArchiveState extends State<Archive> {
  int index = 0;
  late String objetm,expiditeurm,destinatairem,datem,typem,photosm,tagsm;
  late int urgentm,test12,test2,archive,id_cour;
  late String test1;
  SqlDb sqlDb=SqlDb();
  Future<List<Map>> readData() async{
    List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE archive=1 AND id_user="+widget.id.toString());
    return response;
  }
  late courrier courr;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.deepOrange[400],
      centerTitle: true,
      actions: [
        Row(
          children: [
            IconButton(
                onPressed: ()async{
                  List<Map> response2=await sqlDb.user_readData("SELECT * FROM user WHERE id="+widget.id.toString());
                  String? nom,prenom,photo;
                  nom=response2[0]['nom'].toString();
                  prenom=response2[0]['prenom'].toString();
                  photo=response2[0]['photo'].toString();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context)=>Acceuil(id: widget.id,nom: nom,prenom: prenom,photo: photo,)),ModalRoute.withName('/home'));

                },
                icon: Icon(Icons.arrow_back, size: 25,)),
            SizedBox(width: 110,),
            Text('Archives',style: TextStyle(fontSize: 20),),
            SizedBox(width: 120,),
              IconButton(
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>chercher(id:widget.id,route: 1,)
                  ));
                },
                icon: const Icon(Icons.search),
              ),
          ],
        ),
      ],
    ),
    body: Container(

      child:ListView(
        children: [

          FutureBuilder(
              future: readData(),
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
                          snapshot.data![i]['urgent']==0?test12=0:test12=1;
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
                                    caption: 'désarchiver',
                                    color: Colors.teal,
                                    icon: Icons.folder,
                                    onTap: ()async{
                                      int response=await sqlDb.updateData("UPDATE courrier SET archive=0 WHERE id="+snapshot.data![i]['id'].toString()+" AND id_user="+widget.id.toString());
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
                                secondaryActions: [
                                  IconSlideAction(
                                    caption: 'supprimer',
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    onTap: ()async{
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context)=>supprimer(id: snapshot.data![i]['id'],iduser:widget.id,route: 2,)
                                      ));
                                    },
                                  ),
                                ],
                                child: Card(child: ListTile(
                                  contentPadding:EdgeInsets.symmetric(vertical: 7,horizontal: 30) ,
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => Details(id:widget.id,idcour:snapshot.data![i]['id'],typ:snapshot.data![i]['type'],obj:snapshot.data![i]['objet'],exp:snapshot.data![i]['expiditeur'],des:snapshot.data![i]['destinataire'],dat:snapshot.data![i]['date'],tag:snapshot.data![i]['tags'],urg:urgentm,ph:snapshot.data![i]['photos'],route: 2,)));
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
                                    child: test2==1?Icon(Icons.whatshot_rounded,color: Colors.red,):Icon(Icons.whatshot_rounded,color: Colors.grey,),
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
                return Center(child: CircularProgressIndicator(),);
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

class CustomSearchDelegate extends SearchDelegate{
  List <String> searchTerms=[
    'Applle',
    'Banana',
    'Pear',
    'Oranges',
    'Buleberries',
    'Strawberries',
    'Watermelons',
  ];

  @override
  List <Widget> buildActions(BuildContext context){
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: (){
          query='';
        },
      ),
    ];

  }
  @override
  Widget buildLeading(BuildContext context){
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: (){
        close(context,null);
      },
    );
  }
  @override
  Widget buildResults(BuildContext context){
    List <String> matchQuery=[];
    for(var fruits in searchTerms){
      if(fruits.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(fruits);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context,index) {
        var result=matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
  @override
  Widget buildSuggestions(BuildContext context){
    List <String> matchQuery=[];
    for(var fruits in searchTerms){
      if(fruits.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(fruits);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context,index) {
        var result=matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}

