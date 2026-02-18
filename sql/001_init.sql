CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  avoid_repeated_challenges BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE challenges (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  points INTEGER NOT NULL,
  difficulty TEXT NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE daily_challenges (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  challenge_id INTEGER NOT NULL REFERENCES challenges(id),
  date DATE NOT NULL,
  completed BOOLEAN NOT NULL DEFAULT false,
  UNIQUE (user_id, date)
);

CREATE TABLE extra_challenges (
  id SERIAL PRIMARY KEY,
  from_user_id INTEGER NOT NULL REFERENCES users(id),
  to_user_id INTEGER NOT NULL REFERENCES users(id),
  challenge_id INTEGER NOT NULL REFERENCES challenges(id),
  status VARCHAR(20) NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE friendships (
  id SERIAL PRIMARY KEY,
  requester_id INTEGER NOT NULL REFERENCES users(id),
  addressee_id INTEGER NOT NULL REFERENCES users(id),
  status TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),

  CONSTRAINT unique_friendship UNIQUE (requester_id, addressee_id)
);

CREATE TABLE notifications (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

alter table notifications
add column notification_type TEXT;

alter table notifications
add CONSTRAINT chk_type CHECK(notification_type IN (
'extraChallengeReceived',
  'extraChallengeAccepted',
  'extraChallengeRejected',
  'extraChallengeCompleted',
  'friendshipRequest',
  'friendshipAccepted'))