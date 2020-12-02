require_relative 'pet'
class Tiger < Pet
    REACTIONS = [
        ['The tiger begins to lick its fur.'],
        ['You watch the tiger hide and listen to the sounds.'], 
        ['You see how a tiger sharpens its claws on the bark of a tree.']
    ].freeze

  def initialize(name, login)
      super
      save
  end

  def random
    @response << REACTIONS.sample
    @img = '&#128047;'
    time_passed
    save
  end

  def reset(user_login)
    return puts("not_allowed") unless is_user_superadmin?(user_login)
    self.class.new(self.name, self.user_login)
  end

  def change_type(user_login)
    return puts("not_allowed") unless is_user_admin?(user_login)
    Panda.new(self.name)
  end
end