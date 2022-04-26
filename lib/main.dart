import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<AppUsageInfo> _infos = [];
  // DateTime newDate =DateTime.now();
  //  DateTime endDate =DateTime.now();
  @override
  void initState() {
    super.initState();
  }

  getUsageStats(DateTime newDate) async {
    try {
      DateTime endDate =  newDate;
      DateTime startDate = DateTime.now().subtract(Duration(minutes: 10));
      List<AppUsageInfo> infoList = await AppUsage.getAppUsage(startDate, endDate);
      setState(() {
        _infos.clear();
        _infos = infoList;
        print("${startDate.minute}+" "${endDate.minute} +${endDate.minute-startDate.minute}");
      });

      for (var info in infoList) {
        print(info.toString());
      }
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // title:  Text("${newDate.minute}" +"${endDate.minute} +${newDate.minute-endDate.minute}"),
          backgroundColor: Colors.green,
          leading: IconButton(icon: Icon(Icons.present_to_all_sharp),
            onPressed: (){
              getUsageStats(DateTime.now());
            // newDate = DateTime.now() ;
              // print(newDate);
            },
          ),
        ),
        body: Column(

          children: [
            // Text("${newDate.minute}+" "${endDate.minute} +${endDate.minute-newDate.minute}"),
            Expanded(
              child: ListView.builder(
                  itemCount: _infos.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(_infos[index].appName),
                        trailing: Text(_infos[index].usage.inMinutes.toString()));
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: ()=>getUsageStats(DateTime.now()), child: Icon(Icons.file_download)),
      ),
    );
  }
}