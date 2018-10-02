import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/widgets/subject_list_item.dart';
import 'package:cat/models/subject.dart';
import 'package:cat/pages/select_subject_third.dart';

class SelectSubjectSecond extends StatefulWidget {
  const SelectSubjectSecond({Key key, this.model}) : super(key: key);

  final SecondarySubjectModel model;

  @override
  createState() => new _SelectSubjectSecondState();
}

class _SelectSubjectSecondState extends State<SelectSubjectSecond> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.model.title.toString()),
          backgroundColor: CatColors.globalTintColor,
        ),
        body: ListView.builder(
            itemCount: widget.model.list.length,
            itemBuilder: (context, int index) {
              return ListItem(
                title: widget.model.list[index],
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
                    return SelectSubjectThird();
                  })),
            ));
  }
}
