class QuestionFollow
  attr_accessor :user_id, :question_id
  def initialize(object)
    @user_id = object['user_id']
    @question_id = object['question_id']
  end

  def self.followers_for_question_id(question_id)
    array = QuestionsDatabase.instance.execute(<<-SQL ,question_id)
      SELECT *
      FROM users
      JOIN question_follows ON id = user_id
      WHERE question_id = ?
    SQL
    array.map{|info| User.new(info)}
  end

  def self.followed_questions_for_user_id(user_id)
    #return an array of question objects
    array = QuestionsDatabase.instance.execute(<<-SQL ,user_id)
      SELECT *
      FROM questions
      JOIN question_follows ON id = question_id
      WHERE questions.user_id = ?
    SQL
    array.map{|info| Question.new(info)}
  end

  def self.most_followed_questions(n)
    #get an array of questions, sorted by how many followers they have
    #from that array, we will take(n)

    array = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT *
      FROM questions
      JOIN question_follows ON id = question_id
      GROUP BY id
      ORDER BY COUNT(questions.user_id)
    SQL
    array.map{|info| Question.new(info)}.take(n)
  end
end
