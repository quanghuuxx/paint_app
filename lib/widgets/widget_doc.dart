import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_custom_paint/models/doc.dart';

class WidgetDoc extends StatelessWidget {
  final Doc doc;

  const WidgetDoc({Key key, this.doc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            child: Text(
              doc.name,
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(child: Image.memory(Uint8List.fromList(doc.image))),
        ],
      ),
    );
  }
}
