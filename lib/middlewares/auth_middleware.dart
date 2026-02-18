import 'package:dart_frog/dart_frog.dart';
import '../services/jwt_service.dart';

Handler authMiddleware(Handler handler) {
  return (context) async {
    final authHeader = context.request.headers['authorization'];

    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response.json(
        statusCode: 401,
        body: {'message': 'Missing or invalid Authorization header'},
      );
    }

    final token = authHeader.replaceFirst('Bearer ', '');

    try {
      final jwtService = context.read<JwtService>();
      final userId = jwtService.verifyAndExtractUserId(token);

      // Injeta userId no contexto
      final updatedContext = context.provide<int>(() => userId);

      return handler(updatedContext);
    } catch (e) {
      return Response.json(
        statusCode: 401,
        body: {'message': 'Invalid or expired token'},
      );
    }
  };
}
