import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Product {
  final String name;
  final double price;
  int quantity;

  Product({required this.name, required this.price, this.quantity = 0});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductList(),
      routes: {
        '/cart': (context) => CartPage(),
      },
    );
  }
}

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> products = [
    Product(name: 'Product A', price: 10.0),
    Product(name: 'Product B', price: 20.0),
    Product(name: 'Product C', price: 15.0),
  ];

  void addToCart(Product product) {
    setState(() {
      product.quantity++;

      if (product.quantity == 5) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Congratulations!'),
              content: Text('You\'ve bought 5 ${product.name}!'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  void goToCart() {
    Navigator.pushNamed(context, '/cart', arguments: products);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            trailing: TextButton(
              onPressed: () => addToCart(product),
              child: Text('Buy Now (${product.quantity})'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToCart,
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = ModalRoute.of(context)!.settings.arguments as List<Product>;
    int totalQuantity = products.fold(0, (sum, product) => sum + product.quantity);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Center(
        child: Text('Total Products: $totalQuantity'),
      ),
    );
  }
}
