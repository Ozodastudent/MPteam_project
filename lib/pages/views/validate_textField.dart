mixin InputValidation {
  String _confirmPassword = "";

  bool isPasswordValid(String password) {
    _confirmPassword = password;
    return password.length >= 8;
  }

  bool isConfirmPasswordValid(String confirmPassword){
   return confirmPassword == _confirmPassword;
  }

  bool isEmailValid(String email) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }
}