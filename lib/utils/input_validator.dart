import 'package:flutter/material.dart';

class InputValidator {
  /*
  Static functions to validate inputs from the user
  Every function should be of return type String and accept a String parameter
  
  Returns: Either null, i.e No error
  Or a String containing the error itself
  */

  static String validateAmount(String inputAmount) {
    if (inputAmount.isEmpty) {
      return 'Amount can\'t be empty';
    } else if (double.tryParse(inputAmount) == null) {
      return 'Amount has to be a number';
    } else {
      return null;
    }
  }

  static String validateDescription(String inputDescription) {
    if (inputDescription.isEmpty) {
      return 'Description can\'t be empty';
    }
    return null;
  }
}
