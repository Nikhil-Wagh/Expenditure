import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure.dart';
import 'package:expenditure/services/database.dart';
import 'package:expenditure/utils/input_validator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:intl/intl.dart';

class AddNewExpenditure extends StatefulWidget {
  @override
  _AddNewExpenditureState createState() => _AddNewExpenditureState();
}

class _AddNewExpenditureState extends State<AddNewExpenditure> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: mMargin, right: mMargin, top: mMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AddNexExpenditureAppBar(),
            AddNewExpenditureBody()
          ],
        ));
  }
}

class AddNexExpenditureAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(24.0),
      child: Stack(
        children: [
          Icon(
            Icons.arrow_back,
            size: 24.0,
          ),
          // SizedBox(width: 16),
          Center(
            child: Text(
              'Add New Expenditure',
              style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

class AddNewExpenditureBody extends StatefulWidget {
  @override
  _AddNewExpenditureBodyState createState() => _AddNewExpenditureBodyState();
}

class _AddNewExpenditureBodyState extends State<AddNewExpenditureBody> {
  GlobalKey _addNexExpenditureFormKey = GlobalKey<FormState>();

  double _amount;
  Timestamp _timestamp = Timestamp.now();
  String _description;
  Item _mode;
  // Geolocation _location;

  List<Item> _modeItems = [];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController _dateTimeFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    debugPrint('[debug] building AddNewExpenditureBody');
    if (_modeItems.isEmpty)
      for (Map mode in PAYMENT_MODES) {
        _modeItems.add(Item(name: mode['name'], icon: mode['icon']));
      }

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Form(
                // key: _addNexExpenditureFormKey,
                child: Column(
                  children: [
                    _amountField(),
                    SizedBox(height: 12),
                    _descriptionField(),
                    SizedBox(height: 12),
                    _timestampField(),
                    SizedBox(height: 14),
                    _modeField(),
                  ],
                ),
              ),
            ),
            RaisedButton(
              onPressed: _onSavePressed,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _amountField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Amount',
        hintText: '0.00',
        prefixIcon: Icon(MdiIcons.currencyInr),
      ),
      validator: InputValidator.validateAmount,
      onChanged: (val) {
        setState(() {
          _amount = double.parse(val.trim());
        });
      },
    );
  }

  Widget _descriptionField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Description',
        prefixIcon: Icon(MdiIcons.textBox),
      ),
      validator: InputValidator.validateDescription,
      onChanged: (val) {
        setState(() {
          _description = val.trim();
        });
      },
      maxLines: 3,
      minLines: 3,
      textAlignVertical: TextAlignVertical.center,
    );
  }

  Widget _timestampField() {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Timestamp',
        prefixIcon: Icon(MdiIcons.clock),
      ),
      onTap: () {
        _selectDate(context);
      },
      controller: _dateTimeFieldController,
    );
  }

  Widget _modeField() {
    return DropdownButtonFormField<Item>(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Payment Mode',
          prefixIcon: Icon(
            MdiIcons.function,
          )),
      items: _modeItems.map((item) {
        return DropdownMenuItem<Item>(
          value: item,
          child: Row(
            children: [
              Icon(item.icon),
              SizedBox(width: 12),
              Text(item.name),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          debugPrint('AddNewExpenditure.modeField updated');
          debugPrint('value = ${value.name} ${value.icon}');
          _mode = value;
        });
      },
      value: _mode,
    );
  }

  void _onSavePressed() {
    Expenditure newExpenditure = Expenditure(
      amount: _amount,
      description: _description,
      mode: _mode.name,
      timestamp: _timestamp,
    );

    debugPrint('AddNewExpenditure._onSavePressed called');
    debugPrint('AddNewExpenditure._onSavePressed.newExpenditure = '
        '${newExpenditure.toString()}');
    DatabaseService.addNewExpenditure(newExpenditure);
  }

  void _selectDate(BuildContext context) async {
    final DateTime _firstDate = DateTime(
      selectedDate.year - 10,
      selectedDate.month,
      selectedDate.day,
    );
    final DateTime _lastDate = DateTime(
      selectedDate.year + 10,
      selectedDate.month,
      selectedDate.day,
    );

    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: _firstDate,
      lastDate: _lastDate,
    );

    final TimeOfDay _initialTime = selectedTime;

    final TimeOfDay pickedTime = await showTimePicker(context: context, initialTime: _initialTime);

    if (pickedDate != null) {
      setState(() {
        debugPrint('[debug] AddNewExpenditure._selectDate.pickedDate = $pickedDate');
        selectedDate = pickedDate;
      });
    }

    if (pickedTime != null) {
      setState(() {
        debugPrint('[debug] AddNewExpenditure._selectDate.pickedTime = $pickedTime');
        _timestamp = Timestamp.fromDate(DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        ));
        selectedTime = pickedTime;
      });
    }

    DateTime _selectedTimestamp = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    _timestamp = Timestamp.fromDate(_selectedTimestamp);
    _dateTimeFieldController.text = DateFormat.yMMMMd().add_jm().format(
          _selectedTimestamp,
        );
  }
}

class Item {
  final String name;
  final IconData icon;

  Item({this.name, this.icon});
}
