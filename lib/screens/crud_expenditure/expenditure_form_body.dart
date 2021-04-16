import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure_item.dart';
import 'package:expenditure/services/database.dart';
import 'package:expenditure/utils/input_validator.dart';
import 'package:flutter/foundation.dart';
import 'mode_item.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// For DateFormat
import 'package:intl/intl.dart';

class ExpenditureFormBody extends StatefulWidget {
  final Expenditure expenditure;

  ExpenditureFormBody({this.expenditure});

  @override
  _ExpenditureFormBodyState createState() => _ExpenditureFormBodyState();
}

class _ExpenditureFormBodyState extends State<ExpenditureFormBody> {
  static const String TAG = 'ExpenditureFormBodyState';

  final GlobalKey<FormState> _addNewExpenditureFormKey = GlobalKey<FormState>();

  double _amount;
  Timestamp _timestamp = Timestamp.now();
  String _description;
  ModeItem _mode;
  // Geolocation _location;

  List<ModeItem> _modeItems = [];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController _dateTimeFieldController = TextEditingController(
      text: DateFormat.yMMMMd().add_jm().format(
            DateTime.now(),
          ));

  @override
  void initState() {
    if (widget.expenditure != null) {
      debugPrint('[info] Edit Expenditure called: ${widget.expenditure}');
      debugPrint('[debug] Building Timestamp Controller with initial data = '
          '${widget.expenditure.timestamp}');

      _dateTimeFieldController.text = widget.expenditure.timestampToString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[debug] building $TAG');
    if (_modeItems.isEmpty) {
      for (Map mode in PAYMENT_MODES) {
        _modeItems.add(ModeItem(name: mode['name'], icon: mode['icon']));
      }
      _mode = _modeItems.first;
    }

    return Expanded(
      child: Form(
        key: _addNewExpenditureFormKey,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildAmountField(),
                  _buildDescriptionField(),
                  _buildTimestampField(),
                  _buildModeField(),
                ],
              ),
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Amount',
          hintText: '0.00',
          prefixIcon: Icon(MdiIcons.currencyInr),
        ),
        validator: InputValidator.validateAmount,
        onSaved: (newValue) {
          _amount = double.parse(newValue.trim());
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: widget.expenditure != null ? widget.expenditure.amount.toString() : '',
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Description',
          prefixIcon: Icon(MdiIcons.textBox),
        ),
        validator: InputValidator.validateDescription,
        onSaved: (newValue) {
          _description = newValue.trim();
        },
        maxLines: 3,
        minLines: 1,
        initialValue: widget.expenditure != null ? widget.expenditure.description : '',
      ),
    );
  }

  Widget _buildTimestampField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
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
      ),
    );
  }

  Widget _buildModeField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<ModeItem>(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Payment Mode',
        ),
        items: _modeItems.map((item) {
          return DropdownMenuItem<ModeItem>(
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
      ),
    );
  }

  Widget _buildSaveButton() {
    return RaisedButton(
      onPressed: _onSavePressed,
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.indigo,
    );
  }

  void _onSavePressed() {
    debugPrint('[info] _onSavePressed()');
    if (!_addNewExpenditureFormKey.currentState.validate()) {
      return;
    }

    _addNewExpenditureFormKey.currentState.save();

    debugPrint('$TAG._onSavePressed called');

    Expenditure newExpenditure = Expenditure(
      amount: _amount,
      description: _description,
      mode: _mode.name,
      timestamp: _timestamp,
    );
    debugPrint('$TAG._onSavePressed.newExpenditure = '
        '${newExpenditure.toString()}');

    Future<DocumentReference> savedDocRef;

    if (widget.expenditure != null) {
      savedDocRef = DatabaseService.updateExpenditure(
        widget.expenditure,
        newExpenditure,
      );
    } else {
      savedDocRef = DatabaseService.addNewExpenditure(newExpenditure);
    }

    savedDocRef.then((_) {
      debugPrint('[info] AddNewExpenditure._onSavePressed :: '
          'Saved new expenditure successfully');
      debugPrint('[info] AddNewExpenditure._onSavePressed :: Resetting fields');
      _addNewExpenditureFormKey.currentState.reset();
      SnackBar _successSnackBar = SnackBar(
        content: Text('Expenditure saved successfully'),
      );
      Scaffold.of(context).showSnackBar(_successSnackBar);
      // TODO: Goto Home now
    }).catchError((error) {
      debugPrint('[error] Error occurred while saving new Expenditure');
      debugPrint('[error] Original error = $error');
      SnackBar _errorSnackBar = SnackBar(
        content: Text('Unable to save Expenditure, please try again'),
      );
      Scaffold.of(context).showSnackBar(_errorSnackBar);
    });
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

    final TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: _initialTime,
    );

    if (pickedDate != null) {
      setState(() {
        debugPrint('[debug] AddNewExpenditure._selectDate.pickedDate'
            ' = $pickedDate');
        selectedDate = pickedDate;
      });
    }

    if (pickedTime != null) {
      setState(() {
        debugPrint('[debug] AddNewExpenditure._selectDate.pickedTime'
            ' = $pickedTime');
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

    DateTime _selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    _timestamp = Timestamp.fromDate(_selectedDateTime);
    debugPrint('[debug] $TAG, setting selected DataTime = $_selectedDateTime');
    _dateTimeFieldController.text = DateFormat.yMMMMd().add_jm().format(
          _selectedDateTime,
        );
  }
}
