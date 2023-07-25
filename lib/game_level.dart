import 'package:flutter/material.dart';
import 'package:logo_game_2/level_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'game_paly_area.dart';
import 'data.dart';
import 'main.dart';

class Sub_level_page extends StatefulWidget {
  int level_ind;
  int level;
  // List winlist ;
  List pointlist;
  Sub_level_page(this.level_ind,this.level,this.pointlist);

  @override
  State<Sub_level_page> createState() => _Sub_level_pageState();
}

class _Sub_level_pageState extends State<Sub_level_page> {
  SharedPreferences?prefs;

  List logo = [];
  int l = 0;
  List answer =[];
  bool tempcomleted = false;

  int level = 0;
  // List winlist = [];
  double wincnt = 0.0;
  List<double> wincountlist = [];
  List pointslist = [];
  List<double> percent = [];
  int p =0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data.winlist = List.filled(25, "");
    pointslist = List.filled(5,0);
    wincountlist = List.filled(20, 0.0);
// get();
    print("hello good");

  }

  Future<void> get()
  async {
    MyApp.prefs = await SharedPreferences.getInstance();

    for(int i=0;i<5;i++)
    {
      level = MyApp.prefs!.getInt('level${i}')??0;
      pointslist[i] = MyApp.prefs!.getInt('points${i}')??0;
      percent.add(level/data.ans1.length);
    }


    for (int main = 0; main < 5; main++) {
      for (int sub = 0; sub < 5; sub++) {
        data.winlist[l] = MyApp.prefs?.getString('level${main}${sub}');
        l++;
      }
    }


    for (int main = 0; main < 5; main++) {
      for (int sub = 0; sub < 5; sub++) {
        print(p);
        if(data.winlist[p]=="win")
        {
          wincnt++;
          print("okeys");
        }
        p++;
        wincountlist[main]=wincnt;
      }
      wincnt = 0;
    }
    print(percent);
  }
  Widget build(BuildContext context) {
    if(0==widget.level_ind)
    {
      logo.addAll(data.car_logo);
      answer.addAll(data.ans1);

    }
    if(1==widget.level_ind)
    {
      logo.addAll(data.file_logo);
      answer.addAll(data.ans2);

    }
    if(2==widget.level_ind)
    {
      logo.addAll(data.App_logo);
      answer.addAll(data.ans3);

    }


    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: Text("level ${widget.level_ind+1}")),
        body: FutureBuilder(
            future: get(),
            builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done) {
            return Container(
              alignment: Alignment.center,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
                itemCount: 5,itemBuilder: (context, index) {
                return GestureDetector( onTapUp: (details) {
                  if(widget.level-1<index)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Playing_Area(index,logo,widget.level_ind,answer,widget.pointlist);
                    },));

                  }
                },
                  child: ((data.winlist[(widget.level_ind * 5) + index])!="win")?Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(colors: [
                          Colors.teal.shade600,
                          Colors.white,
                          Colors.teal.shade600,
                        ])),
                    child: Image(fit: BoxFit.fill,image: AssetImage("images/${logo[index]}")),
                  ):Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(colors: [
                          Colors.teal.shade600,
                          Colors.white,
                          Colors.teal.shade600,
                        ])),
                    child: Center(child: Text("Level Complete")),
                  ),
                );
              },),
            );
          }
          else {
            return Container();
          }
        })
      ),onWillPop: ()async{
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(title: Text("You want to exit this page"),
              actions: [
                TextButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return Level_Page(percent, data.winlist, wincountlist, pointslist);
                  }));

                }, child: Text("yes")),
                TextButton(
                    onPressed: (){
                      setState(() {
                        Navigator.pop(context);

                      });

                    }, child: Text("No")),

              ],
            );
          });
      return true;
    }
    );
  }
}


//
// FutureBuilder(
// future: get(),
// builder: (context, snapshot) {
// if (snapshot.connectionState == ConnectionState.done)
// {
//
// } else
// {
// return Container();
// }
// },
// ),
// ),
// );
// }
// }
