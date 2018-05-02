require 'sqlite3'
require_relative 'questions_db_connection'
require_relative 'questions'
require_relative 'user'
require_relative 'question_follow_like'
require_relative 'superclass'

class Reply < ModelBase 
  attr_accessor :body, :questions_id, :author_id, :parent_reply_id, :id 
  
  def initialize(options) 
    @id = options['id'] 
    @body = options['body']
    @questions_id = options['questions_id']
    @author_id = options['author_id']
    @parent_reply_id = options['parent_reply_id'] 
  end
  # 
  # def self.find_by_id(id)
  #   reply = QuestionsDBConnection.instance.execute(<<-SQL, id)
  #     SELECT * FROM replies WHERE id = ?
  #   SQL
  #   raise 'No replies with that id!' if  reply.nil? 
  #   Reply.new(reply.first)
  # end
  # 
  def self.find_by_user_id(author_id)
    replies = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
    SELECT * FROM replies WHERE author_id = ? 
    SQL
    raise "No replies from that user" if replies.empty? 
    replies.map do |reply|
      Reply.new(reply)
    end 
  end
  
  def self.find_by_question_id(questions_id)
    replies = QuestionsDBConnection.instance.execute(<<-SQL, questions_id)
    SELECT * FROM replies WHERE questions_id = ? 
    SQL
    raise "No replie for that question" if replies.empty? 
    replies.map do |reply|
      Reply.new(reply)
    end 
  end
  
  def author 
    User.find_by_id(@author_id)
  end 
  
  def question
    Question.find_by_id(@questions_id)
  end 
  
  def parent_reply 
    raise "No parent" if @parent_reply_id.nil?
    Reply.find_by_id(@parent_reply_id)
  end  
  
  def child_replies 
    child_replies = QuestionsDBConnection.instance.execute(<<-SQL, @id)
    SELECT * FROM replies WHERE parent_reply_id = ? 
    SQL
    raise "No child replies for that reply" if child_replies.empty? 
    child_replies.map do |reply|
      Reply.new(reply)
    end 
  end 

  def save
    if @id
      QuestionsDBConnection.instance.execute(<<-SQL,body, questions_id, author_id, parent_reply_id, id )
        UPDATE replies SET body = ?, questions_id = ?, author_id = ?, parent_reply_id = ?  WHERE id = ?
      SQL
      #update
    else 
      QuestionsDBConnection.instance.execute(<<-SQL,body, questions_id, author_id, parent_reply_id)
        INSERT INTO replies (body, questions_id, author_id, parent_reply_id) VALUES (?,?,?,?)
      SQL
      @id = QuestionsDBConnection.instance.last_insert_row_id
      #create 
    end 
       
  end 

end 
