import 'package:flutter/material.dart';
import 'package:flutter_custom_paint/models/doc.dart';

class WidgetDoc extends StatelessWidget {
  final Doc doc;

  const WidgetDoc({Key key, this.doc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(5)),
          child: Text(
            doc.name,
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(5)),
        )
      ],
    );
  }
}
