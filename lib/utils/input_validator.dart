class InputValidator {
  /*
  Static functions to validate inputs from the user
  Every function should be of return type String and accept a String parameter

  Returns: Either null i.e No error,
  Or a String containing the error itself
  */

  static String validateAmount(String inputAmount) {
    if (inputAmount.isEmpty) {
      return 'Amount can\'t be empty';
    }
    double _amount = double.tryParse(inputAmount);
    if (_amount == null) {
      return 'Amount has to be a number';
    } else if (_amount > 1000000) {
      return 'Bruh! You don\'t need this app, you have enough';
    }
    return null;
  }

  static String validateDescription(String inputDescription) {
    if (inputDescription.isEmpty) {
      return 'Description can\'t be empty';
    }
    return null;
  }
}
