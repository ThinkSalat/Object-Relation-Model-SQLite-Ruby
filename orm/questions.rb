require 'sqlite3'
require 'singleton'

class QuestionsDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class User
  attr_accessor :fname, :lname
  
  def initialize(options)
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def self.find_by_id(id)
    user = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM users WHERE id = ?
    SQL
    raise 'No User with that id!' if  user.nil? 
    User.new(user.first)
  end
  
  def self.find_by_name(fname, lname)
    user = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT * FROM users WHERE fname = ? AND lname = ?
    SQL
    raise 'No User with that name!' if  user.nil? 
    User.new(user.first)
  end
end

class Question
  attr_accessor :title, :body, :associated_author
  
  def initialize(options)
    @title = options['title']
    @body = options['body']
    @associate_author = options['associated_author']
  end
  
  def self.find_by_id(id)
    question = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM questions WHERE id = ?
    SQL
    raise 'No Question with that id!' if  question.nil? 
    Question.new(question.first)
  end
end 

class Reply
  attr_accessor :body, :questions_id, :author_id, :parent_reply_id
  
  def initialize(options)  
    @body = options['body']
    @questions_id = options['questions_id']
    @author_id = options['author_id']
    @parent_reply_id = options['parent_reply_id'] 
  end
  
  def self.find_by_id(id)
    reply = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM replies WHERE id = ?
    SQL
    raise 'No replies with that id!' if  reply.nil? 
    Reply.new(reply.first)
  end
end 
