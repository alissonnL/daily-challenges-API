-- Daily challenges for João (user_id = 1)
INSERT INTO daily_challenges (user_id, challenge_id, date, completed)
VALUES
  (1, 1, CURRENT_DATE - INTERVAL '2 days', true),
  (1, 2, CURRENT_DATE - INTERVAL '1 day', true);

-- Daily challenges for Maria (user_id = 2)
INSERT INTO daily_challenges (user_id, challenge_id, date, completed)
VALUES
  (2, 3, CURRENT_DATE - INTERVAL '1 day', false);
