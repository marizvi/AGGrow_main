import 'package:flutter/cupertino.dart';

class Content with ChangeNotifier {
  final String cid;
  final String title;
  final String desc;
  final String url;
  Content(
      {required this.cid,
      required this.title,
      required this.desc,
      required this.url});
}
