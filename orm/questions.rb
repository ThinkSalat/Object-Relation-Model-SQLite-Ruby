require 'sqlite3'
require_relative 'questions_db_connection'
require_relative 'user'
require_relative 'question_follow_like'
require_relative 'reply'

class Question
  attr_accessor :title, :body, :associated_author, :id 
  
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @associated_author = options['associated_author']
  end
  
  def self.find_by_id(id)
    question = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM questions WHERE id = ?
    SQL
    raise 'No Question with that id!' if  question.nil? 
    Question.new(question.first)
  end
  
  def self.find_by_author_id(author_id)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
    SELECT * FROM questions WHERE associated_author = ? 
    SQL
    raise "No questions from that author" if questions.empty? 
    questions.map do |question|
      Question.new(question)
    end 
  end
  
  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end 
  
  def author 
    User.find_by_id(@associated_author)
  end 
  
  def replies
    Reply.find_by_question_id(@id)
  end 
  
  def followers
    QuestionFollow.followers_for_question_id(@id)
  end 
  
  def likers
    QuestionLike.likers_for_question_id(@id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
  
  def most_liked(n)
    QuestionLike.most_liked_questions(n)
  end
  
  def save
    if @id
      QuestionsDBConnection.instance.execute(<<-SQL,title, body, associated_author, id)
        UPDATE questions SET title = ?, body = ?, associated_author = ? WHERE id = ?
      SQL
      #update
    else 
      QuestionsDBConnection.instance.execute(<<-SQL,title, body, associated_author)
        INSERT INTO questions (title, body, associated_author) VALUES (?,?,?)
      SQL
      @id = QuestionsDBConnection.instance.last_insert_row_id
    end 
  end 
  
end 
