// import 'package:collapsible_navigation_drawer_example/page/modifier.dart';
// import 'package:collapsible_navigation_drawer_example/page/supprimer.dart';
// import 'package:collapsible_navigation_drawer_example/provider/navigation_provider.dart';
// import 'package:collapsible_navigation_drawer_example/widget/navigation_drawer_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
//
// import '../model/Listview.dart';
// import '../model/slidable_action.dart';
//
// Future main() async {
//
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   static final String title = 'Courrier';
//
//
//   @override
//   Widget build(BuildContext context) => ChangeNotifierProvider(
//     create: (context) => NavigationProvider(),
//     child: MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: title,
//       theme: ThemeData(primarySwatch: Colors.deepOrange),
//       home: MainPage(),
//     ),
//   );
// }
//
// class MainPage extends StatefulWidget {
//   @override
//   _MainPageState createState() => _MainPageState();
//
// }
//
// class _MainPageState extends State<MainPage> {
//   int index = 0;
//   List <Listview> liste=[
//     Listview('objet', 'destinataire', 'expiditeur', 'date', Icon(Icons.arrow_circle_down_rounded, color: Colors.green,size:35 ,), Icon(Icons.warning, color: Colors.red,size:25 ,)),
//     Listview('objet', 'destinataire', 'expiditeur', 'date', Icon(Icons.arrow_circle_up_rounded, color: Colors.red,size:35 ,), Icon(Icons.warning, color: Colors.red,size:25 ,)),
//     Listview('objet', 'destinataire', 'expiditeur', 'date', Icon(Icons.arrow_circle_down_rounded, color: Colors.green,size:35 ,), Icon(Icons.warning, color: Colors.red,size:25 ,)),
//     Listview('objet', 'destinataire', 'expiditeur', 'date', Icon(Icons.arrow_circle_up_rounded, color: Colors.red,size:35 ,), Icon(Icons.warning, color: Colors.red,size:25 ,)),
//     Listview('objet', 'destinataire', 'expiditeur', 'date', Icon(Icons.arrow_circle_down_rounded, color: Colors.green,size:35 ,), Icon(Icons.warning, color: Colors.red,size:25 ,)),
//     Listview('objet', 'destinataire', 'expiditeur', 'date', Icon(Icons.arrow_circle_up_rounded, color: Colors.red,size:35 ,), Icon(Icons.warning, color: Colors.red,size:25 ,)),
//     Listview('objet', 'destinataire', 'expiditeur', 'date', Icon(Icons.arrow_circle_down_rounded, color: Colors.green,size:35 ,), Icon(Icons.warning, color: Colors.red,size:25 ,)),
//     Listview('objet', 'destinataire', 'expiditeur', 'date', Icon(Icons.arrow_circle_up_rounded, color: Colors.red,size:35 ,), Icon(Icons.warning, color: Colors.red,size:25 ,)),
//     Listview('objet', 'destinataire', 'expiditeur', 'date', Icon(Icons.arrow_circle_down_rounded, color: Colors.green,size:35 ,), Icon(Icons.warning, color: Colors.red,size:25 ,)),
//     Listview('objet', 'destinataire', 'expiditeur', 'date', Icon(Icons.arrow_circle_up_rounded, color: Colors.red,size:35 ,), Icon(Icons.warning, color: Colors.red,size:25 ,)),
//   ];
//   Widget buildVerticalListView()=> ListView.builder(
//     padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
//     itemCount:liste.length,
//     itemBuilder: (context,index){
//       return Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(90),
//               topRight: Radius.circular(90),
//               bottomLeft: Radius.circular(90),
//               bottomRight: Radius.circular(90)
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1,
//               blurRadius: 15,
//               offset: Offset(7, 0), // changes position of shadow
//             ),
//           ],
//         ),
//         height: 80,
//         child: Slidable(
//           key: Key(liste.elementAt(index).objet),
//           dismissal: SlidableDismissal(
//             child: SlidableDrawerDismissal(),
//             onDismissed: (type){
//               final action=type==SlideActionType.primary ? SlidableAction.modifier:SlidableAction.supprimer;
//               onDismissed(index, action);
//             },
//           ),
//           actionPane: SlidableDrawerActionPane(),
//           actionExtentRatio: 0.25,
//           actions: [
//             IconSlideAction(
//               caption: 'Modifier',
//               color: Colors.blue,
//               icon: Icons.edit,
//               onTap: ()=>onDismissed(index,SlidableAction.modifier),
//             ),
//           ],
//           secondaryActions: [
//             IconSlideAction(
//               caption: 'supprimer',
//               color: Colors.red,
//               icon: Icons.delete,
//               onTap: ()=>onDismissed(index,SlidableAction.supprimer),
//             ),
//           ],
//           child: Card(
//             child: Builder(
//                 builder: (context) {
//                   return ListTile(
//                     onTap: (){
//                       final slidable=Slidable.of(context)!;
//                       final isClosed=slidable.renderingMode==SlidableRenderingMode.none;
//                       if(isClosed){
//                         slidable.open();
//                       }else{
//                         slidable.close();
//                       }
//                     },
//                     title: Text(liste[index].objet),
//                     subtitle: Text('à:'+liste[index].destinataire+' '+liste[index].date+'$index'),
//                     leading: CircleAvatar(
//                       child: liste[index].imageetat,
//                       backgroundColor: Colors.white,
//                     ),
//                     trailing: CircleAvatar(
//                       child: liste[index].urgent,
//                       backgroundColor: Colors.white,
//                     ),
//                   );
//                 }
//             ),
//           ),
//         ),
//       );
//     },
//   );
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     drawer: NavigationDrawerWidget(),
//     appBar: AppBar(
//       backgroundColor: Colors.grey[700],
//       title: Text(MyApp.title),
//       centerTitle: true,
//       actions: [
//         IconButton(
//           onPressed:(){
//             showSearch(
//               context: context, delegate: CustomSearchDelegate(),
//             );
//           },
//           icon: const Icon(Icons.search),
//         ),
//       ],
//     ),
//     body: Container(
//       child:Column(
//         children: [
//           Expanded(child: buildVerticalListView(),),
//         ],
//       ),
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//       ),
//     ),
//   );
//
//   void onDismissed(int index, SlidableAction action) {
//     final item=liste[index];
//     if(action==SlidableAction.modifier){
//       Navigator.push(context, MaterialPageRoute(builder: (context)=>modifier()));
//     }else{
//       Navigator.push(context, MaterialPageRoute(builder: (context)=>supprimer()));
//       // setState(()=>liste.removeAt(index));
//     }
//     // switch(action){
//     //   case SlidableAction.modifier:
//     //     Utils.showSnackBar(context,'{$item.objet} est modifier');
//     //     break;
//     //   case SlidableAction.supprimer:
//     //     Utils.showSnackBar(context,'{$item.objet} est supprimer');
//     //     break;
//     // }
//   }
// }
//
// class CustomSearchDelegate extends SearchDelegate{
//   List <String> searchTerms=[
//     'Applle',
//     'Banana',
//     'Pear',
//     'Oranges',
//     'Buleberries',
//     'Strawberries',
//     'Watermelons',
//   ];
//
//   @override
//   List <Widget> buildActions(BuildContext context){
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: (){
//           query='';
//         },
//       ),
//     ];
//     //   [
//     //     Expanded(
//     //       child: Container(
//     //           height: 80,
//     //           padding: EdgeInsets.only(top: 35,left: 15,right: 5,bottom: 5),
//     //           width: double.infinity,
//     //           child: TextField(
//     //             controller: controller,
//     //             decoration: InputDecoration(
//     //               filled: true,
//     //               fillColor: Colors.white,
//     //               labelText: 'Search Something',
//     //               contentPadding: EdgeInsets.all(100),
//     //               focusedBorder:  OutlineInputBorder(
//     //                 borderRadius: BorderRadius.circular(25.7),
//     //                 borderSide: BorderSide(color: Colors.white),
//     //               ),
//     //               enabledBorder: UnderlineInputBorder(
//     //                 borderRadius: BorderRadius.circular(25.7),
//     //                 borderSide: BorderSide(color: Colors.white),
//     //               ),
//     //
//     //             ),
//     //           )
//     //       ),
//     //     ),
//     //     Container(
//     //       height: 80,
//     //       padding: EdgeInsets.only(top: 25,right: 15),
//     //       child: Icon(Icons.search),
//     //     ),
//     //     Expanded(child: ListView.builder(
//     //       itemCount: searchTerms.length,
//     //       itemBuilder: (context,index) {
//     //         return searchTerms[index].toLowerCase().contains(filter.toLowerCase()) ? Text(searchTerms[index]) : SizedBox.shrink();
//     //       },
//     //     )),
//     //   ];
//   }
//   @override
//   Widget buildLeading(BuildContext context){
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: (){
//         close(context,null);
//       },
//     );
//   }
//   @override
//   Widget buildResults(BuildContext context){
//     List <String> matchQuery=[];
//     for(var fruits in searchTerms){
//       if(fruits.toLowerCase().contains(query.toLowerCase())){
//         matchQuery.add(fruits);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context,index) {
//         var result=matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }
//   @override
//   Widget buildSuggestions(BuildContext context){
//     List <String> matchQuery=[];
//     for(var fruits in searchTerms){
//       if(fruits.toLowerCase().contains(query.toLowerCase())){
//         matchQuery.add(fruits);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context,index) {
//         var result=matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }
// }
//
//
//
//
//
//
//
