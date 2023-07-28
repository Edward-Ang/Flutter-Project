import 'package:flutter/material.dart';
import 'package:split_bill_app/combinationResult.dart';
import 'main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'myColor.dart';

List<double> result = [];

class combinationPage extends StatefulWidget {
  final List<Map<String, dynamic>> billsList;

  combinationPage({required this.billsList});

  @override
  State<combinationPage> createState() => _combinationPageState(billsList: billsList);
}

class _combinationPageState extends State<combinationPage>{
  final List<Map<String, dynamic>> billsList;

  _combinationPageState({required this.billsList});

  String? bill = '0', displayBill = '0', displayNop = '0';

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? _doubleValue, _intValue;
    int nop = 0;
    double total = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Combination Split',
          style: TextStyle(
            color: MyColor.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous page.
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
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
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() {
                          displayBill = total.toStringAsFixed(2);
                          displayNop = nop.toString();
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => combinationSplit(totalBill: total, nop: nop, billsList: billsList,),
                          ),
                        );
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
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class combinationSplit extends StatefulWidget{
  final double totalBill;
  final int nop;
  final List<Map<String, dynamic>> billsList;
  combinationSplit({super.key, required this.totalBill, required this.nop, required this.billsList});

  @override
  State<combinationSplit> createState() => combinationSplitState(totalBill: totalBill, nop: nop, billsList: billsList);
}

class InputData {
  double value;
  String state;

  InputData(this.value, this.state);
}

class combinationSplitState extends State<combinationSplit> {
  final double totalBill;
  final int nop;
  final List<Map<String, dynamic>> billsList;

  combinationSplitState({required this.totalBill, required this.nop, required this.billsList});

  String displayBill = '0';
  String cstatus = 'RM';
  List<InputData> inputDataList = [];

  @override
  void initState() {
    super.initState();
    // Initialize inputDataList with the desired number of inputs
    for (int i = 0; i < nop; i++) {
      inputDataList.add(InputData(0, 'RM'));
    }
  }

  void _toggleInputState(int index) {
    setState(() {
      inputDataList[index].state =
      inputDataList[index].state == 'RM' ? '%' : 'RM';
    });
  }

  void clearList() {
    setState(() {
      result.clear();
    });
  }

  void _showToast(String mssg) {
    Fluttertoast.showToast(
      msg: mssg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );
  }

  bool checkcombinationAmount() {
    double sum = result.reduce((value, element) => value + element);
    if (sum > totalBill) {
      _showToast("Exceed Total Bill");
      result.clear();
      return false;
    }
    else if (sum < totalBill) {
      _showToast("Less Than Total Bill");
      result.clear();
      return false;
    }
    else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    displayBill = totalBill.toStringAsFixed(2);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Combination Split',
          style: TextStyle(
            color: MyColor.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  color: MyColor.primary,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Bill',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'RM $displayBill',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
              itemCount: nop,
              itemBuilder: (context, index) => _buildInputField(index),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColor.primary,
        onPressed: () {
            //add input into result
            for (int i = 0; i < inputDataList.length; i++) {
              if (inputDataList[i].state == 'RM') {
                result.add(inputDataList[i].value);
              }
              else {
                result.add(inputDataList[i].value / 100 * totalBill);
              }
            }

            if (checkcombinationAmount() == true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CombinationResult(totalBill: totalBill, nop: nop, billsList: billsList,),
                ),
              );
            }
            else {
              print('error');
            }
          },
        tooltip: 'nextpage',
        child: const Icon(Icons.arrow_forward_outlined),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildInputField(int index) {
    String? doubleVal;
    int id = index + 1;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Person $id: ' + inputDataList[index].state,
                border: OutlineInputBorder(),
              ),
              validator: DoubleInputValidator.validate,
              onChanged: (value) {
                setState(() {
                  doubleVal = value;
                  inputDataList[index].value = double.tryParse(doubleVal ?? '0') ?? 0;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => _toggleInputState(index),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(inputDataList[index].state), // <-- Text
                SizedBox(
                  width: 5,
                ),
                Icon( // <-- Icon
                  Icons.repeat,
                  size: 24.0,
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColor.black,
              foregroundColor: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}