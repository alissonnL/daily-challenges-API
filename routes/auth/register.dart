import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';

import '../../lib/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }

  final body = await context.request.body();
  final data = jsonDecode(body);

  final name = data['name'];
  final email = data['email'];
  final password = data['password'];

  if (name == null || email == null || password == null) {
    return Response.json(
      statusCode: 400,
      body: {'message': 'name, email and password are required'},
    );
  }

  try {
    final authService = context.read<AuthService>();

    final token = await authService.register(
      name: name.toString(),
      email: email.toString(),
      password: password.toString(),
    );

    return Response.json(
      statusCode: 201,
      body: {'token': token},
    );
  } catch (e) {
    return Response.json(
      statusCode: 400,
      body: {'message': e.toString()},
    );
  }
}
