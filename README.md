# Challenge App

Aplicação mobile gamificada baseada em desafios diários e extras, com interação social entre amigos.

## Arquitetura

- Backend: Dart Frog + PostgreSQL
- Mobile: Flutter
- Autenticação: JWT

## Estrutura

routes/
├── auth/
│   ├── login.dart
│   └── register.dart
├── daily-challenge/
│   ├── index.dart
│   └── completed.dart
├── extra-challenges/
│   ├── send.dart
│   ├── pending.dart
│   ├── accept.dart
│   ├── reject.dart
│   └── complete.dart
├── friends/
│   ├── request.dart
│   ├── accept.dart
│   ├── reject.dart
│   └── pending.dart
└── me/
    ├── index.dart
    └── notifications/
        ├── index.dart
        └── read.dart

## Autenticação
A API utiliza token JWT.
O token é retornado no login
Deve ser enviado no header:
	Authorization: Bearer <token>

ROTAS

**Login**
POST /auth/login

 BODY
{
  "email": "user@email.com",
  "password": "123456"
}

**Cadastro**
POST /auth/register

 BODY
{
  "name": "João",
  "email": "joao@email.com",
  "password": "123456"
}

**Dados do usuário logado**
GET /me

 BODY
{
  "toUserId": 2
}

**ENVIAR SOLICITAÇÃO
POST /friends/request 

**Aceitar solicitação**
PATCH /friends/[id]/accept

**Rejeitar solicitação**
PATCH /friends/[id]/reject

**Listar amigos**
GET /friends

**Solicitações pendentes**
GET /friends/pending

**Obter desafio diário**
GET /daily-challenge

**Concluir desafio diário**
PATCH /daily-challenge/complete

**Enviar desafio extra**
POST /extra-challenges/send

 BODY
{
  "challengeId": 1,
  "toUserIds": [2, 3]
}

**Desafios pendentes**
GET /extra-challenges/pending

**Aceitar desafio**
POST /extra-challenges/[id]/accept

**Rejeitar desafio**
POST /extra-challenges/[id]/reject

**Concluir desafio**
POST /extra-challenges/[id]/complete

**Desafios aceitos**
GET /extra-challenges

**Desafios completos anteriormente**
GET /extra-challenges/completed 

## Como Executar o Projeto

cd backend
dart_frog dev

Servidor disponível em:
http://localhost:8080
ou
http://seuip:8080

## Próximas evoluções

Ranking global
Sistema de conquistas
IA para criação dinâmica de desafios
Histórico de desafios
