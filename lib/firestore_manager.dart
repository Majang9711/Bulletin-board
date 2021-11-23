import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  Firestore firestore = Firestore.instance;
  String collection = '게시판';
  void add(String title, String content, String date_time) {
    firestore
        .collection('카운트')
        .document('카운트')
        .get()
        .then((DocumentSnapshot ds) {
      firestore.collection(collection).document('${ds.data['카운트']}').setData(
          {'제목': title, '내용': content, '날짜': date_time, 'id': ds.data['카운트']});
      int id = ds.data['카운트'] + 1;
      cntupdate(id);
      print(titleRead(2));
    });
  }

  void cntupdate(int _id) {
    firestore
        .collection('카운트')
        .document('카운트')
        .updateData({'id': _id, '카운트': _id});
  }

  void update(int _id, String title, String content) {
    firestore
        .collection(collection)
        .document('$_id')
        .updateData({'제목': title, '내용': content});
  }

  String titleRead(int _id) {
    String readtitle = '';
    firestore
        .collection(collection)
        .document('$_id')
        .get()
        .then((DocumentSnapshot ds) {
      readtitle = ds.data['제목'];
    });
    return readtitle;
  }

  String contentRead(int _id) {
    String readtitle = '';
    firestore
        .collection(collection)
        .document('$_id')
        .get()
        .then((DocumentSnapshot ds) {
      readtitle = ds.data['내용'];
    });
    return readtitle;
  }

  int countRead() {
    int cnt = 0;
    firestore
        .collection('카운트')
        .document('카운트')
        .get()
        .then((DocumentSnapshot ds) {
      cnt = ds.data['카운트'];
    });
    return cnt;
  }

  void delete(int _id) {
    //특정 document 삭제
    firestore.collection(collection).document('$_id').delete();
  }
}
