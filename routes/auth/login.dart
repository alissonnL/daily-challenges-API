import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../lib/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }

  final body = await context.request.body();
  final data = jsonDecode(body);

  final email = data['email'];
  final password = data['password'];

  if (email == null || password == null) {
    return Response.json(
      statusCode: 400,
      body: {'message': 'Email and password required'},
    );
  }

  try {
    final authService = context.read<AuthService>();
    final token = await authService.login(
      email: email.toString(),
      password: password.toString(),
    );

    return Response.json(body: {'token': token});
  } catch (e) {
    return Response.json(
      statusCode: 401,
      body: {'message': '$e'},
    );
  }
}
