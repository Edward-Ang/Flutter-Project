import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:split_bill_app/combination.dart';
import 'package:split_bill_app/custom.dart';
import 'package:split_bill_app/history.dart';
import 'myColor.dart';
import 'dart:ui' as ui;
import 'dart:io';

List<Map<String, dynamic>> _billsList = [];

ButtonStyle homebutton = ButtonStyle(
  minimumSize: MaterialStateProperty.all(Size(200, 75)),
  padding: MaterialStateProperty.all(EdgeInsets.all(10)),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  ),
  backgroundColor: MaterialStateProperty.all(MyColor.primary),
  foregroundColor: MaterialStateProperty.all(Colors.white),
  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18)),
);

void main(){
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  // Load stored data when the app run
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load stored data function
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedData = prefs.getStringList('billsList') ?? [];

    for (String data in savedData) {
      Map<String, dynamic> billData = json.decode(data);
      _billsList.add(billData);
    }

    setState(() {

    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class DoubleInputValidator {
  static String? validate(String? value) {
    // check null input and empty input
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }

    // check null double input and double input less than zero
    final doubleVal = double.tryParse(value);
    if (doubleVal == null || doubleVal < 0) {
      return 'Please enter a valid number';
    }

    // check percentage input not exceed 100%
    if(status == '%'){
      if(doubleVal > 100){
        return 'Please enter a valid percentage';
      }
    }
    return null; // Return null if the input is valid
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/blue_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the equal split page.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EqualPage(),
                      ),
                    );
                  },
                  child: Hero(tag: 'equal_split_button',
                    child: Text(
                      'Equal Split',
                      style: TextStyle(
                        color: MyColor.grey_5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: homebutton,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the custom page.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomPage(billsList: _billsList,),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'custom_split_button',
                    child: Text(
                      'Custom Split',
                      style: TextStyle(
                      color: MyColor.grey_5,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  style: homebutton,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the combination page.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => combinationPage(billsList: _billsList,),
                      ),
                    );
                  },
                  child:  Hero(
                    tag: 'combination_split_button',
                    child: Text(
                      'Combination Split',
                      style: TextStyle(
                      color: MyColor.grey_5,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  style: homebutton,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the history page.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => History(),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'history_button',
                    child: Text(
                      'History',
                      style: TextStyle(
                      color: MyColor.grey_5,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  style: homebutton,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EqualPage extends StatefulWidget {
  @override
  State<EqualPage> createState() => _EqualPageState();
}

class _EqualPageState extends State<EqualPage> {
  double result = 0;
  String bill = '0', displayBill = '0', displayNop = '0';
  List<String> equalBillList = [];
  Color textButtonColor = MyColor.primaryLight;

  bool isButtonDisabled = false;

  // check is the save button is clicked
  void _onButtonClicked() {
    setState(() {
      isButtonDisabled = true;
      textButtonColor = MyColor.grey_60;
    });
  }

  // show toast message funtion
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
    final _formKey = GlobalKey<FormState>();
    String? _doubleValue, _intValue;
    int nop = 0;
    double total = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Equal Split',
          style: TextStyle(
          color: MyColor.black,
          fontWeight: FontWeight.bold,
        ),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Enter Total Bill',
                          border: OutlineInputBorder(),
                        ),
                        validator: DoubleInputValidator.validate,
                        onSaved: (value) {
                          _doubleValue = value;
                          total = double.tryParse(_doubleValue ?? '0') ?? 0;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Enter Number of Person',
                          border: OutlineInputBorder(),
                        ),
                        validator: DoubleInputValidator.validate,
                        onSaved: (value) {
                          _intValue = value;
                          nop = int.tryParse(_intValue ?? '0') ?? 0;
                          result = (total / nop); // calculate the equal break down result
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // Do something with the validated double value
                            result = (total / nop); // calculate the equal break down result
                            setState(() {
                              bill = result.toStringAsFixed(2);
                              displayBill = total.toStringAsFixed(2);
                              displayNop = nop.toString();
                              equalBillList.add(bill);
                            });
                            print(result);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColor.primaryDark,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text('Split',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
                RepaintBoundary(
                  key: _cardGlobalKey,
                  child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Card(
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
                                    'RM $displayBill',
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
                                    '$displayNop',
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
                          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Each Person Pay',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(235, 240, 245, 1),
                                    ),
                                  ),
                                  Text(
                                    'RM $bill',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(235, 240, 245, 1),
                                    ),
                                  ),
                                ],
                              ),
                              Row(children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.transparent,
                                  ),
                                  onPressed: (){
                                    Navigator.pop(context, '/');
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
                                  onPressed: isButtonDisabled ? null : (){
                                    if(displayBill != '0'){
                                      _saveData();
                                      equalBillList = [];
                                      _showToast("Save Successfully!");
                                      _onButtonClicked();
                                    }
                                    else{
                                      _showToast('Please enter inputs');
                                    }
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
                  ),
                ),
                ),
                SizedBox(height: 20),
              ],
            ),
        ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // share data function
  Future<void> _shareData() async {
    await Future.delayed(Duration(milliseconds: 500)); // Add a slight delay
    // Share the card as an image
    final Uint8List? imageBytes = await _captureScreenshot();
    if (imageBytes != null) {
      final tempDir = await getTemporaryDirectory();
      final tempFile = await File('${tempDir.path}/shared_bill_card.png').writeAsBytes(imageBytes);

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

  // capture screenshot function
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

  // save data function
  Future<void> _saveData() async {

    Map<String, dynamic> billData = {
      'totalBill': displayBill,
      'pax': displayNop,
      'bill': equalBillList, // Using the predefined list for each entry
    };

    // Save the data to shared_preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedData = prefs.getStringList('billsList') ?? [];
    savedData.add(json.encode(billData));
    prefs.setStringList('billsList', savedData);

    _billsList.add(billData);
  }
}