import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'myColor.dart';

class History extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => HistoryState();
}

class HistoryState extends State<History>{
  List<Map<String, dynamic>> _billsList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedData = prefs.getStringList('billsList') ?? [];

    for (String data in savedData) {
      Map<String, dynamic> billData = json.decode(data);
      _billsList.add(billData);
    }

    setState(() {

    });
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ALL records?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteData();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: TextStyle(
          color: MyColor.black,
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              _showDeleteConfirmationDialog(context);
            },
            icon: Icon(Icons.delete),
            color: MyColor.accentDark,
          ),
        ],
      ),
      body: _billsList.isEmpty //if _billList is empty display image else display padding
          ? Image.asset(
        'assets/no_record_bg.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      )
      :
      Stack(children: [
        Image.asset(
          'assets/blue_bg.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: _billsList.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> billData = _billsList[index];
              String totalBill = double.parse(billData['totalBill']).toStringAsFixed(2);
              String pax = billData['pax'];
              List<String> billItems = List<String>.from(billData['bill']);

              if(billItems.length == 1){
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  color: MyColor.primary,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Bill',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(235, 240, 245, 1),
                                  ),
                                ),
                                Text(
                                  'RM $totalBill',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(235, 240, 245, 1),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pax',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(235, 240, 245, 1),
                                  ),
                                ),
                                Text(
                                  '$pax',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(235, 240, 245, 1),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: MyColor.grey_20, thickness: 1.0, height: 0,),
                      Container(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Each Person Pay',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: MyColor.primaryLight,
                                  ),
                                ),
                                for (String item in billItems)
                                  Text(
                                    'RM $item',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: MyColor.primaryLight,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              else{
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  color: MyColor.primary,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Bill',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(235, 240, 245, 1),
                                  ),
                                ),
                                Text(
                                  'RM $totalBill',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(235, 240, 245, 1),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pax',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(235, 240, 245, 1),
                                  ),
                                ),
                                Text(
                                  '$pax',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(235, 240, 245, 1),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: MyColor.grey_20, thickness: 1.0, height: 0,),
                      Container(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Column(
                          children: [
                            for (int i = 0; i < billItems.length; i ++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Person ${i + 1}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: MyColor.primaryLight,
                                    ),
                                  ),
                                  Text(
                                    'RM ${billItems[i]}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: MyColor.primaryLight,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ],
      ),
    );
  }

  Future<void> _deleteData() async {
    // Remove the data from shared_preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('billsList');

    setState(() {
      _billsList.clear();
    });
  }
}