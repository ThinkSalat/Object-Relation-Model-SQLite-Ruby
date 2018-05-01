require 'sqlite3'
require_relative 'questions_db_connection'
require_relative 'user'
require_relative 'questions'
require_relative 'reply'

require 'byebug'

class QuestionFollow 
  attr_accessor :users_id, :questions_id 
  
  def initialize(options)
    @users_ids = options['users_ids']
    @questions_id = options['questions_id']
  end 
  
   def self.most_followed_questions(n)
     questions = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT * FROM question_follows GROUP BY questions_id ORDER BY COUNT(*) DESC LIMIT ?
     SQL
     questions.map do |question|
       Question.find_by_id(question['questions_id'])
     end
   end 

   def self.followers_for_question_id(questions_id)
     followers = QuestionsDBConnection.instance.execute(<<-SQL, questions_id)
      SELECT users_id FROM question_follows WHERE questions_id = ?
     SQL
     raise 'This questions has no followers' if followers.empty?
     followers.map do |follower|
       User.find_by_id(follower['users_id'])
     end
   end 
   
   def self.followed_questions_for_user_id(users_id)
     questions = QuestionsDBConnection.instance.execute(<<-SQL, users_id)
      SELECT questions_id FROM question_follows WHERE users_id = ?
     SQL
     raise 'This user is following no questions' if questions.empty?
     questions.map do |question|
       Question.find_by_id(question['questions_id'])
     end
   end
   
end 

class QuestionLike 
  attr_accessor :users_id, :questions_id 
  
  def initialize(options)
    @users_ids = options['users_ids']
    @questions_id = options['questions_id']
  end
  
  def self.likers_for_question_id(id)
    likers = QuestionsDBConnection.instance.execute(<<-SQL, id)
     SELECT users_id FROM question_likes WHERE questions_id = ?
    SQL
    raise 'This question has no likes' if likers.empty?
    likers.map do |liker|
      User.find_by_id(liker['users_id'])
    end
  end
  
  def self.num_likes_for_question_id(id)
    likes = QuestionsDBConnection.instance.execute(<<-SQL, id)
     SELECT COUNT(*) as num FROM question_likes WHERE questions_id = ?
    SQL
    likes.first['num']
  end
  
  def self.liked_questions_for_user_id(id)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, id)
     SELECT questions_id FROM question_likes WHERE users_id = ?
    SQL
    raise 'This user has not liked any questions' if questions.empty?
    questions.map do |question|
      Question.find_by_id(question['questions_id'])
    end
  end
  
  def self.most_liked_questions(n)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, n)
     SELECT * FROM question_likes GROUP BY questions_id ORDER BY COUNT(*) DESC LIMIT ?
    SQL
    questions.map do |question|
      Question.find_by_id(question['questions_id'])
    end
  end 
  
end
  