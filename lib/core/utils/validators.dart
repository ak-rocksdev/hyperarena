/// Form validators with Indonesian error messages.
/// Returns null if valid, error string if invalid.
abstract final class Validators {
  static final _emailRegex = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w{2,}$');
  static final _phoneRegex = RegExp(r'^(\+62|62|08)\d{8,12}$');

  static String? required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'Wajib diisi' : null;

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    if (!_emailRegex.hasMatch(value.trim())) return 'Email tidak valid';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');
    if (!_phoneRegex.hasMatch(cleaned)) return 'Nomor telepon tidak valid';
    return null;
  }

  static String? Function(String?) minLength(int min) => (String? value) {
        if (value == null || value.trim().isEmpty) return 'Wajib diisi';
        if (value.trim().length < min) return 'Minimal $min karakter';
        return null;
      };

  static String? Function(String?) passwordMatch(String password) =>
      (String? value) {
        if (value == null || value.trim().isEmpty) return 'Wajib diisi';
        if (value != password) return 'Password tidak cocok';
        return null;
      };
}
