import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_paint/configs/config_vaway.dart';
import 'package:flutter_custom_paint/main.dart';
import 'package:flutter_custom_paint/models/doc.dart';
import 'package:flutter_custom_paint/models/request_firebase.dart';
import 'package:flutter_custom_paint/screens/paint_page.dart';
import 'package:flutter_custom_paint/widgets/widget_doc.dart';
import 'package:flutter_custom_paint/widgets/widget_show_notifi.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Query docs;
  @override
  void initState() {
    docs = RequestFirebase.getAllDoc();
    Timer(Duration(seconds: 1), () {
      ShowNotifi.showToast(
          title: "Xin Chào " + ConfigsVAWAY.userProfile.fullname ?? "");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VA Paint"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                PaintPage.doc = null;
                Get.to(() => PaintPage());
              }),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.remove(ConfigsVAWAY.keyUserProfile);
                Get.to(() => Launch());
              })
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(3),
        child: StreamBuilder<QuerySnapshot>(
          stream: docs.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.size < 1)
                return Center(child: Text("Không có gì ! Thử tạo bài mới ! "));
              return RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 3));
                },
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: snapshot.data.size,
                    itemBuilder: (context, index) {
                      Doc doc =
                          Doc.formDocumentSnapShot(snapshot.data.docs[index]);
                      return InkWell(
                          onTap: () {
                            PaintPage.doc = doc;
                            Get.to(() => PaintPage());
                          },
                          child: WidgetDoc(doc: doc));
                    }),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text("Opps ! có lỗi gì đó "));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
