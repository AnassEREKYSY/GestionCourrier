import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:collapsible_navigation_drawer_example/SqlDb.dart';
import 'package:collapsible_navigation_drawer_example/page/chercher.dart';
import 'package:collapsible_navigation_drawer_example/page/loginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'acceuil.dart';
import 'archive.dart';

class Details extends StatefulWidget {
  String? typ,obj,exp,des,dat,ph,tag;
  int? urg,id,idcour,route;
  Details(
      {Key? key,
        this.id,
        this.idcour,
        this.typ,
        this.obj,
        this.des,
        this.exp,
        this.dat,
        this.tag,
        this.urg,
        this.ph,this.route}): super(key: key);
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  SqlDb sqlDb =new SqlDb();
  int activeIndex=0;
  final controller=CarouselController();
  List<String> images=[];
  List<String> ing=[];
  List<Image> imgs = [];
  List allFiles = [];
  late String base64;
  bool isLoading = false;
  Image picture=new Image(image: AssetImage('assets/images/image_doc1.png'));
  final UrlImages=[
    'assets/images/image_doc1.png',
  ];
  List<Map>? response;
  readData_courrier() async{
    setState(() {
      isLoading = true;
    });
    response = await sqlDb.readData("SELECT im1,im2,im3,im4,im5,im6,im7,im8,im9,im10 FROM photos WHERE id_courrier="+widget.idcour.toString());
   for(int i = 0;i<response!.length;i++) {
      for (int z = 0; z <= 9; z++) {
        int j = z + 1;
        if (response![i]['im$j'] != 'null') {
          Uint8List image = base64Decode(response![i]['im$j']);
          imgs.add(Image.memory(image));
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData_courrier();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.cyan[600],
        centerTitle: true,
        title: Row(
          children: [
            IconButton(
              onPressed:()async{
                List<Map> response=await sqlDb.user_readData("SELECT * FROM user WHERE id="+widget.id.toString());
                String? nom,prenom,photo;
                nom=response[0]['nom'].toString();
                prenom=response[0]['prenom'].toString();
                photo=response[0]['photo'].toString();

                if(widget.route==1){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context)=>chercher(id: widget.id)),ModalRoute.withName('/home'));
                }else if(widget.route==2){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context)=>Archive(id: widget.id,)),ModalRoute.withName('/archive'));
                }else{
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context)=>Acceuil(id: widget.id,nom: nom,prenom: prenom,photo: photo,)),ModalRoute.withName('/home'));
                }
              },
              icon: const Icon(Icons.arrow_back),
            ),
            SizedBox(width: 100,),
            Text('Courrier',style: TextStyle(fontSize: 25),),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child:  Column(
          children: [
                SizedBox(height: 30,),
                CarouselSlider.builder(
                  carouselController: controller,
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    // viewportFraction: 1,
                      height: 240,
                    autoPlayInterval:Duration(seconds: 2),
                    onPageChanged: (index,reason)=>setState(()=>activeIndex=index),
                  ),
                  itemCount: imgs.isEmpty?UrlImages.length:imgs.length,
                  itemBuilder: (context,index,realIndex) {
                   return  imgs.isEmpty?builImage(picture):builImage(imgs[index]);
                  },
                ),
                SizedBox(height: 22,),
                buildIndicator(),
                Container(
                  margin: EdgeInsets.only(right: 18, left: 18),
                  child: Column(
                    children: [
                      SizedBox(height: 40,),
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: widget.typ.toString(),
                                prefixIcon: Icon(
                                  Icons.height,
                                  color: widget.typ.toString()=='Entrant'?Colors.green:Colors.red,
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
                              decoration: InputDecoration(
                                hintText: widget.obj==null?"--aucune objet--":widget.obj.toString(),
                                prefixIcon: Icon(
                                  Icons.message,
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
                              decoration: InputDecoration(
                                hintText: widget.exp==null?"--aucune expiditeur--":widget.exp.toString(),
                                prefixIcon: Icon(
                                  Icons.account_circle_outlined,
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
                              decoration: InputDecoration(
                                hintText: widget.des==null?"--aucune destinataire--":widget.des.toString(),
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
                              decoration: InputDecoration(
                                hintText: widget.dat==null?"--aucune date--":widget.dat.toString(),
                                prefixIcon: Icon(
                                  Icons.calendar_month,
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
                              decoration: InputDecoration(
                                hintText: widget.tag==null?"--aucun tag--":widget.tag.toString(),
                                prefixIcon: Icon(
                                  Icons.tag,
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
                              decoration: InputDecoration(
                                hintText: widget.urg==0?"--n'est pas urgent--":"--c'est urgent--",
                                prefixIcon: Icon(
                                  Icons.whatshot_rounded,
                                  color: widget.urg==0?Colors.grey:Colors.red,
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
                            RaisedButton(
                              child: Text(
                                'Retouner',
                                style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: Colors.grey[100],
                              onPressed: () async{
                                List<Map> response = await sqlDb.readData("SELECT im1,im2,im3,im4,im5,im6,im7,im8,im9,im10 FROM photos WHERE id_courrier="+widget.idcour.toString());
                                List<Map> reponse1=await sqlDb.user_readData('SELECT * FROM user WHERE id='+widget.id.toString());
                                String? nom,prenom,photo;
                                nom=reponse1[0]['nom'].toString();
                                prenom=reponse1[0]['prenom'].toString();
                                photo=reponse1[0]['photo'].toString();

                                if(widget.route==1){
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                      builder: (context)=>chercher(id: widget.id)),ModalRoute.withName('/home'));
                                }else if(widget.route==2){
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                      builder: (context)=>Archive(id: widget.id,)),ModalRoute.withName('/archive'));
                                }else{
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                      builder: (context)=>Acceuil(id: widget.id,nom: nom,prenom: prenom,photo: photo,)),ModalRoute.withName('/home'));
                                }

                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 80,),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget builImage(Image urlImage) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        color: Colors.grey,
        child: urlImage,

      );
  }

 Widget buildIndicator()=> AnimatedSmoothIndicator(
   activeIndex:activeIndex,
   count:imgs.length==0?UrlImages.length:imgs.length,
   onDotClicked: animateToSlide,
   effect: JumpingDotEffect(
     dotHeight: 20,
     dotWidth: 20,
     activeDotColor: Colors.red,
     dotColor: Colors.black12,
   ),
 );
 void animateToSlide(int index)=>controller.animateToPage(index);
}