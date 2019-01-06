import 'package:fasttrack/app_user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class JournalWidget extends StatelessWidget {
  final whenDate = DateFormat.yMd().add_jm();

  Widget _buildListItem(DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return ListTile(
      title: Text(record.weight.toString()),
      trailing: Text(whenDate.format(record.when.toLocal())),
      onLongPress: () => data.reference.delete(),
    );
  }

  Widget _buildListView(List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildListItem(data)).toList(),
    );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('testweights')
          .where(
            "owner",
            isEqualTo: AppUser.currentUser.uid
          )
          .orderBy("when", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return Expanded(
          child: _buildListView(snapshot.data.documents),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              'Journal',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28),
            ),
            _buildList()
          ],
        ));
  }
}

class Record {
  final double weight;
  final DateTime when;
  final String owner;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['weight'] != null),
        assert(map['when'] != null),
        assert(map['owner'] != null),
        weight = map['weight'],
        when = map['when'],
        owner = map['owner'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$weight:$when:$owner>";
}
