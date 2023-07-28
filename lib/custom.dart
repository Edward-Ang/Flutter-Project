import 'package:flutter/material.dart';
import 'package:split_bill_app/customResult.dart';
import 'main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'myColor.dart';

List<double> customBillList = [];
List<double> percentageList = [];
String status = 'RM';

class CustomPage extends StatefulWidget {
  final List<Map<String, dynamic>> billsList;

  CustomPage({required this.billsList});
  @override
  State<CustomPage> createState() => _CustomPageState(billsList: billsList);
}

class _CustomPageState extends State<CustomPage>{
  final List<Map<String, dynamic>> billsList;
  _CustomPageState({required this.billsList});
  double result = 0;
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
          'Custom Split',
          style: TextStyle(
          color: MyColor.black,
          fontWeight: FontWeight.bold,
        ),),
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
                      result = (total / nop);
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        result = (total / nop);
                        setState(() {
                          bill = result.toStringAsFixed(2);
                          displayBill = total.toStringAsFixed(2);
                          displayNop = nop.toString();
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomSplit(totalBill: total, nop: nop, billsList: billsList),
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

class PersonInput extends StatefulWidget {
  final int id;
  final double totalBill;

  PersonInput({required this.id, required this.totalBill});

  @override
  State<PersonInput> createState() => PersonInputState(id: id, totalBill: totalBill);
}

class PersonInputState extends State<PersonInput> {
  String? _doubleValue;
  double total = 0;
  final int id;
  final double totalBill;

  PersonInputState({required this.id, required this.totalBill});

  final _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: 'Person $id: ' + status,
          border: OutlineInputBorder(),
        ),
        validator: DoubleInputValidator.validate,
        onSaved: (value) {
          _doubleValue = value;
          if(status == 'RM'){
            customBillList.add(double.parse(_doubleValue ?? '0') ?? 0);
          }
          else{
            double percent;
            percent = double.tryParse(_doubleValue ?? '0') ?? 0;
            percentageList.add(percent);
            double processedPercent = percent / 100 * totalBill;
            customBillList.add(processedPercent);
          }
        },
      ),
    );
  }
}

class CustomSplit extends StatefulWidget{
  final double totalBill;
  final int nop;
  final List<Map<String, dynamic>> billsList;

  CustomSplit({super.key, required this.totalBill, required this.nop, required this.billsList});

  @override
  State<CustomSplit> createState() => CustomSplitState(totalBill: totalBill, nop: nop, billsList: billsList);
}

class CustomSplitState extends State<CustomSplit> {
  final double totalBill;
  final int nop;
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> billsList;

  String displayBill = '0';

  CustomSplitState({required this.totalBill, required this.nop, required this.billsList});

  void clearList() {
    setState(() {
      customBillList = [];
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

  bool checkCustomAmount(){
    // check status is RM
    if(status == 'RM'){
      double sumA = customBillList.reduce((value, element) => value + element);
      print('sumA: $sumA');
      if(sumA > totalBill){ // sum of input exceed total bill
        _showToast("Exceed Total Bill");
        customBillList.clear();
        return false;
      }
      else if(sumA < totalBill){ // sum of input less than total bill
        _showToast("Less Than Total Bill");
        customBillList.clear();
        return false;
      }
      else{
        return true;
      }
    }
    else{
      double sumP = percentageList.reduce((value, element) => value + element);
      print('sumA: $sumP');
      if(sumP > 100){ // sum of input more than 100%
        _showToast("Exceed 100%");
        percentageList.clear();
        return false;
      }
      else if(sumP < 100){ // sum of input less than 100%
        _showToast("Less Than 100%");
        percentageList.clear();
        return false;
      }
      else{
        return true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    displayBill = totalBill.toStringAsFixed(2);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Custom Split',
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if(status == 'RM'){
                        status = '%';
                      }
                      else if(status == '%'){
                        status = 'RM';
                      }
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(status), // <-- Text
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
            SizedBox(height: 8),
            Expanded(
              child:Form(
                key: _formKey,
                child: ListView.builder(
                  itemCount: nop,
                  itemBuilder: (context, index) {
                    return PersonInput(id: (index + 1), totalBill: totalBill,);
                    },
                  ),
                ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColor.primary,
        onPressed: (){
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            if(checkCustomAmount() == true){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => CustomResult(totalBill: totalBill, nop: nop, billsList: billsList),
                ),
              );
            }
          }
          else{
            print('error');
          }
        },
        tooltip: 'arrow',
        child: const Icon(Icons.arrow_forward_outlined),
        foregroundColor: Colors.white,
      ),
    );
  }
}
