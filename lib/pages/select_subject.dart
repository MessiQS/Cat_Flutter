import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/widgets/subject_list_item.dart';
import 'package:cat/models/subject.dart';
import 'package:cat/pages/select_subject_second.dart';
import 'package:cat/common/services/select_subject.dart';

class SelectSubject extends StatefulWidget {
  @override
  createState() => new _SelectSubjectState();
}

class _SelectSubjectState extends State<SelectSubject> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          title: Text("选择科目"),
        ),
        body: FutureBuilder<SelectSubjectGet>(
            future: SelectSubjectService.fetchMainData(),
            builder: (context, snapshot) {
              /// 分组Model
              if (snapshot.hasData) {
                var models = snapshot.data.models;
                return ListView.builder(
                    itemCount: models.length,
                    itemBuilder: (context, int index) {
                      return ExpansionTile(
                          title: Text(models[index].title),
                          backgroundColor:
                              Theme.of(context).accentColor.withOpacity(0.025),
                          children:
                              _buildTileList(models[index].subModels, context));
                    });
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          CatColors.globalTintColor)));
            }));
  }

  List<ListItem> _buildTileList(
      List<SecondarySubjectModel> models, BuildContext context) {
    int count = models.length;
    return List<ListItem>.generate(
        count,
        (int index) => ListItem(
              title: models[index].title,
              onPressed: () => Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (_) {
                    return new SelectSubjectSecond(
                      model: models[index],
                    );
                  })),
            ));
  }
}
