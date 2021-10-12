import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'exhibition_product_management_model.dart';

class RequestMoveLocationModel extends ChangeNotifier {
  final ExhibitionProductManagementModel model;
  RequestMoveLocationModel(this.model);
}