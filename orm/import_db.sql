CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  associated_author VARCHAR(255) NOT NULL,
  
  FOREIGN KEY (associated_author) REFERENCES users(id)
);

CREATE TABLE question_follows (
  questions_id INTEGER NOT NULL,
  users_id INTEGER NOT NULL,
  
  FOREIGN KEY (users_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id)
);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY, 
  body TEXT NOT NULL, 
  questions_id INTEGER NOT NULL, 
  author_id INTEGER NOT NULL, 
  parent_reply_id INTEGER,
  
  FOREIGN KEY (author_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id)
);

CREATE TABLE question_likes (
  users_id INTEGER NOT NULL, 
  questions_id INTEGER NOT NULL, 
  
  FOREIGN KEY (users_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id)
);

INSERT INTO 
  users (fname,lname)
VALUES
  ("Shawn", "Salat"),
  ("Mitchell", "Underwood"),
  ("Frank", "Underwood"),
  ("Claire", "Underwood"),
  ("Ceasar", "Salat"),
  ("Billy", "Madison");
  
INSERT INTO 
  questions (title, body, associated_author)
VALUES 
  ("What is the Moon?", "What is the deal with the moon, is it like a big rock or is it cheese?", (SELECT id FROM users WHERE fname = "Mitchell")),
  ("What is Mars?", "What is the deal with Mars, is it like a big tomatoe?", (SELECT id FROM users WHERE fname = "Shawn")),
  ("Is peeing your pants cool?", "Cause if it is, I'm Miles Davis", (SELECT id FROM users WHERE fname = "Billy"));
  
INSERT INTO
  replies (body, questions_id, author_id)
VALUES
  ('The Moon is cheese, you IDIOT!',1,1);
  
  
  
