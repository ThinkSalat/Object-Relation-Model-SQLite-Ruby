require 'sqlite3'
require_relative 'questions_db_connection'


class ModelBase
  CLASS_TABLES = {
 'Question' => 'questions',
 'Reply' => 'replies',
 'User' => 'users',
 'QuestionFollow' => 'question_follows',
 'QuestionLike' => 'question_likes'
 }
  def self.find_by_id(id)
    table = CLASS_TABLES[self.to_s]

    results = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM #{table} WHERE id = ?
    SQL
    raise 'No results with that id!' if  results.nil? 
    self.new(results.first)
  end
  
  def self.all 
    table = CLASS_TABLES[self.to_s]

    results = QuestionsDBConnection.instance.execute(<<-SQL)
      SELECT * FROM #{table} 
    SQL
    results.map do |result|
      self.new(result)
    end 
  end 
  
  def self.where(options)
    table = CLASS_TABLES[self.to_s]
    qry = "SELECT * FROM #{table} WHERE "
    arr = []
    options.each do |k,v| 
      arr << "#{k.to_s} = '#{v.to_s}'" 
    end
    qry += arr.join(' AND ')
    puts qry
    results = QuestionsDBConnection.instance.execute(qry)
    results
  end
  
  def save
    table = CLASS_TABLES[self.to_s]
      
  #update language 
    UPDATE table SET ...Interp.... WHERE .... 
  #create langauge 
  
    
  end
  
end