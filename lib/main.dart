import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_manager.dart';
import 'write.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:paly_notice/content.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '심심해서 만든 게시판 앱',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: '심심해서 만든 게시판 앱'));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> ImagesList = [
    //배너 사진들
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTI2c7QfmDSyMdzugD_z5nzHCORhvnVqiT14w&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTI2c7QfmDSyMdzugD_z5nzHCORhvnVqiT14w&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTI2c7QfmDSyMdzugD_z5nzHCORhvnVqiT14w&usqp=CAU",
  ];

  void _incrementCounter() {
    //쓰기로 이동
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WritePage()),
      );
    });
  }

  onMove(String title, String content) {
    //해당 게시글로 이동
    data d = new data();
    d.setTitle(title, content);
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => contentPage()),
      );
    });
    print(title);
    print(content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Card(
                child: Column(
              children: <Widget>[
                // new Swiper(
                //   autoplay: true,
                //   itemBuilder: (BuildContext context, int index) {
                //     return new Image.network(
                //       ImagesList[index],
                //       fit: BoxFit.fill,
                //     );
                //   },
                //   itemCount: ImagesList.length,
                //   itemWidth: 300.0,
                //   itemHeight: 200.0,
                //   layout: SwiperLayout.STACK,
                // ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 800.0,
                        child: sss(context),
                      ),
                    ),
                  ],
                ),
              ],
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: '글쓰기',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget sss(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('게시판')
          .orderBy('id', descending: true) //이건 정렬
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new Column(
                  children: <Widget>[
                    SizedBox(
                      height: 70,
                      child: new ListTile(
                          title: new Text(document.data['제목']),
                          subtitle: new Text(document.data['내용']),
                          onTap: () {
                            onMove(document.data['제목'], document.data['내용']);
                          }),
                    ),
                    Divider(
                      thickness: 1.0,
                    )
                  ],
                );
              }).toList(),
            );
        }
      },
    );
  }
}
