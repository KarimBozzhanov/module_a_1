import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:module_a_1/providers/records_provider.dart';
import 'package:path/path.dart' as path;
import 'package:module_a_1/models/record.dart';

class RecordsPage extends StatefulWidget {
  @override
  State<RecordsPage> createState() => RecordsPageState();

}

class RecordsPageState extends State<RecordsPage> {

  static const audioRecorderChannel = MethodChannel("javaChannel");
  String? data;
  bool isRecording = false;
  List<Record> recordList = [];

  late RecordsProvider recordsProvider;

  @override
  void initState() {
    super.initState();
    recordsProvider = RecordsProvider();
    fetchData();
  }

  fetchData() async {
    List<Record> list = await recordsProvider.loadRecords();
    setState(() {
      recordList = list;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              const Text(
                "Records",
                style: TextStyle(
                    fontSize: 25
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: 350,
                padding: const EdgeInsets.only(left: 10, top: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isRecording ?
                    InkWell(
                      child: Container(
                        width: 250,
                        height: 30,
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(color: Colors.black)
                        ),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Voice Stop",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15
                            ),
                          )
                        )
                      ),
                      onTap: () async {
                        try {
                          final String result = await audioRecorderChannel.invokeMethod("stopRecording");
                          setState(() {
                            isRecording = false;
                            data = result;
                          });
                          debugPrint("Result - $data");
                        } on PlatformException catch (e) {
                          debugPrint("Error ${e.message}");
                        }
                      },
                    ) : InkWell(
                      child: Container(
                          width: 250,
                          height: 30,
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(color: Colors.black)
                          ),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Voice Record",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 15
                                ),
                              )
                          )
                      ),
                      onTap: () async {
                        setState(() {
                          isRecording = true;
                        });
                        final String fileName = "Audio${recordList.length}";
                        await audioRecorderChannel.invokeMethod("startRecording", {"fileName": fileName});
                      },
                    ),
                    InkWell(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 25),
                        padding: const EdgeInsets.only(left: 10),
                        width: 250,
                        height: 30,
                        decoration: BoxDecoration(
                            color: data != null ? Colors.grey : Colors.red,
                            border: Border.all(color: Colors.black)
                        ),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Voice Play",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        if(data != null) {
                          audioRecorderChannel.invokeMethod("startPlaying", {"recordName": "Audio${recordList.length}"});
                        }
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                              color: data != null ? Colors.grey : Colors.red,
                              border: const Border(
                                  top: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black
                                  )
                              )
                          ),
                          child: const Center(
                            child: Text(
                              "Submit",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          if(data != null) {
                            Record record = Record(name: "Audio${recordList.length}", path: data!);
                            setState(() {
                              recordList.add(record);
                              data = null;
                            });
                            recordsProvider.saveData(recordList);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Успешно отправлено"),
                                backgroundColor: Colors.green,
                              )
                            );
                          }
                        },
                      ),
                    ),
                  ]
                ),
              ),
              Container(
                width: 350,
                padding: const EdgeInsets.only(left: 25, top: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black)
                ),
                margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Audios List",
                      style: TextStyle(
                          fontSize: 16
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: recordList.length,
                      itemBuilder: (context, index) {
                        final record = recordList[index];
                        return ListTile(
                          title: Text(record.name),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            audioRecorderChannel.invokeMethod("startPlaying", {"recordName": record.path});
                          },
                        );
                      }
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}