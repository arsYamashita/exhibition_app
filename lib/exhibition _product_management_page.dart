import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'exhibition_product_management_model.dart';

class FirestoreLoad extends StatefulWidget {
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<FirestoreLoad> {
  // ドキュメント情報を入れる箱を用意
  List<DocumentSnapshot> documentList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('LoadAlldocs'),
              onPressed: () async {
                _onPressed();
              },
            ),
            // ドキュメント情報を表示
            Column(
              children: documentList.map((document) {
                return ListTile(
                  title: Text('name:${document['SBnemEmsZ2ioSZjC6Hts']['title']}'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

void _onPressed() {
  FirebaseFirestore.instance.collection("users").add({
    "name": "john",
    "age": 50,
    "email": "example@example.com",
    "address": {"street": "street 24", "city": "new york"}
  }).then((value) {
    print(value.id);
    FirebaseFirestore.instance
        .collection("users")
        .doc(value.id)
        .collection("pets")
        .add({"petName": "blacky", "petType": "dog", "petAge": 1});
  });
  FirebaseFirestore.instance.collection("products").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      FirebaseFirestore.instance
          .collection("products")
          .doc(result.id)
          .collection("list")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print(result.data());
        });
      });
    });
  });
}
// [Themelist] インスタンスにおける処理。
class ExhibitionProductManagementPage extends StatelessWidget {
  ExhibitionProductManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildTaskList(),
    );
  }
}
Widget buildTaskList() {
  return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('展示品管理'),
      ),
      body: SafeArea(
          child:ChangeNotifierProvider(
            create: (_) => ExhibitionProductManagementModel()..getProducts(),
            child: Container(
              padding: const EdgeInsets.only(left: 50,right: 50,top: 30),
              child: Consumer<ExhibitionProductManagementModel>(
                builder: (context, model, child) {
                  return ListView.builder(
                    itemCount: model.products.length,
                    itemBuilder: (context, int position) =>
                        Card(
                          child: ListTile(
                            leading: ConstrainedBox(
                              constraints: BoxConstraints(),
                              child: Image.network(model.products[position].imagePath.toString()), //microCMSの画像変更機能を利用
                            ),
                            title: Container(child: Row(children: [
                              Text(model.products[position].name + '(${model.products[position].quantity})'),
                            ],),),
                            subtitle: Text(model.products[position].productCode),
                            onTap: (){
                              showDetail(context,model.products[position]);
                            },
                          ),
                        ),
                  );
                },
              ),
            ),)));
}
class ProductListItem extends StatelessWidget {
  const ProductListItem({
    required this.onChanged,
    required this.product,
  });
  final Product product;
  final ValueChanged onChanged;


  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {

      },
      child:Container(
        height: 40,
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            border:
            Border.all(width: 0, color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200]
        ),child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left:20.0),
            child: Text(product.name),
          ),
          Container(
            margin: EdgeInsets.only(right:20.0),
            child: Icon(
              Icons.arrow_forward_ios,
              color:Colors.grey,
              size: 15,
            ),
          ),

        ],),),);
  }
}

void showDetail (BuildContext context,Product product){
  showDialog(
      context: context,
      builder: (context) {
        return Column(
          children: <Widget>[
            AlertDialog(
              title: Text(product.name),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Image.network(product.imagePath.toString()),
                       Text('有効期間:' + product.period,textAlign: TextAlign.left),
                       Text('商品コード:' + product.productCode,textAlign: TextAlign.left),
                       Text('箱数量:' + product.unit,textAlign: TextAlign.left),
                       Text('保管数量:' + '${product.quantity} 箱',textAlign: TextAlign.left),
                       Text('状態:' + product.status,textAlign: TextAlign.left),
                     ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
// ボタン
              ],
            ),
          ],
        );
      }
  );
}
