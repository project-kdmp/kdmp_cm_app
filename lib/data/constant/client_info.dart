class ClientInfo {
  static String _clientId = "";
  static String _clientVersion = "";

  static set setClientId(String value) => _clientId = value;

  static set setClientVersion(String value) => _clientVersion = value;

  static get clientId => _clientId;

  static get clientVersion => _clientVersion;
}
