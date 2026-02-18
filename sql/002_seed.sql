-- USERS
INSERT INTO users (name, email, avoid_repeated_challenges)
VALUES
  ('João', 'joao@email.com', false),
  ('Maria', 'maria@email.com', true);

-- CHALLENGES
INSERT INTO challenges (title, description, points, difficulty)
VALUES
  ('Leia 5 páginas', 'Leia qualquer livro', 10, 'easy'),
  ('Organize sua mesa', 'Arrume seu espaço de trabalho', 15, 'easy'),
  ('Caminhe 10 minutos', 'Faça uma caminhada leve', 20, 'medium'),
  ('Aprenda uma palavra nova', 'Estude uma palavra nova', 10, 'easy'),
  ('Faça 20 flexões', 'Exercício físico', 30, 'hard');
