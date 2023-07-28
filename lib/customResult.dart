import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom.dart';
import 'main.dart';
import 'myColor.dart';
import 'dart:ui' as ui;
import 'dart:io';

class textResult extends StatelessWidget{
  final int id;
  final double totalBill;
  textResult({required this.id, required this.totalBill});

  @override
  Widget build(BuildContext context) {
    if(status == 'RM'){
      //check error
      if (id < 0 || id >= customBillList.length) {
        return Text(
          'Invalid ID: $id',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.red,
          ),
        );
      }

      double amount = customBillList[id];
      String displayAmount;
      displayAmount = amount.toStringAsFixed(2);
      int index = id + 1;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Person $index',
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromRGBO(235, 240, 245, 1),
            ),
          ),
          Text(
            'RM $displayAmount',
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromRGBO(235, 240, 245, 1),
            ),
          ),
        ],
      );
    }
    else{
      //check error
      if (id < 0 || id >= customBillList.length) {
        return Text(
          'Invalid ID: $id',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.red,
          ),
        );
      }

      double pct = customBillList[id];
      String displayPercentageAmount;
      displayPercentageAmount = pct.toStringAsFixed(2);
      int index = id + 1;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Person $index',
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromRGBO(235, 240, 245, 1),
            ),
          ),
          Text(
            'RM $displayPercentageAmount',
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromRGBO(235, 240, 245, 1),
            ),
          ),
        ],
      );
    }
  }
}

class CustomResult extends StatefulWidget{
  final double totalBill;
  final int nop;
  final List<Map<String, dynamic>> billsList;

  CustomResult({super.key, required this.totalBill, required this.nop, required this.billsList});

  @override
  State<CustomResult> createState() => CustomResultState(totalBill: totalBill, nop: nop, billsList: billsList);
}

class CustomResultState extends State<CustomResult> {
  final double totalBill;
  final int nop;
  final List<Map<String, dynamic>> billsList;
  CustomResultState({required this.totalBill, required this.nop, required this.billsList});
  String displayBill = '0', displayNop = '0';
  Color textButtonColor = MyColor.primaryLight;
  bool isButtonDisabled = false;

  void _onButtonClicked() {
    setState(() {
      isButtonDisabled = true;
      textButtonColor = MyColor.grey_60;
    });
  }

  void _showToast(String mssg){
    Fluttertoast.showToast(
      msg: mssg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    displayBill = totalBill.toStringAsFixed(2);
    displayNop = nop.toString();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            customBillList.clear();
            // Navigate back to the previous page.
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Results',
          style: TextStyle(
          color: MyColor.black,
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
      ),
      body: RepaintBoundary(
    key: _cardGlobalKey,
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: ListView(children: [
        Card(
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
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Bill',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(235, 240, 245, 1),
                          ),
                        ),
                        Text(
                          'RM $displayBill',
                          style: const TextStyle(
                            fontSize: 20,
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
                            fontSize: 20,
                            color: Color.fromRGBO(235, 240, 245, 1),
                          ),
                        ),
                        Text(
                          '$displayNop',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(235, 240, 245, 1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white, thickness: 1.0, height: 0,),
              Container(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 10.0),
                child: Column(
                  children: [
                    for (int i = 0; i < customBillList.length; i ++)
                      textResult(id: i, totalBill: totalBill),
                  ],
                ),
              ),
              Row(children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.transparent,
                  ),
                  onPressed: (){
                    customBillList.clear();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                          (route) => false,
                    );
                  },
                  child: Text(
                    'HOME',
                    style: TextStyle(
                      color: MyColor.primaryLight,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.transparent,
                  ),
                  onPressed: isButtonDisabled ? null : () {
                    _saveData();
                    _showToast("Save Successfully!");
                    _onButtonClicked();
                  },
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      color: textButtonColor,
                    ),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    visualDensity: VisualDensity.comfortable,
                  ),
                  onPressed: (){
                    _shareData();
                  },
                  child: Text(
                    'SHARE',
                    style: TextStyle(
                      color: MyColor.primaryLight,
                    ),
                  ),
                ),
              ],
              ),
            ],
          ),
        ),
      ],
      ),
    ),),
    );
  }

  Future<void> _shareData() async {
    await Future.delayed(Duration(milliseconds: 500)); // Add a slight delay (e.g., 500 milliseconds)
    // Share the card as an image
    final Uint8List? imageBytes = await _captureScreenshot();
    if (imageBytes != null) {
      final tempDir = await getTemporaryDirectory();
      final tempFile = await File('${tempDir.path}/shared_bill_card2.png').writeAsBytes(imageBytes);

      await FlutterShare.shareFile(
        title: "Shared Bill Card",
        filePath: tempFile.path,
      );
    }
    else{
      print('share error');
    }
  }

  final GlobalKey _cardGlobalKey = GlobalKey();

  Future<Uint8List?> _captureScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _cardGlobalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0); // You can adjust the pixelRatio as needed for image quality
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error capturing screenshot: $e');
      return null;
    }
  }

  Future<void> _saveData() async {
    List<String> StringcustomBillList = customBillList.map((double value) => value.toStringAsFixed(2)).toList();
    Map<String, dynamic> billData = {
      'totalBill': displayBill,
      'pax': displayNop,
      'bill': StringcustomBillList, // Using the predefined list for each entry
    };

    // Save the data to shared_preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedData = prefs.getStringList('billsList') ?? [];
    savedData.add(json.encode(billData));
    prefs.setStringList('billsList', savedData);

    billsList.add(billData);
  }

}