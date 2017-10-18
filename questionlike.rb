class Question_Like
  attr_accessor :user_id,:question_id

  def initialize(object)
    @user_id = object['user_id']
    @question_id = object['question_id']
  end

  # def self.find_by_user_id(user_id)
  #   info = QuestionsDatabase.instance.execute(<<-SQL, user_id)
  #     SELECT *
  #     FROM question_likes
  #     WHERE user_id = ?
  #     SQL
  #   Reply.new(info.first)
  # end

  def self.most_liked_questions(n)
    array = QuestionsDatabase.instance.execute(<<-SQL,n)
      SELECT *
      FROM users
      JOIN question_likes ON user_id = id

      GROUP BY question_likes.question_id
      ORDER BY COUNT(user_id) DESC
      LIMIT ?
    SQL

    array.map{|info| Question.new(info)}
  end

  def self.likers_for_question_id(question_id)
    #return an array of users
    array = QuestionsDatabase.instance.execute(<<-SQL ,question_id)
      SELECT *
      FROM users
      JOIN question_likes ON user_id = id

      WHERE  question_id = ?
    SQL
    array.map{|info| User.new(info)}
  end

  def self.num_likes_for_question_id(question_id)
    array = QuestionsDatabase.instance.execute(<<-SQL ,question_id)
      SELECT COUNT(user_id)
      FROM users
      JOIN question_likes ON user_id = id

      WHERE  question_id = ?
    SQL
    array.first.values[0]

  end

  def self.liked_questions_for_user_id(user_id)
    #this should return an array of questions
    array = QuestionsDatabase.instance.execute(<<-SQL , user_id)
      SELECT *
      FROM questions
      JOIN question_likes ON question_id = questions.id

      WHERE  question_likes.user_id = ?
    SQL
    array.map{|info| Question.new(info)}
  end

end
