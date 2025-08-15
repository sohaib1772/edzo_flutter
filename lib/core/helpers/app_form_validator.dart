class AppFormValidator {
  static bool isEmpty(String value) => value.isEmpty || value.trim().isEmpty || value == null;
  static bool isEmailValid(String email) => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  static bool isPasswordValid(String password) => password.length >= 6 && password.contains(RegExp(r'[0-9]')) && password.contains(RegExp(r'[a-zA-Z]')) && password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  static bool isUsernameValid(String username) => username.length >= 3;

}