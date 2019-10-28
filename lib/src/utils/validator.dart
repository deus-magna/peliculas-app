class FieldValidator {

  static String validateName(String value) {

    if (value.isEmpty) return 'Ingresa un correo electronico';

    return null;
  }

  static String validateEmail(String value) {

    if (value.isEmpty) return 'Ingresa un correo electronico';

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value.trim())) {
      return 'Ingresa una dirección de correo valida';
    }

    return null;
  }

  /// Password matching expression. Password must be at least 4 characters,
  /// no more than 8 characters, and must include at least one upper case letter,
  /// one lower case letter, and one numeric digit.
  static String validatePassword(String value) {

    if (value.isEmpty) return 'Ingresa una contraseña';

    Pattern pattern = r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{4,6}$';

    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value.trim())) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    return null;
  }
}