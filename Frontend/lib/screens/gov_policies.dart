import 'package:flutter/material.dart';
import 'package:hackathon_app/Widget/policy_widget.dart';
import 'package:hackathon_app/providers/category_policy.dart';
import 'package:provider/provider.dart';

class GovPolicies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final list = Provider.of<Policies>(context).elements;
    // print(list.map((element) {
    //   print(element);
    // }));
    print(list[0].url);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text('Gov. Policies.'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 5),
        itemCount: list.length,
        itemBuilder: (ctx, index) =>
            PolicyWidget(list[index].title, list[index].id, list[index].url),
      ),
    );
  }
}
