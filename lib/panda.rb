require_relative 'pet'
class Panda < Pet
    REACTIONS = [
        ['Panda looks at you in surprise.'],
        ['You watch the panda roll back and forth on the ground.'], 
        ['You see a panda walking back and forth looking for something to do.']
    ].freeze

  def initialize(name, login)
      super
      save
  end

  def random
    @response <<  REACTIONS.sample
    @img = '&#128060;'
    time_passed
    save
  end

  def reset(user_login)
    return puts("not_allowed") unless is_user_superadmin?(user_login)
    self.class.new(self.name, self.user_login)
  end

  def change_type(user_login)
    return puts("not_allowed") unless is_user_admin?(user_login)
    Tiger.new(self.name, self.user_login)
  end
end