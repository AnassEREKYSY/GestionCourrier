import 'dart:convert';
import 'dart:typed_data';

import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../SqlDb.dart';
import '../widget/navigation_drawer_widget.dart';

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../provider/navigation_provider.dart';
import '../widget/navigation_drawer_widget.dart';
import '../widget/navigation_drawer_widget.dart';
import 'acceuil.dart';
import 'chercher.dart';


class  modifier  extends StatefulWidget {
  String? typ,obj,exp,des,dat,ph,tag;
  int? urg,id,iduser,route;
  modifier(
      {Key? key,
        this.iduser,
        this.id,
        this.typ,
        this.obj,
        this.des,
        this.exp,
        this.dat,
        this.tag,
        this.urg,
        this.ph,this.route}): super(key: key);

  @override
  State<modifier> createState() => _modifierState();
}

class _modifierState extends State<modifier> {
  String? typ1,obj1,exp1,des1,dat1,ph1,tag1,photo_test;
  int? urg1;
  File? file;
  SqlDb sqlDb=SqlDb();
  String? value1,valeur;
  late DateTime dateTime=new DateTime.now();
  TextEditingController _objetController = new TextEditingController();
  TextEditingController _destinataireController = new TextEditingController();
  TextEditingController _expediteurController = new TextEditingController();
  TextEditingController _tagsController = new TextEditingController();
  final multiplePicker=ImagePicker();
  List<XFile> images=[];
  List<String> images1=[];
  String? im1,im2,im3,im4,im5,im6,im7,im8,im9,im10;
  @override
  int activeIndex=0;
  final controller=CarouselController();
  final UrlImages=[
    'assets/images/image_doc1.png',
  ];
  Image picture=new Image(image: AssetImage('assets/images/image_doc1.png'));
  List<Image> imgs = [];
  bool isLoading = false;
  List<Map>? response;
  readData_courrier() async{
    setState(() {
      isLoading = true;
    });
    response = await sqlDb.readData("SELECT im1,im2,im3,im4,im5,im6,im7,im8,im9,im10 FROM photos WHERE id_courrier="+widget.id.toString());
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
  void initState(){
    // TODO: implement initState
    super.initState();
    readData_courrier();
    _objetController.text=widget.obj.toString();
    dat1=widget.dat;
    obj1=widget.obj;
    if(widget.typ == 'Sortant'){
      valeur = 'Sortant';
    }
    else{
      valeur = 'Entrant';
    }
    if(widget.urg == 1){
      value1='Urgent';
    }
    else{
      value1 = 'Non Urgent';
    }
  }
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool? isurgent=true;
    bool? isnturgent=false;
    bool? checkBoxValue=false;
    final items=['Sortant','Entrant'];
    final items1=['Urgent','Non Urgent'];
    int index_courrant;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[300],
        title:Row(
          children: [
            IconButton(
                onPressed: ()async{
                  List<Map> response2=await sqlDb.user_readData("SELECT * FROM user WHERE id="+widget.iduser.toString());
                  String? nom,prenom,photo;
                  nom=response2[0]['nom'].toString();
                  prenom=response2[0]['prenom'].toString();
                  photo=response2[0]['photo'].toString();

                  if(widget.route==1){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context)=>chercher(id: widget.iduser)),ModalRoute.withName('/home'));
                  }else{
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context)=>Acceuil(id: widget.iduser,nom: nom,prenom: prenom,photo: photo,)),ModalRoute.withName('/home'));
                  }

                },
                icon: Icon(Icons.arrow_back, size: 30,)),
            SizedBox(width: 100,),
            Text('Courrier',style: TextStyle(fontSize: 25),),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.edit,color: Colors.blue[500],size: 30,),
                    Text(
                      'Modifier un courrier',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30,),
            CarouselSlider.builder(
              carouselController: controller,
              options: CarouselOptions(
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                // viewportFraction: 1,
                height: 240,
                // autoPlay: true,
                // reverse: true,
                autoPlayInterval:Duration(seconds: 2),
                onPageChanged: (index,reason)=>setState(()=>activeIndex=index),
              ),
              itemCount: imgs.isEmpty?UrlImages.length:imgs.length,
              itemBuilder: (context,index,realIndex) {
                return  imgs.isEmpty?builImage(picture,0):builImage(imgs[index],index);
              },
            ),
            SizedBox(height: 22,),
            buildIndicator(),
            Container(
              margin: EdgeInsets.only(top:15,right: 18,left: 18),
              child: Column(
                children: [
                  SizedBox(height: 10,),
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
                                  //hint: widget.typ.toString().compareTo('Sortant')==0?Text("Sortant"):Text("Entrant"),
                                  value: valeur,
                                  isExpanded: true,
                                  iconSize: 36,
                                  icon: Icon(Icons.arrow_drop_down,color: Colors.black,),
                                  // items: items.map(buildMenuItem).toList(),
                                  onChanged: (value){
                                    setState(() {
                                      valeur = value as String;
                                    });
                                  },
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
                                  value: value1,
                                  iconSize: 36,
                                  icon: Icon(Icons.arrow_drop_down,color: Colors.black,),
                                  onChanged: (value){
                                    setState(() {
                                      value1 = value as String;
                                    });
                                  },
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
                                  color: Colors.blue[300],
                                  onPressed: ()async {
                                    List<Map> response=await sqlDb.user_readData("SELECT * FROM user WHERE id="+widget.iduser.toString());
                                    String? nom,prenom,photo;
                                    nom=response[0]['nom'].toString();
                                    prenom=response[0]['prenom'].toString();
                                    photo=response[0]['photo'].toString();

                                    if(widget.route==1){
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                          builder: (context)=>chercher(id: widget.iduser)),ModalRoute.withName('/home'));
                                    }else{
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                          builder: (context)=>Acceuil(id: widget.iduser,nom: nom,prenom: prenom,photo: photo,)),ModalRoute.withName('/home'));
                                    }

                                  }
                              ),
                              SizedBox(width: 20,),
                              RaisedButton(
                                child: Text(
                                  'Modifier',
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
                                color: Colors.blue[300],
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

                                  _objetController.text!=widget.obj.toString()?obj1 =_objetController.text:obj1 =widget.obj;
                                  des1 = _destinataireController.text.isEmpty?widget.des.toString():_destinataireController.text;
                                  exp1 = _expediteurController.text.isEmpty?widget.exp.toString():_expediteurController.text;
                                  tag1 = _tagsController.text.isEmpty?widget.tag.toString():_tagsController.text;
                                  if(value1=='Non Urgent' || value1==null ){
                                    urg1=0;
                                  }else{
                                    urg1=1;
                                  }
                                  var formdata=formKey.currentState;
                                  if (formdata!.validate()) {
                                    formdata.save();
                                  }
                                  int response=await sqlDb.updateData('UPDATE courrier SET type="'+valeur.toString()+'",objet="'+obj1.toString()+'",expiditeur="'+exp1.toString()+'",destinataire="'+des1.toString()+'",date="'+dat1.toString()+'",tags="'+tag1.toString()+'",urgent='+urg1.toString()+' WHERE id='+widget.id.toString());
                                  if(response!=0){
                                    if(images1.isNotEmpty){
                                      int response=await sqlDb.insertData("INSERT INTO photos(id_courrier,im1,im2,im3,im4,im5,im6,im7,im8,im9,im10) values("+widget.id.toString()+",'"+im1.toString()+"','"+im2.toString()+"','"+im3.toString()+"','"+im4.toString()+"','"+im5.toString()+"','"+im6.toString()+"','"+im7.toString()+"','"+im8.toString()+"','"+im9.toString()+"','"+im10.toString()+"')") as int;
                                    }
                                    List<Map> response1= await sqlDb.readData("SELECT * FROM courrier");
                                    List<Map> response2=await sqlDb.user_readData("SELECT * FROM user WHERE id="+widget.iduser.toString());
                                    String? nom,prenom,photo;
                                    nom=response2[0]['nom'].toString();
                                    prenom=response2[0]['prenom'].toString();
                                    photo=response2[0]['photo'].toString();
                                    List<Map> response4=await sqlDb.user_readData("SELECT * FROM photos WHERE id_courrier="+widget.id.toString());
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
                                    if(widget.route==1){
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                          builder: (context)=>chercher(id: widget.iduser)),ModalRoute.withName('/home'));
                                    }else{
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                          builder: (context)=>Acceuil(id: widget.iduser,nom: nom,prenom: prenom,photo: photo,)),ModalRoute.withName('/home'));
                                    }
                                  }else{
                                    AchievementView(
                                      context,
                                      title: "Erreur!",
                                      subTitle: "Erreur lors de la modification!",
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
                          SizedBox(height: 15,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
      // initialValue: widget.des.toString(),
      controller: _destinataireController,
      decoration: InputDecoration(
        hintText: widget.des.toString().isEmpty?'--aucun destinataire':widget.des.toString(),
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
        hintText: widget.exp.toString().isEmpty?'--aucun expiditeur':widget.exp.toString(),
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
  Widget _buildDate_picker(){
    return Container(
      child: RaisedButton(
        child: Icon(Icons.calendar_month,size: 30,),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.grey[100],
        onPressed: (){
          showDatePicker(
            context: context,
            initialDate:dateTime,
            firstDate: DateTime(2001),
            lastDate: DateTime(2030),
          ).then((date){
            date==null?dat1=widget.dat:dat1=date.toString();
          });
        },),
    );
  }
  Widget _buildTags(){
    return TextFormField(
      controller: _tagsController,
      decoration: InputDecoration(
        hintText: widget.tag.toString().isEmpty?'--aucun tags':widget.tag.toString(),
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
    photo_test=widget.ph;
    setState(() {
      file=File(myfile!.path.split("/").last);
      String filetest=file.toString();
      String fileSplit=filetest.split(' ').last;
      fileSplit==null?ph1=widget.ph:ph1=fileSplit;
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
        hintText: widget.obj.toString().isEmpty?'--aucun objet--':widget.obj.toString(),
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
      onSaved: (value){
        value==widget.obj?obj1=widget.obj.toString():obj1=value.toString();
      },
    );
  }
}









