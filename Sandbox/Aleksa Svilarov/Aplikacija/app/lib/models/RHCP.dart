class RHCP{
  int id;
  String naziv;
  String album;
  int godina;
  int trajanje;

  RHCP({this.naziv, this.album, this.godina, this.trajanje});
  /*
  int get _id => id;
  String get _naziv => naziv;
  String get _album => album;
  int get _godina => godina;
  int get _trajanje => trajanje;
*/
  factory RHCP.fromJson(Map<String, dynamic> json){
    return RHCP(
      naziv: json['naziv'],
      album: json['album'],
      godina: json['godina'],
      trajanje: json['trajanje']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["naziv"] = naziv;
    map["album"] = album;
    map["godina"] = godina;
    map["trajanje"] = trajanje;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  RHCP.fromObject(dynamic o){
    this.id = o["id"];
    this.naziv = o["naziv"];
    this.album = o["album"];
    this.godina = o["godina"];
    this.trajanje = o["trajanje"];
  }

}