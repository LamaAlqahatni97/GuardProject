class CustomAuthResult {
  bool result;
  String message;

  CustomAuthResult({this.message, this.result});

  CustomAuthResult.fromErrorCode(String errorCode) {
    //TODO add all the other messages
    this.result = false;
    switch (errorCode) {
      case "ERROR_INVALID_EMAIL":
        this.message = "Your email address appears to be malformed.";
        break;
      case "ERROR_WEAK_PASSWORD":
        this.message = "Your password is weak.";
        break;

      case "ERROR_EMAIL_ALREADY_IN_USE":
        this.message = "An account with this email already exists.";
        break;

        break;
      case "ERROR_WRONG_PASSWORD":
        this.message = "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        this.message = "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        this.message = "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        this.message = "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        this.message = "Signing in with Email and Password is not enabled.";
        break;
      default:
        this.message = "An undefined Error happened.";
    }
  }
}
