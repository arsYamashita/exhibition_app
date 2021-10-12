import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ExhibitionProductManagementModel extends ChangeNotifier {
  ExhibitionProductManagementModel() {
  }

  List products = <Product>[];
  String errorMessage = '';

  Future getProducts() async {
    print('発火してるよ');
    await FirebaseFirestore.instance.collection("products").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        FirebaseFirestore.instance
            .collection("products")
            .doc(result.id)
            .collection("list")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            Product product = Product(result.get('title'),result.get('imagePath'),result.get('period'),result.get('productCode'),result.get('unit'),result.get('status'),result.get('quantity'));
            this.products.add(product);
            notifyListeners();
          });
        });
      });
    });

  }
}
class Product {
  String name,imagePath,period,productCode,unit,status;
  int quantity;

  Product(
      this.name,
      this.imagePath,
      this.period,
      this.productCode,
      this.unit,
      this.status,
      this.quantity,
      );
}