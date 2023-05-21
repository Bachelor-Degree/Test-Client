
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<dynamic> _products = [];

  // 获取产品信息
  Future<void> _fetchProduct() async {
    try {
      Response response = await Dio().get('http://localhost/products');
      setState(() {
        _products = response.data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Page'),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_products[index]['name']),
            subtitle: Text(_products[index]['description']),
            trailing: Text('\$${_products[index]['price']}'),
          );
        },
      ),
    );
  }
}