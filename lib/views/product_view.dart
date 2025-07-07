import 'package:flutter/material.dart';
import 'package:productos_app/database/product_database.dart';
import 'package:productos_app/models/product.dart';
import 'package:productos_app/views/product_details_view.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    refreshProducts();
  }

  // Fetch all products from the database
  refreshProducts() {
    ProductDatabase.instance.readAll().then((value) {
      setState(() {
        products = value;
      });
    });
  }

  // Navigate to product details view to add or edit product
  goToProductDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetailsView(productId: id)),
    );
    refreshProducts(); // Refresh the list after navigating back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Productos'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: products.isEmpty
            ? const Center(child: Text('No products yet', style: TextStyle(color: Colors.black)))
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () => goToProductDetailsView(id: product.id),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(product.name, style: TextStyle(
    fontSize: 18.0,  // Puedes ajustar el tamaño de la fuente según lo desees
    fontWeight: FontWeight.bold,  // Asegúrate de que el texto sea visible
                              )),
                              Text('Description: ${product.description}'),
                              Text('Price: \$${product.price}'),
                              Text('Exp: ${product.expirationDate.toLocal()}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToProductDetailsView,
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }
}
