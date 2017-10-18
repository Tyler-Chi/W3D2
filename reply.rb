class Reply
  attr_accessor :id,:body, :user_id, :question_id, :parent_reply_id

  def initialize(object)
    @id = object['id']
    @body = object['body']
    @user_id = object['user_id']
    @question_id = object['question_id']
    @parent_reply_id = object['parent_reply_id']
  end

  def self.find_by_id(id)
    info = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM replies
      WHERE id = ?
      SQL
    Reply.new(info.first)
  end

  def self.find_by_user_id(user_id)
    info = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT *
      FROM replies
      WHERE user_id = ?
      SQL
    info.map{|reply_info| Reply.new(reply_info)}
  end

  def self.find_by_question_id(question_id)
    info = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT *
      FROM replies
      WHERE question_id = ?
      SQL
    info.map{|reply_info| Reply.new(reply_info)}
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    return nil if @parent_reply_id.nil?

    Reply.find_by_id(@parent_reply_id)
  end

  def child_replies
    the_reply = QuestionsDatabase.instance.execute(<<-SQL,@id)
      SELECT *
      FROM replies
      WHERE parent_reply_id = ?
      SQL

    Reply.new(the_reply.first)
  end

  def save
    unless @id.nil?
      QuestionsDatabase.instance.execute(<<-SQL,@body, @question_id, @parent_reply_id, @user_id)
        UPDATE questions
        SET body = ?, question_id = ?, @parent_reply_id = ?, user_id = ?
        WHERE @id = questions.id
      SQL
    else
      #we perform the update
      QuestionsDatabase.instance.execute(<<-SQL,@body,@user_id)
        INSERT INTO
          questions(body, question_id, parent_reply_id, user_id)
        VALUES
          ( ? , ? , ?)
      SQL

      a = QuestionsDatabase.instance.execute(<<-SQL,@body,@user_id)
        SELECT
          questions.id
        FROM
          questions
        WHERE
          body = ? AND question_id = ? AND parent_reply_id = ? AND user_id = ?
      SQL
      @id = a.first.values.first
    end


end
