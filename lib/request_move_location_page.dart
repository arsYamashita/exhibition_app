import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
import 'exhibition_product_management_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';


class RequestMoveLocationPage extends StatefulWidget {
  RequestMoveLocationPage();

  @override
  _RequestMoveLocationPage createState() => _RequestMoveLocationPage();
}
class _RequestMoveLocationPage extends State<RequestMoveLocationPage> {

  final List<Map<String, dynamic>> _items = [
    {
      'value': '東京ビックサイト',
      'label': '東京ビックサイト',
    },
    {
      'value': '幕張メッセ',
      'label': '幕張メッセ',
    },
    {
      'value': '東京ドーム',
      'label': '東京ドーム',
      'enable': false,
    },
  ];

  DateTime _startDate = new DateTime.now();
  DateTime _endDate = new DateTime.now();

  Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _startDate,
        firstDate: new DateTime(2020),
        lastDate: new DateTime.now().add(new Duration(days: 360))
    );
    if(picked != null) setState(() => _startDate = picked);
  }
  Future<Null> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _endDate,
        firstDate: new DateTime(2020),
        lastDate: new DateTime.now().add(new Duration(days: 360))
    );
    if(picked != null) setState(() => _endDate = picked);
  }

  final _periodNode = FocusNode();
  final _productCodeNode = FocusNode();
  final _unitNode = FocusNode();
  final _quantityNode = FocusNode();
  final _statusNode = FocusNode();

  final _form = GlobalKey<FormState>(); // 追加
  String _description = '';


  String _location = '';
  int _selectItem = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('移動指示'),
        ),
        body: SafeArea(
          child:Row(children: [
            ChangeNotifierProvider(
              create: (_) => ExhibitionProductManagementModel()..getProducts(),
              child: Container(
                width:MediaQuery.of(context).size.width/2,
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
              ),),
            Container(
              width:MediaQuery.of(context).size.width/2,
              padding: const EdgeInsets.only(left: 50,right: 50),
              child:Form(
                key: _form,
                child: Column(
                  children: [
                    SelectFormField(
                      type: SelectFormFieldType.dropdown, // or can be dialog
                      initialValue: '幕張メッセ',
                      labelText: '会場',
                      items: _items,
                      onChanged: (val) => print(val),
                      onSaved: (value) {
                        _location = value!;
                      },
                    ),
                    Container(child:Text("配達日時${_startDate}")),
                    RaisedButton(onPressed: () => _selectStartDate(context), child: new Text('配達日時選択'),),
                    Container(child:Text("集荷日時${_endDate}")),
                    RaisedButton(onPressed: () => _selectEndDate(context), child: new Text('集荷日時選択'),),
                    TextFormField(
                      maxLines: null,
                      decoration: InputDecoration(labelText: '依頼内容'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '入力してください';
                        }
                        return null;
                      }, // 追加

                      onSaved: (value) {
                        _description = value!;
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 30),
                      child:
                      FlatButton(
                        child: Text('依頼する'),
                        color: Colors.grey,
                        onPressed: () {
                          _form.currentState!.save();

                          FirebaseFirestore.instance.collection("request").add({
                          }).then((value) {
                            print(value.id);
                            User? user = FirebaseAuth.instance
                                .currentUser;
                            flutterEmailSenderMail(_location,_startDate,_endDate,_description,user!.uid);
                            FirebaseFirestore.instance
                                .collection("request")
                                .doc(value.id)
                                .collection("item")
                                .add({
                              "location": _location,
                              "startDate": _startDate,
                              "endDate": _endDate,
                              "description": _description,
                              "uid": user!.uid,});
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],),
        ));
  }
}
//flutter_email_senderを使ってメールを送信
flutterEmailSenderMail(String location,DateTime startDate,DateTime endDate,String description,String uid) async {
  final Email email = Email(
    body: '依頼者ID：${uid}\n会場：${location}\n配達日時:${startDate.toString()}\n集荷日時:${endDate.toString()}\n依頼内容:${description}\n',
    subject: '展示会出荷依頼',
    recipients: ['yamashita@ars-cube.com'],
  );
  await FlutterEmailSender.send(email);
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
                        FlatButton(
                          child: Text('商品コードをコピー'),
                          color: Colors.grey,
                          onPressed: () async {

                            // コピーするとき
                            final data = ClipboardData(text: product.productCode);
                            await Clipboard.setData(data);

                          },
                        ),

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
