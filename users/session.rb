require_relative 'user.rb'

class Session

  def initialize(login, password)
    @login = login
    @password = password
  end

  def log_in
    user = User.new(@login, @password)
    if user.exists?(user.load_users)
      return nil unless user.correct?(user.load_users)
    else
        user.save
    end
    user
  end
end