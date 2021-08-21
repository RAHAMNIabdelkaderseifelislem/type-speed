import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Type Speed',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        fontFamily: 'Ubuntu',
      ),
      home: game(),
    );
  }
}

class game extends StatefulWidget {
  game({ Key? key }) : super(key: key);

  @override
  _gameState createState() => _gameState();
}

class _gameState extends State<game> {
  int s = 0;
  int h = 0;
  int l = 500;
  List words = [];
  final ct = TextEditingController();
  Stopwatch st = new Stopwatch();
  List lwl = [];
  int c = 0;
  final word = Colors.white;
  Listword() async{
    return await rootBundle.loadString('list.txt');
  }
  groupWords(){
    return lwl[new Random().nextInt(lwl.length)];
  }
  sy(double hor, double ver){
    return EdgeInsets.symmetric(horizontal: hor,vertical: ver);
  }
  ch(value){
    int le = ct.text.length;
    if (s != 0 && l == 0) return;
    if (s == 0 && le > 0) {
      setState(() {
          s = 1;
      });
      new Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
        setState(() {
          if (l == 0) {
            t.cancel();
            ct.clear();
            h = s > h ? s : h;
          }
          l--;
          c--;
        });        
       });
    }
    if (le > 0 && ct.text[le - 1] == ' ') {
      setState(() {
        ct.text == words[0] + ' ' ? s += le : c = 10;
        words.removeAt(0);
        words.add(groupWords());
      });
      ct.clear();
    }
  }
  gwl() {
    List<Widget> l = [];
    for(var w in words) l.add(wc(w));
    return l;
  }
  wc(String t){
    return Container(
      padding: sy(24,8),
      margin: sy(8,16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(24)
      ),
      child: Text(
        t,
        style: TextStyle(
          fontSize: 20
        ),
      ),
    );
  }

  @override
  void initState() {
    Listword().then((v){
      setState(() {
        lwl = v.split("\n");
        for (var i = 0; i < 4; i++) words.add(groupWords());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Expanded(child: Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blueAccent
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: l < 0
                      ? GestureDetector(
                        onTap: (){
                          setState(() {
                            l = 500;
                            s = 0;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.replay , color: word,size: 100,),
                            Container(
                              padding: sy(0,24),
                              child: Text(
                                "Score: $s",
                                style: TextStyle(
                                  color: word, fontSize: 30
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                      : Text(
                        '${l < 0 ? s - 1 : (l / 10).toStringAsFixed(1)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 100,
                          color: word,
                        ),
                      )
                      )
                  ),
                  Padding(
                    padding: sy(24, 16),
                    child: Text(
                      "High Score : $h",
                      style: TextStyle(
                        fontSize: 16,
                        color: word,
                      ),
                    ),
                  )
              ],
            ),
            ),
        )
        ),
        Container(
          margin: sy(24, 16),
          child: Row(children: gwl(),),
        ),
        Container(
          margin: sy(24, 16),
          child: TextField(
            autocorrect: false,
            controller: ct,
            onChanged: ch,
            enabled: l > 0,
            decoration: InputDecoration(
              filled: c > 0,
              fillColor: Colors.red[100],
              hintText: 'Start game by entering word',
              contentPadding: sy(24, 16),
              border: 
                OutlineInputBorder(borderRadius: BorderRadius.circular(24))
            ),
            ),
        ),
        SizedBox(
          height: 40,
        )

      ],),
    );
  }
}