import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collapsible_navigation_drawer_example/page/acceuil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../SqlDb.dart';
import '../main.dart';
import '../model/CourrierDataBase.dart';
import '../model/courrier.dart';
import '../provider/navigation_provider.dart';
import '../widget/navigation_drawer_widget.dart';
import '../widget/navigation_drawer_widget.dart';


class Ajouter extends StatefulWidget {
  String? objet,expiditeur,destinataire,date,tags,photos,type;
  int? id,urgent;
  Ajouter({Key? key, this.id,}): super(key: key);

  @override
  State<Ajouter> createState() => _AjouterState();
}

class _AjouterState extends State<Ajouter> {
  Image picture=new Image(image: AssetImage('assets/images/image_doc1.png'));
  List<Image> imgs = [];
  int activeIndex=0;
  final UrlImages=[
    'assets/images/image_doc1.png',
  ];
  final controller=CarouselController();
  late File file;
  SqlDb sqlDb=SqlDb();
  late DateTime dateTime= DateTime.now();
  late courrier cour;
  final items=['Sortant','Entrant'];
  final items1=['Urgent','Non Urgent'];
  String? value,value1;
  TextEditingController _objetController = new TextEditingController();
  TextEditingController _destinataireController = new TextEditingController();
  TextEditingController _expediteurController = new TextEditingController();
  TextEditingController _tagsController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  final multiplePicker=ImagePicker();
  List<XFile> images=[];
  List<String> images1=[];
  String? im1,im2,im3,im4,im5,im6,im7,im8,im9,im10;
  int? idc;
  @override
  Widget build(BuildContext context) {


    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    bool? checkBoxValue=false;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal[300],
        title:Row(
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
            SizedBox(width: 100,),
            Text('Courrier',style: TextStyle(fontSize: 25),),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top:20,right: 18,left: 18),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Row(
                    children: [
                      Icon(Icons.add, size: 30,color: Colors.teal[500],),
                      Text(
                          'Ajouter un courrier',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.teal[500],
                          ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
              imgs.length==0?Column():CarouselSlider.builder(
                carouselController: controller,
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  height: 240,
                  autoPlayInterval:Duration(seconds: 2),
                  onPageChanged: (index,reason)=>setState(()=>activeIndex=index),
                ),
                itemCount: imgs.isEmpty?UrlImages.length:imgs.length,
                itemBuilder: (context,index,realIndex) {
                  return builImage(imgs[index],index);
                },
              ),
              SizedBox(height: 40,),
              Form(
                key: formKey,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      Container(
                        width: 400,
                        margin: EdgeInsets.all(3),
                        padding:EdgeInsets.symmetric(horizontal: 12),
                        decoration:BoxDecoration(
                          border: Border.all(color: Colors.black38,width: 1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: Text('Type'),
                            value: value,
                              isExpanded: true,
                              iconSize: 36,
                              icon: Icon(Icons.arrow_drop_down,color: Colors.black,),
                              onChanged: (value)=>setState((){
                                this.value=value as String?;
                                value.toString().isEmpty?widget.type='Entrant':widget.type=value!;
                              }),
                              items: items.map<DropdownMenuItem<String> >(
                                      (String item){
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item.toString()),
                                    );
                                  }
                              ).toList()
                          ),
                        ),
                      ),
                      SizedBox(height: 13,),
                      _buildObjet(),
                      SizedBox(height: 13,),
                      _buildDestinataire(),
                      SizedBox(height: 13,),
                      _buildExpiditeur(),
                      SizedBox(height: 13,),
                      _buildTags(),
                      SizedBox(height: 13,),
                      Container(
                        width: 400,
                        margin: EdgeInsets.all(3),
                        padding:EdgeInsets.symmetric(horizontal: 12),
                        decoration:BoxDecoration(
                          border: Border.all(color: Colors.black38,width: 1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              hint: Text('Urgent/ Non Urgent'),
                              value: value1,
                              isExpanded: true,
                              iconSize: 36,
                              icon: Icon(Icons.arrow_drop_down,color: Colors.black,),
                              // items: items.map(buildMenuItem).toList(),
                              onChanged: (value)=>setState((){
                                this.value1=value as String?;
                                if(this.value1.toString().isNotEmpty){
                                  this.value1=='Urgent'?widget.urgent=1:widget.urgent=0;
                                }else{
                                  widget.urgent=0;
                                }
                              }),
                              items: items1.map<DropdownMenuItem<String> >(
                                      (String item){
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item.toString()),
                                    );
                                  }
                              ).toList()
                          ),
                        ),
                      ),
                      SizedBox(height: 13,),
                      _buildDate_picker(),
                      SizedBox(height: 13,),
                      Row(
                        children: [
                          SizedBox(width: 115,),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.amberAccent,
                              border: Border.all(color: Colors.amberAccent,width: 3),
                            ),
                            width: 70,
                            height: 65,
                            child:  IconButton(
                              icon: const Icon(Icons.camera_alt),
                              iconSize: 44,
                              highlightColor: Colors.amberAccent,
                              color: Colors.white,

                              onPressed: (){
                                _getFromCamera();
                              },
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.lime,
                              border: Border.all(color: Colors.lime,width: 3),
                            ),
                            width: 70,
                            height: 65,
                            child:  IconButton(
                              icon: const Icon(Icons.add_photo_alternate_rounded),
                              iconSize: 44,
                              highlightColor: Colors.lime,
                              color: Colors.white,

                              onPressed: (){
                                getMultipleImage();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        children: [
                          SizedBox(width: 75,),
                          RaisedButton(
                              child: Text(
                                'Annuler',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              color: Colors.teal[200],
                              onPressed: () async{
                                List<Map> response=await sqlDb.user_readData("SELECT * FROM user WHERE id="+widget.id.toString());
                                String? nom,prenom,photo;
                                nom=response[0]['nom'].toString();
                                prenom=response[0]['prenom'].toString();
                                photo=response[0]['photo'].toString();
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                    builder: (context)=>Acceuil(id: widget.id,nom: nom,prenom: prenom,photo: photo,)),ModalRoute.withName('/home'));
                              }
                          ),
                          SizedBox(width: 20,),
                          MaterialButton(
                            child:Text(
                              ' Ajouter ',
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
                            color: Colors.teal[200],
                            onPressed: ()async{
                              if(images1.isNotEmpty){
                               if(images1.length==1){
                                 im1=images1[0].toString();
                                 im2=im3=im4=im5=im6=im7=im8=im9=im10=null;
                               }else if(images1.length==2){
                                 im1=images1[0].toString();
                                 im2=images1[1].toString();
                                 im3=im4=im5=im6=im7=im8=im9=im10=null;
                               }
                               else if(images1.length==3){
                                 im1=images1[0].toString();
                                 im2=images1[1].toString();
                                 im3=images1[2].toString();
                                 im4=im5=im6=im7=im8=im9=im10=null;
                               }
                               else if(images1.length==4){
                                 im1=images1[0].toString();
                                 im2=images1[1].toString();
                                 im3=images1[2].toString();
                                 im4=images1[3].toString();
                                 im5=im6=im7=im8=im9=im10=null;
                               }
                               else if(images1.length==5){
                                 im1=images1[0].toString();
                                 im2=images1[1].toString();
                                 im3=images1[2].toString();
                                 im4=images1[3].toString();
                                 im5=images1[4].toString();
                                 im6=im7=im8=im9=im10=null;
                               }
                               else if(images1.length==6){
                                 im1=images1[0].toString();
                                 im2=images1[1].toString();
                                 im3=images1[2].toString();
                                 im4=images1[3].toString();
                                 im5=images1[4].toString();
                                 im6=images1[5].toString();
                                 im7=im8=im9=im10=null;
                               }
                               else if(images1.length==7){
                                 im1=images1[0].toString();
                                 im2=images1[1].toString();
                                 im3=images1[2].toString();
                                 im4=images1[3].toString();
                                 im5=images1[4].toString();
                                 im6=images1[5].toString();
                                 im7=images1[6].toString();
                                 im8=im9=im10=null;
                               }
                               else if(images1.length==8){
                                 im1=images1[0].toString();
                                 im2=images1[1].toString();
                                 im3=images1[2].toString();
                                 im4=images1[3].toString();
                                 im5=images1[4].toString();
                                 im6=images1[5].toString();
                                 im7=images1[6].toString();
                                 im8=images1[7].toString();
                                 im9=im10=null;
                               }
                               else if(images1.length==9){
                                 im1=images1[0].toString();
                                 im2=images1[1].toString();
                                 im3=images1[2].toString();
                                 im4=images1[3].toString();
                                 im5=images1[4].toString();
                                 im6=images1[5].toString();
                                 im7=images1[6].toString();
                                 im8=images1[7].toString();
                                 im9=images1[8].toString();
                                 im10=null;
                               }
                               else if(images1.length==10){
                                 im1=images1[0].toString();
                                 im2=images1[1].toString();
                                 im3=images1[2].toString();
                                 im4=images1[3].toString();
                                 im5=images1[4].toString();
                                 im6=images1[5].toString();
                                 im7=images1[6].toString();
                                 im8=images1[7].toString();
                                 im9=images1[8].toString();
                                 im10=images1[9].toString();
                               }
                              }else{
                                im1=im2=im3=im4=im5=im6=im7=im8=im9=im10=null;
                              }
                              int urg;
                              widget.urgent==null?urg=0:urg=1;
                              widget.objet = _objetController.text;
                              widget.destinataire = _destinataireController.text;
                              widget.expiditeur = _expediteurController.text;
                              widget.tags = _tagsController.text;
                              var formdata=formKey.currentState;
                                  if (formdata!.validate()) {
                                    formdata.save();
                                  }
                              int response=await sqlDb.insertData("INSERT INTO courrier(id_user,type,objet,expiditeur,destinataire,date,tags,urgent,photos,archive) values("+widget.id.toString()+",'"+widget.type.toString()+"','"+widget.objet.toString()+"','"+widget.expiditeur.toString()+"','"+widget.destinataire.toString()+"','"+widget.date.toString()+"','"+widget.tags.toString()+"',"+urg.toString()+","+widget.photos.toString()+",0)") as int;
                                  if(response!=0){
                                      List<Map> response1= await sqlDb.readData("SELECT MAX(id) as MAX FROM courrier WHERE id_user="+widget.id.toString());
                                      if(response1.isNotEmpty){
                                        idc=response1[0]['Max'];
                                        List<Map> response2=await sqlDb.user_readData("SELECT * FROM user WHERE id="+widget.id.toString());
                                        int response=await sqlDb.insertData("INSERT INTO photos(id_courrier,im1,im2,im3,im4,im5,im6,im7,im8,im9,im10) values("+response1[0]['MAX'].toString()+",'"+im1.toString()+"','"+im2.toString()+"','"+im3.toString()+"','"+im4.toString()+"','"+im5.toString()+"','"+im6.toString()+"','"+im7.toString()+"','"+im8.toString()+"','"+im9.toString()+"','"+im10.toString()+"')") as int;
                                        String? nom,prenom,photo;
                                        nom=response2[0]['nom'].toString();
                                        prenom=response2[0]['prenom'].toString();
                                        photo=response2[0]['photo'].toString();
                                        AchievementView(
                                          context,
                                          title: "Succés!",
                                          subTitle: "Ajout avec succés!",
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
                                            builder: (context)=>Acceuil(id: widget.id,nom: nom,prenom: prenom,photo: photo,)),ModalRoute.withName('/home'));
                                      }
                                  }else{
                                          AchievementView(
                                            context,
                                            title: "Erreur!",
                                            subTitle: "Attention vérifier tous les champs!",
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
            ],
          ),
        ),
      ),
    );
  }
  Future getMultipleImage()async{
    String base64;
    final List<XFile>? selectedImages= await multiplePicker.pickMultiImage();
    setState(() {
      if(selectedImages!.isNotEmpty){
        images.addAll(selectedImages);
        for(var i=0;i<images.length;i++){
          base64=base64Encode(File(images[i].path).readAsBytesSync());
          images1.add(base64.toString());
          Uint8List image = base64Decode(base64);
          imgs.add(Image.memory(image));
        }
      }
    });
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
  Widget builImage(Image urlImage,int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white,
      child: Row(
        children: [
          Column(
            children: [
              IconButton(
                onPressed: (){
                  imgs.removeAt(index);
                  setState(() {
                    imgs=imgs;
                  });
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
          urlImage,
        ],
      ),

    );
  }
  Widget _buildDestinataire(){
    return TextFormField(
      controller: _destinataireController,
      decoration: InputDecoration(
        hintText: 'Destinataire',
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
    );
  }
  Widget _buildExpiditeur(){
    return TextFormField(
      controller: _expediteurController,
      decoration: InputDecoration(
        hintText: 'Expiditeur',
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
    );
  }
  Widget _buildDate_picker(){
    return Container(
      child: RaisedButton(
        child: Icon(Icons.calendar_month,size: 30,),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.grey[100],
        onPressed: () async{
          showDatePicker(
            context: context,
            initialDate:dateTime,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          ).then((date){
            widget.date=date.toString();

          });
        },
      ),
    );
  }
  Widget _buildTags(){
    return TextFormField(
      controller: _tagsController,
      decoration: InputDecoration(
        hintText: 'Tags',
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
    );
  }
  _getFromGallery() async {
    final myfile =await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      file=File(myfile!.path.split("/").last);
      String filetest=file.toString();
      widget.photos=filetest.split(' ').last;
    });
  }
  Future _getFromCamera() async {
    String base64;
    final myfile =await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      if(myfile!=null){
          base64=base64Encode(File(myfile.path).readAsBytesSync());
          images1.add(base64.toString());
          Uint8List image = base64Decode(base64);
          imgs.add(Image.memory(image));
        }
    });
  }
  Widget _buildObjet(){
    return TextFormField(
      controller: _objetController,
      decoration: InputDecoration(
        hintText: 'objet',
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
    );
  }
}






