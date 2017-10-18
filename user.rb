class User > ModelBase
  attr_accessor :id, :fname, :lname
  def initialize(object)
    @id = object['id']
    @fname = object['fname']
    @lname = object['lname']
  end
  def self.find_by_id(id)
    info = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT *
    FROM users
    WHERE id = ?
    SQL
    User.new(info.first)
  end
  def self.find_by_name(fname, lname)
    info = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT *
    FROM users
    WHERE fname = ? AND lname = ?
    SQL
    User.new(info.first)
  end
  def authored_questions
    Question.find_by_author_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    Question_Like.liked_questions_for_user_id(@id)
  end

  def self.show
    QuestionsDatabase.instance.execute(<<-SQL)
      SELECT *
      FROM users
    SQL
  end

  def save
    unless @id.nil?
      QuestionsDatabase.instance.execute(<<-SQL,@fname,@lname)
        UPDATE users
        SET fname = ?, lname = ?
        WHERE @id = users.id
      SQL
    else
      #we perform the update
        QuestionsDatabase.instance.execute(<<-SQL,@fname,@lname)

        INSERT INTO
          users(fname,lname)
        VALUES
          ( ? , ? )
        SQL

        a = QuestionsDatabase.instance.execute(<<-SQL,@fname,@lname)
          SELECT
            users.id
          FROM
            users
          WHERE
            fname = ? AND lname = ?
          SQL

          @id = a.first.values.first
    end
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def average_karma
    #average number of likes for a users question
    #we count number of questions / the sum all their questions likes
    output = []
    info = QuestionsDatabase.instance.execute(<<-SQL,@id)
    --sum of all of their question likes
    SELECT CAST (COUNT(questions.user_id) AS FLOAT) / COUNT(DISTINCT(questions.id) )
    FROM question_likes
    JOIN questions ON question_likes.question_id = questions.id
    WHERE questions.user_id = ?
    SQL
    info.first.values[0]
  end
end
