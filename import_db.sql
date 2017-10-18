DROP TABLE IF EXISTS users;

CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;


CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows(
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;


CREATE TABLE question_likes(
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ('The Builder', 'Bob'),  --user ID is 1
  ('Bird', 'Big'), --user ID is 2
  ('Totoro' ,'Ghibli');

INSERT INTO
  questions(title, body, user_id)
VALUES
  ('It''s broken', 'Can we fix it?', 1),
  ('Lost friend', 'Where''s Barney?', 2),
  ('hammer lost','plz help find thx',1),
  ('lost chick','awawef',2),
  ('Catbus missing', 'Where is the cat?', 3);

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  (1,1),
  (2,1), --this way big bird is also a follower
  (1,3),
  (2,4),
  (2,2),
  (3,5),
  (1,5),
  (2,5);

INSERT INTO
  replies(body,question_id,parent_reply_id,user_id)
VALUES
  ('yes we can!',1,NULL,2),
  ('r u sure bro',1,1,1),
  ('playing with some kids',2,NULL,1),
  ('found in sesame street',4,NULL,1),
  ('not on sesame street',5,NULL,2),
  ('not in sunflower valley',5,NULL,1);

INSERT INTO
  question_likes(user_id, question_id)
VALUES
  (1,5),
  (2,5),
  (3,5),
  (1,1),
  (2,1),
  (1,2),
  (2,3),
  (3,4);
