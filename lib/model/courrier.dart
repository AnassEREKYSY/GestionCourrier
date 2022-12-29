class courrier{
  late String objet;
  late String type;
  late String destinataire;
  late String expiditeur;
  late String date;
  late bool urgent;
  late String photos;
  late String tags;
  courrier(this.type,this.objet,this.expiditeur,this.destinataire,this.date
      ,this.tags,this.urgent,this.photos);

  Map <String, dynamic> toMap(){
    return {
      'type':type,
      'objet':objet,
      'expiditeur':expiditeur,
      'destinataire':destinataire,
      'date':date,
      'tags':tags,
      'urgent':urgent,
      'photos':photos,
    };
  }
  factory courrier.fromMap(Map <String,dynamic> map)=> new courrier(
    map['type'],
    map['objet'],
    map['expiditeur'],
    map['destinataire'],
    map['date'],
    map['tags'],
    map['urgent'],
    map['photos'],
  );
}