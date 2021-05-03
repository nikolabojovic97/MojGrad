import 'package:Frontend/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final Product _product;
  ProductItem(this._product);

  @override
  Widget build(BuildContext context) {
    return Padding(
      
      padding: const EdgeInsets.all(5),
      child: Container (
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white70, width: 2, ),
        ),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(_product.Name, style: TextStyle(color: Colors.white, fontSize: 24),),
          Text(_product.Description, style: TextStyle(color: Colors.white, fontSize: 18),),
          Text(_product.Price.toString() + " " + "RSD", style: TextStyle(color: Colors.white, fontSize: 18,),),
        ],
        ),
      ));
  }
}