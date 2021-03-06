class Response<T> {
  bool _isSuccess;
  String _errorMessage;
  T value;

  Response() {
    _isSuccess = true;
    _errorMessage = null;
    value = null;
  }

  Response.fromResponse(Response response) {
    if (response.isSuccess)
      Response.success(response.value);
    else
      Response.error(response.errorMessage);
  }

  Response.success(this.value) {
    _isSuccess = true;
  }

  Response.error(this._errorMessage) {
    _isSuccess = false;
    value = null;
  }

  bool get isSuccess => _isSuccess;
  String get errorMessage => _errorMessage;
}
