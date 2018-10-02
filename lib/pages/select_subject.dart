import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/common/net/net.dart';
import 'package:cat/widgets/subject_list_item.dart';
import 'package:cat/models/subject.dart';
import 'package:cat/pages/select_subject_second.dart';


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
        appBar: AppBar(
          title: Text("Select Subject"),
          backgroundColor: CatColors.globalTintColor,
        ),
        body: FutureBuilder<SelectSubjectGet>(
            future: fetchData(),
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
                          children: _buildTileList(models[index].subModels, context));
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

  List<ListItem> _buildTileList(List<SecondarySubjectModel> models, BuildContext context) {
    int count = models.length;
    return List<ListItem>.generate(
        count,
        (int index) => ListItem(
              title: models[index].title,
              onPressed: () => Navigator.of(context).push(new MaterialPageRoute(builder:(_) {
                return new SelectSubjectSecond(model: models[index],);
              })),
            ));
  }
}

///
/// 网络请求
///
Future<SelectSubjectGet> fetchData() async {
  String url = Address.getSecondType();
  final response = await HttpManager.request(Method.Get, url);
  print(StackTrace.current.toString() + "response.body" + response.body);
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return SelectSubjectGet.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class SelectSubjectGet {
  final bool type;
  final List<SubjectModel> models;

  SelectSubjectGet({this.type, this.models});

  factory SelectSubjectGet.fromJson(Map<String, dynamic> json) {
    var list = json['data'];
    var newModels = new List<SubjectModel>();

    for (Map<String, dynamic> map in list) {
      SubjectModel model = SubjectModel.fromMap(map);
      newModels.add(model);
    }
    return SelectSubjectGet(
      type: json['type'],
      models: newModels,
    );
  }
}