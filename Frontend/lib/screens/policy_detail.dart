import 'package:flutter/material.dart';
import 'package:hackathon_app/providers/category_policy.dart';
import 'package:provider/provider.dart';

class PolicyDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final content = Provider.of<Policies>(context).findCategory(id);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.8,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text('Policies'),
        ),
        body: ListView.builder(
          itemCount: content.length,
          itemBuilder: (context, index) => Card(
            margin: EdgeInsets.all(5),
            child: ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/scheme_detail',
                    arguments: {'id': id, 'cid': content[index]['cid']});
              },
              contentPadding: EdgeInsets.all(8),
              title: Text(content[index]['title']),
              trailing: Icon(Icons.double_arrow_rounded, color: Colors.indigo),
            ),
          ),
        ));
  }
}
