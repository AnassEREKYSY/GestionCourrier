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
import 'chercher.dart';
import 'modifier.dart';
import 'supprimer.dart';

class Acceuil extends StatefulWidget {
  static final String title = 'Courrier';
  int? id;
  String? nom,prenom,photo;
  Acceuil({
    Key? key,
    this.id,
    this.nom,
    this.prenom,
    this.photo
  }):super(key: key);
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => NavigationProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: Acceuil(),
    ),
  );
  @override
  State<Acceuil> createState() => _AcceuilState();
}


class _AcceuilState extends State<Acceuil> {
  int index = 0;
  int refraiche=0;
  late String objetm,expiditeurm,destinatairem,datem,typem,photosm,tagsm;
  late int urgentm,test12,test2,archive,id_cour;
  late String test1;
  SqlDb sqlDb=SqlDb();
  Future<List<Map>> readData() async{
    List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE archive=0 AND id_user="+widget.id.toString());
    return response;
  }
  Future<void> _refresh()async {
    readData();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  late courrier courr;
  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: NavigationDrawerWidget(id: widget.id,nom: widget.nom,prenom: widget.prenom,photo:widget.photo),
    appBar: AppBar(
      backgroundColor: Colors.deepPurple[400],
      title: Text(MyApp.title),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed:(){
            Navigator.push(context, MaterialPageRoute(
                builder: (context)=>chercher(id:widget.id,)
            ));
          },
          icon: const Icon(Icons.search),
        ),
      ],
    ),
    body: Container(


      child:LiquidPullToRefresh(
        onRefresh:()async{
          setState(() {
            readData();
          });
            return await Future.delayed(Duration(seconds: 2));
      },
        height: 90,
        backgroundColor: Colors.red,
        color: Colors.white,
        animSpeedFactor: 3,
        showChildOpacityTransition: false,
        child: ListView(
          children: [

            FutureBuilder(
              future: readData(),
                builder: (BuildContext context,AsyncSnapshot<List<Map>> snapshot){
              if(snapshot.hasData){
                  return SingleChildScrollView(
                    child: RefreshIndicator(
                      backgroundColor: Colors.black38,
                      color: Colors.white,
                      strokeWidth: 4,
                      displacement: 0,
                      triggerMode: RefreshIndicatorTriggerMode.onEdge,
                      onRefresh: _refresh,
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                        physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (context,i){
                            test1=snapshot.data![i]['type'].toString();
                            snapshot.data![i]['urgent'] == 0 ? test2 = 0 : test2 = 1;
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
                                                    Navigator.push(context, MaterialPageRoute(
                                                        builder: (context)=>modifier(iduser:widget.id,id:snapshot.data![i]['id'],typ:snapshot.data![i]['type'],obj:snapshot.data![i]['objet'],exp:snapshot.data![i]['expiditeur'],des:snapshot.data![i]['destinataire'],dat:snapshot.data![i]['date'],tag:snapshot.data![i]['tags'],urg:snapshot.data![i]['urgent'] ,ph:snapshot.data![i]['photos'],)
                                                    ));

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
                                                        builder: (context)=>supprimer(id:snapshot.data![i]['id'] ,iduser:widget.id,)
                                                    ));
                                                  },
                                                ),
                                                IconSlideAction(
                                                  caption: 'archiver',
                                                  color: Colors.teal,
                                                  icon: Icons.folder,
                                                  onTap: ()async{
                                                    // Navigator.push(context, MaterialPageRoute(
                                                    //     builder: (context)=>supprimer(iduser:widget.id,typ:snapshot.data![i]['type'],obj:snapshot.data![i]['objet'],exp:snapshot.data![i]['expiditeur'],des:snapshot.data![i]['destinataire'],dat:snapshot.data![i]['date'],tag:snapshot.data![i]['tags'],urg:snapshot.data![i]['urgent'].toString(),ph:snapshot.data![i]['photos'],)
                                                    // ));
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
                                      builder: (context) => Details(id:widget.id,idcour:snapshot.data![i]['id'],typ:snapshot.data![i]['type'],obj:snapshot.data![i]['objet'],exp:snapshot.data![i]['expiditeur'],des:snapshot.data![i]['destinataire'],dat:snapshot.data![i]['date'],tag:snapshot.data![i]['tags'],urg:urgentm,ph:snapshot.data![i]['photos'],)));
                                },
                                  title: Text(
                                    "Objet: "+" ${snapshot.data![i]['objet']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      fontSize: 15,

                                    ),
                                  ),
                                  subtitle: Text(

                                      "à: "+"${snapshot.data![i]['destinataire']}"+"\nde: "+"${snapshot.data![i]['expiditeur']}",
                                    style: TextStyle(fontSize: 13),
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
                    ),
                  );
              }else{
                return Center(child: Text("aucun courrier n'est touvé"));
              }
            })
          ],
        ),
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
class search extends SearchDelegate {
  SqlDb sqlDb=new SqlDb();
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
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
  SqlDb sqlDb=SqlDb();
  Future<List<Map>> readData_search(String search) async{
    List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE objet like '%"+search+"%' OR expiditeur like '%"+search+"%' OR destinataire like '%"+search+"%' OR date like '%"+search+"%' OR tags like '%"+search+"%' AND archive=0");
    return response;
  }
  Future<List<Map>> readData_search_objet(String objet) async{
    List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE objet like '%"+objet+"%'");
    return response;
  }
  Future<List<Map>> readData_search_exp( String exp) async{
    List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE expiditeur like '%"+exp+"%'");
    return response;
  }
  Future<List<Map>> readData_search_dest(String dest) async{
    List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE destinataire like '%"+dest+"%'");
    return response;
  }
  Future<List<Map>> readData_search_tag(String tag) async{
    List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE tags like '%"+tag+"%'");
    return response;
  }
  Future<List<Map>> readData_search_date(String date) async{
    List<Map> response = await sqlDb.readData("SELECT * FROM courrier WHERE date like '%"+date+"%'");
    return response;
  }
  @override
  List <Widget> buildActions(BuildContext context) {
    SqlDb sqlDb =new SqlDb();
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
    for(var search in searchTerms){
      if(search.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(search);
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

