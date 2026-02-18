import 'package:postgres/postgres.dart';
import 'package:dotenv/dotenv.dart';

class DatabaseConnection {
  static Connection? _connection;

  static Future<Connection> getConnection() async {
    if (_connection != null && _connection!.isOpen) {
      return _connection!;
    }

    final env = DotEnv()..load();

    _connection = await Connection.open(
      Endpoint(
        host: env['HOST'].toString(),
        port: int.parse(env['PORT'].toString()),
        database: env['DATABASE'].toString(),
        username: env['USERNAME'].toString(),
        password: env['PASSWORD'].toString(),
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
      ),
    );

    return _connection!;
  }
}
