class Knjige {
  int id;
  String autor;
  String naslov;
  String zanr;

  Knjige(autor, naslov, zanr) {
    this.autor = autor;
    this.naslov = naslov;
    this.zanr = zanr;
  }

  Knjige.id(id, autor, naslov, zanr) {
    this.id = id;
    this.autor = autor;
    this.naslov = naslov;
    this.zanr = zanr;
  }

Map<String,dynamic> toMap()
{
  var map = Map<String,dynamic>();
  map['id'] = id;
  map['autor'] = autor;
  map['naslov'] = naslov;
  map['zanr'] = zanr;
}

Knjige.fromObject(dynamic o)
{
  this.id = o['id'];
  this.autor = o['autor'];
  this.naslov = o['naslov'];
  this.zanr = o['zanr'];
}
}