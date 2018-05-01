require 'sqlite3'
require_relative 'questions_db_connection'
require_relative 'question_follow_like'
require_relative 'reply'
require_relative 'questions'


class User
  attr_accessor :fname, :lname, :id
  
  def initialize(options)
    @id = options['id']
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
  
  def save
    if @id
      QuestionsDBConnection.instance.execute(<<-SQL,fname, lname, id)
        UPDATE users SET fname =?,lname = ? WHERE id = ?
      SQL
      #update
    else 
      QuestionsDBConnection.instance.execute(<<-SQL,fname, lname, id)
        INSERT INTO users (fname,lname,id) VALUES (?,?,?) 
      SQL
      @id = QuestionsDBConnection.instance.last_insert_row_id
    end 
  end 
  
  def authored_questions
    Question.find_by_author_id(@id)
  end
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end
  
  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end 
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end
  
  def average_karma
    qs = authored_questions
    sum = 0
    qs.each do |q|
      next unless q.num_likes 
      sum += q.num_likes
    end 
    sum/(qs.count) 
    
  end 
  
end