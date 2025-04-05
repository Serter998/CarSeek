abstract class Failure {
  final String? customMessage;
  final String? errorCode;
  final int? statusCode;

  String get defaultMessage;

  String get message => customMessage ?? defaultMessage;

  const Failure({
    this.customMessage,
    this.errorCode,
    this.statusCode,
  });
}