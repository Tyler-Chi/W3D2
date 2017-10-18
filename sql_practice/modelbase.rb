require 'active_support/inflector'

class ModelBase

  def self.find_by_id(id)
    the_class = self.class.to_s
    the_class.downcase! #we lower case everything
    if the_class[-1] == 'y'
        the_class = the_class[0...-1] + 'ies'
    else
        the_class += 's'
    end



    #now if it is an instance of User, we now have users



    info = QuestionsDatabase.instance.execute(<<-SQL, id)



    SELECT *
    FROM users
    WHERE id = ?
    SQL

    self.class.new(info.first)

    end
  end

  def self.all

  end



end
