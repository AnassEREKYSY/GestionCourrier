class user{
  String? cin,nom,prenom,email,adresse,mot_de_passe,telephone;
  user(this.cin,this.nom,this.prenom,this.email,this.adresse,this.mot_de_passe
      ,this.telephone);

  Map <String, dynamic> toMap(){
    return {
      'cin':cin,
      'nom':nom,
      'prenom':prenom,
      'email':email,
      'adresse':adresse,
      'mot_de_passe':mot_de_passe,
      'telephone':telephone,
    };
  }
  factory user.fromMap(Map <String,dynamic> map)=> new user(
    map['cin'],
    map['nom'],
    map['prenom'],
    map['email'],
    map['adresse'],
    map['mot_de_passe'],
    map['telephone'],
  );
}