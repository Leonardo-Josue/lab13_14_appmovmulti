import 'package:flutter/material.dart';
import 'package:productos_app/database/product_database.dart';
import 'package:productos_app/models/product.dart';

class ProductDetailsView extends StatefulWidget {
  final int? productId;
  const ProductDetailsView({Key? key, this.productId}) : super(key: key); // Se pasa el 'key' al constructor de la clase base

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  DateTime? expirationDate;
  bool isLoading = false;
  bool isNewProduct = true;

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      // Edit product
      isNewProduct = false;
      loadProductData();
    }
  }

  // Load product data if it's an existing product
  loadProductData() async {
    try {
      ProductModel product = await ProductDatabase.instance.read(widget.productId!);
      if (!mounted) return;  // Verifica si el widget está montado antes de hacer setState
      nameController.text = product.name;
      descriptionController.text = product.description;
      priceController.text = product.price.toString();
      expirationDate = product.expirationDate;
      setState(() {});
    } catch (e) {
      // Handle error, maybe show a message to the user
      debugPrint('Error loading product: $e');
    }
  }

  // Save or update the product
  saveProduct() async {
    if (nameController.text.isEmpty || descriptionController.text.isEmpty || priceController.text.isEmpty || expirationDate == null) {
      // Show a message to the user if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all fields.")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    final product = ProductModel(
      id: widget.productId, // If it's an existing product, keep the same ID
      name: nameController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      expirationDate: expirationDate ?? DateTime.now(),
    );

    try {
      if (isNewProduct) {
        await ProductDatabase.instance.create(product);
      } else {
        await ProductDatabase.instance.update(product);
      }

      if (!mounted) return; // Verifica si el widget sigue montado
      setState(() {
        isLoading = false;
      });

      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Show error message if something went wrong
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error saving product: $e")));
    }
  }

  // Select expiration date
  selectExpirationDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: expirationDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != expirationDate) {
      setState(() {
        expirationDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isNewProduct ? 'Add Product' : 'Edit Product'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        expirationDate == null
                            ? 'Select Expiration Date'
                            : 'Expiration Date: ${expirationDate!.toLocal()}',
                        style: TextStyle(color: Colors.black),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: selectExpirationDate,
                      ),
                    ],
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: saveProduct,  // Call saveProduct when the button is pressed
                    child: Text(isNewProduct ? 'Save Product' : 'Update Product'),
                  ),
                ],
              ),
            ),
    );
  }
}
