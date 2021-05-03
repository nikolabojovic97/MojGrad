class CyrillicConverter {

  static List<String> _cyrillic = ['А','а','Б','б','В','в','Г','г','Д','д','Ђ','ђ','Е','е','Ж','ж','З','з','И','и',
                                    'Ј','ј','К','к','Л','л','Љ','љ', 'М', 'м','Н','н','Њ','Њ','О','о','П','п','Р','р',
                                    'С','с','Т','т','Ћ','ћ','У','у','Ф','ф','Х','х','Ц','ц','Ч','ч','Џ','џ','Ш','ш'];
  static List<String> _latin = ['A','a','B','b','V','v','G','g','D','d','Đ','đ','E','e','Ž','ž','Z','z','I','i',
                                    'J','j','K','k','L','l','Lj','lj', 'M', 'm','N','n','Nj','nj','O','o','P','p','R','r',
                                    'S','s','T','t','Ć','ć','U','u','F','f','H','h','C','c','Č','č','Dž','dž','Š','š'];

  static String convertCyrToLat(String cyr){
    var listCyr = cyr.runes.toList();
    String converted = "";

    for(var char in listCyr){
      var charPos = _cyrillic.indexOf(String.fromCharCode(char));

      if(charPos == -1)
        converted += String.fromCharCode(char);
      else 
        converted += _latin[charPos];
    }
    return converted;
  }
}