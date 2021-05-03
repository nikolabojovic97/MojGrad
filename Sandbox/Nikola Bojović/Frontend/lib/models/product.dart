class Product {
  String Id;
  String Name;
  String Description;
  String Price;

  Product(this.Id, this.Name, this.Description, this.Price);

  Product.fromObject(dynamic o){
    this.Id = o["id"].toString();
    this.Name = o["name"];
    this.Description = o["description"];
    this.Price = o["price"].toString();
  }
}