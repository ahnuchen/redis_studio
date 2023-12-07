import 'dart:convert';

class ConnectionsModel {
  List<ConnectionConfig> connections = [];

  ConnectionsModel({
    required this.connections,
  });

  ConnectionsModel copyWith({
    List<ConnectionConfig>? connections,
  }) =>
      ConnectionsModel(
        connections: connections ?? this.connections,
      );

  factory ConnectionsModel.fromRawJson(String str) =>
      ConnectionsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConnectionsModel.fromJson(Map<String, dynamic> json) =>
      ConnectionsModel(
        connections: json["connections"] == null
            ? []
            : List<ConnectionConfig>.from(
                json["connections"]!.map((x) => ConnectionConfig.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "connections": connections == null
            ? []
            : List<dynamic>.from(connections!.map((x) => x.toJson())),
      };
}

class ConnectionConfig {
  String? host;
  int? port;
  String? auth;
  String? username;
  String? name;
  String? separator;
  bool? cluster;
  bool? connectionReadOnly;
  String? key;
  int? order;

  ConnectionConfig({
    this.host,
    this.port,
    this.auth,
    this.username,
    this.name,
    this.separator,
    this.cluster,
    this.connectionReadOnly,
    this.key,
    this.order,
  });

  ConnectionConfig copyWith({
    String? host,
    int? port,
    String? auth,
    String? username,
    String? name,
    String? separator,
    bool? cluster,
    bool? connectionReadOnly,
    String? key,
    int? order,
  }) =>
      ConnectionConfig(
        host: host ?? this.host,
        port: port ?? this.port,
        auth: auth ?? this.auth,
        username: username ?? this.username,
        name: name ?? this.name,
        separator: separator ?? this.separator,
        cluster: cluster ?? this.cluster,
        connectionReadOnly: connectionReadOnly ?? this.connectionReadOnly,
        key: key ?? this.key,
        order: order ?? this.order,
      );

  factory ConnectionConfig.fromRawJson(String str) =>
      ConnectionConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConnectionConfig.fromJson(Map<String, dynamic> json) => ConnectionConfig(
        host: json["host"],
        port: json["port"],
        auth: json["auth"],
        username: json["username"],
        name: json["name"],
        separator: json["separator"],
        cluster: json["cluster"],
        connectionReadOnly: json["connectionReadOnly"],
        key: json["key"],
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
        "host": host,
        "port": port,
        "auth": auth,
        "username": username,
        "name": name,
        "separator": separator,
        "cluster": cluster,
        "connectionReadOnly": connectionReadOnly,
        "key": key,
        "order": order,
      };
}
