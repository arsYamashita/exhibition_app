

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddDataPage extends StatefulWidget {
  AddDataPage();

  @override
  _AddDataPage createState() => _AddDataPage();
}
class _AddDataPage extends State<AddDataPage> {

  final _periodNode = FocusNode();
  final _productCodeNode = FocusNode();
  final _unitNode = FocusNode();
  final _quantityNode = FocusNode();
  final _statusNode = FocusNode();

  final _form = GlobalKey<FormState>(); // 追加
  String _title = '';
  String _period = '';
  String _productCode = '';
  String _unit = '';
  int _quantity = 0;
  String _status = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('商品登録'),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 50,right: 50),
          child:Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'タイトル'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '入力してください';
                    }
                    return null;
                  }, // 追加
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_periodNode);
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '有効期間'),
                  focusNode: _periodNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '入力してください';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_productCodeNode);
                  },// 追加
                  onSaved: (value) {
                    _period = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '商品コード'),
                  focusNode: _productCodeNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '入力してください';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_unitNode);
                  },/// 追加
                  onSaved: (value) {
                    _productCode = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '箱数量'),
                  focusNode: _unitNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '入力してください';
                    }
                    return null;
                  }, // 追加
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_quantityNode);
                  },///
                  onSaved: (value) {
                    _unit = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '保管数量'),
                  focusNode: _quantityNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '入力してください';
                    }
                    return null;
                  }, // 追加
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_statusNode);
                  },//
                  onSaved: (value) {
                    _quantity = int.parse(value.toString());
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '状態'),
                  focusNode: _statusNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '入力してください';
                    }
                    return null;
                  }, // 追加
                  onSaved: (value) {
                    _status = value!;
                  },
                ),
                FlatButton(
                  child: Text('登録'),
                  color: Colors.grey,
                  onPressed: () {
                    _form.currentState!.save();
                    FirebaseFirestore.instance.collection("products").add({
                    }).then((value) {
                      print(value.id);
                      User? user = FirebaseAuth.instance
                          .currentUser;
                      FirebaseFirestore.instance
                          .collection("products")
                          .doc(value.id)
                          .collection("list")
                          .add({
                        "imagePath": "https://firebasestorage.googleapis.com/v0/b/exhibitionapp-d03ca.appspot.com/o/kimuchi.png?alt=media&token=5108ae3e-d5c8-46a8-8878-f44e189b5851",
                        "period": _period,
                        "productCode": _productCode,
                        "quantity": _quantity,
                        "status": _status,
                        "title": _title,
                        "unit": _unit,
                        "uid": user!.uid,});
                    });
                  },
                ),
              ],
            ),
          ),
        )
    );
  }
}