require_relative 'questionsdb'
require_relative 'user'
require_relative 'questionfollow'
require_relative 'reply'
require_relative 'questionlike'


class Question
  attr_accessor :id, :title, :body, :user_id

  def initialize(object)
    @id = object['id']
    @title = object['title']
    @body = object['body']
    @user_id = object['user_id']
  end

  def likers
    Question_Like.likers_for_question_id(@id)
  end

  def num_likes
    Question_Like.num_likes_for_question_id(@id)
  end

  def self.most_liked(n)
    Question_Like.most_liked_questions(n)
  end

  def self.find_by_id(id)
    info = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM questions
      WHERE id = ?
      SQL
    Question.new(info.first)
  end

  def save
    unless @id.nil?
      QuestionsDatabase.instance.execute(<<-SQL,@title,@body,@user_id)
        UPDATE questions
        SET title = ?, body = ?, user_id = ?
        WHERE @id = questions.id
      SQL
    else
      #we perform the update
      QuestionsDatabase.instance.execute(<<-SQL,@title,@body,@user_id)
        INSERT INTO
          questions(title, body, user_id)
        VALUES
          ( ? , ? , ?)
      SQL

      a = QuestionsDatabase.instance.execute(<<-SQL,@title,@body,@user_id)
        SELECT
          questions.id
        FROM
          questions
        WHERE
          title = ? AND body = ? AND user_id = ?
      SQL
      @id = a.first.values.first
    end

  def self.find_by_author_id(author_id)
    output = []
    info = QuestionsDatabase.instance.execute(<<-SQL,author_id)
    SELECT *
    FROM questions
    WHERE user_id = ?
    SQL
    info.each do |question_information|
      output << Question.new(question_information)
    end
    output
  end

  def author
    User.find_by_id(@user_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

end
