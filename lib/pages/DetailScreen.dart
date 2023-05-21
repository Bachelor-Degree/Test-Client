import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final dynamic detail;

  const DetailsScreen({Key? key, required this.detail}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> detailWidgets = [];
    widget.detail.forEach((key, value) {
      detailWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$key: ',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Expanded(
                child: Text(
                  '$value',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.detail['Name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.detail['Name'],
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8.0),
            Text(
              "ID: " + widget.detail['ID'].toString(),
              //widget.detail['Description'],
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: detailWidgets,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
