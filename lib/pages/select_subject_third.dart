import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/widgets/subject_list_item.dart';

class SelectSubjectThird extends StatefulWidget {
  const SelectSubjectThird({Key key}) : super(key: key);

  @override
  createState() => new _SelectSubjectThirdState();
}

class _SelectSubjectThirdState extends State<SelectSubjectThird> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: CatColors.globalTintColor,
        ),
        body: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, int index) {
              return ListItem(
                title: "",
                onPressed: () {},
              );
            }));
  }

  List<ListItem> _buildTileList(List<String> titles, BuildContext context) {
    int count = titles.length;
    return List<ListItem>.generate(
        count,
        (int index) => ListItem(
              title: titles[index],
              onPressed: () => Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (_) {
                    return null;
                  })),
            ));
  }
}
