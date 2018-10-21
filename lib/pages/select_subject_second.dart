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
        appBar: GradientAppBar(
          title: Text(widget.model.title.toString()),
        ),
        body: ListView.builder(
            itemCount: widget.model.list.length,
            itemBuilder: (context, int index) {
              return ListItem(
                title: widget.model.list[index],
                onPressed: () => Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (_) {
                      return SelectSubjectThird(
                        title: widget.model.title,
                        subtitle: widget.model.list[index],
                      );
                    })),
              );
            }));
  }
}
