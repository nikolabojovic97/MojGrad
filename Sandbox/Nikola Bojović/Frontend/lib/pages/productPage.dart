
import 'dart:convert';

import 'package:Frontend/models/product.dart';
import 'package:Frontend/providers/auth.dart';
import 'package:Frontend/providers/products.dart';
import 'package:Frontend/widgets/productItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProductPage extends StatefulWidget {
  ProductPage({Key key}):super(key: key){
    
  }

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> products;

  getProducts(){
    ProductsProvider().getAllProducts(Provider.of<Auth>(context, listen: false).token).then((response){
      Iterable list = json.decode(response.body);
      AlertDialog(content: Text(list.toString()));
      List<Product> productsList = List<Product>();
      productsList = list.map((model) => Product.fromObject(model)).toList();
        setState(() {
          products = productsList;
        });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.blueGrey],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight
          ),
        ),
        child: products == null ? Center(child: Text("There are no products!"),) : ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index){
            return ProductItem(products.elementAt(index));
          },
        ),
        ),
    );
  }
}
