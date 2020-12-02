require "yaml"

class Pet
  attr_accessor :name, :user_login, :lives, :response, :img, :states

  def initialize(name, user_login)
    @user_login = user_login
    @name = name
    @health = 10
    @asleep = false
    @feed_level = 6
    @fullness = 0
    @water_level = 6
    @energy = 10
    @mood = 6
    @lives = 3
    @states = [ "health = #{@health}", "feed_level = #{@feed_level}", 
      "water_level = #{@water_level}", "energy = #{@energy}", "mood = #{@mood}"]
    @response = []
    @img = '&#128522;'
    save
  end

  def feed
    if @feed_level < 10
        @feed_level += 4
        @fullness += 2
        @mood += 1
        @response << "You fed your pet."
        @img = '&#128525;'
    else
        @response << "Your pet is not hungry."
        @img = '&#128528;'
    end
    time_passed
    save
  end

  def water
    if @water_level < 10
        @water_level += 4
        @mood += 1
        @response << "Your pet drank water."
        @img = '&#128525;'
    else
        @response << "Your pet is not thirsty."
        @img = '&#128528;'
    end
    time_passed
    save
  end

  def sleep
    if (@energy < 7) & (@asleep == false)
        @energy += 6
        @asleep = true
        @response << "You put your pet to bed."
        @img = '&#128564;'
    elsif @asleep
        @response << "Your pet is already sleeping."
        @img = '&#128564;'
    else
        @response << "Your pet doesn't want to sleep."
        @img = '&#128580;'
    end
    time_passed
    save
  end

  def toilet
    if @fullness > 5
        @fullness = 0
        @response << 'Your pet went to the toilet.'
        @img = '&#128169;'
    else 
        @response << "Your pet doesn't want to use the toilet."
        @img = '&#128530;'
    end
    time_passed
    save
  end

  def play
    @response << 'You are playing with your pet.'
    @mood += 2
    @energy -= 1
    @img = '&#128516;'
    time_passed
    save
  end

  def wake
    if @asleep
        @asleep = false
        @response << "#{@name} wakes up."
        @img = '&#128524;'
    else
        @response << 'You pet is not sleeping.'
        @img = '&#128580;'
    end
  end

  def help
    puts 'feed - to feed your pet'
    puts 'water - to give a pet to drink'
    puts 'sleep - to put your pet to bed'
    puts 'toilet - to use the toilet'
    puts 'play - to play with pet'
    puts 'status - shows pet condition'
    puts 'wake - to wake pet'
    puts 'observe - to observe pet'
    puts 'help - shows command list'
    puts 'exit - exit the game'
  end

def kill(user_login)
  if is_user_superadmin?(user_login)
    puts "#{@name} killed."
    @lives = 0
  end
  save
end

def is_dead?
  @lives == 0
  save
end

def save
  name = self.user_login
  yaml = YAML.dump(self)
  File.open("./data/#{name}.yml", 'w') { |file| file.puts(yaml) }
end

  private

  def hungry?
    @feed_level <= 3
  end

  def poopy?
    @fullness >= 8
  end

  def thirsty?
    @water_level <= 2
  end

  def sleepy?
    @energy <= 2
  end

  def boring?
    @mood < 5
  end

  def time_passed
    @feed_level -= 1
    @fullness += 1
    @water_level -= 1
    @energy -= 1
    @mood -= 1
    health_change
    needs
    death
  end

  def update_states
    @states = [ "health = #{@health}", "feed_level = #{@feed_level}", 
      "water_level = #{@water_level}", "energy = #{@energy}", "mood = #{@mood}"]
    end

  def health_change
    if (@feed_level < 5) or (@water_level < 5) or (@energy < 5) or (@mood < 5)
        @health -= 1
    elsif (@feed_level > 6) & (@water_level > 6) & (@energy > 6) & (@mood > 6)
        @health += 1
    end
  end

  def death
    if @health == 0
        @lives -= 1
        puts "Your pet is dead. Lives left #{@lives}"
        @health = 10
        @asleep = false
        @feed_level = 6
        @fullness = 0
        @water_level = 6
        @energy = 8
        @mood = 6
        @img = '&#128128;'
        save
    end
  end
            
  def needs
    @response << "#{@name} feels bad." if @health < 5
    @response << "#{@name} wants to eat." if hungry?
    @response << "#{@name} wants to drink." if thirsty?
    @response << "#{@name} wants to go to the toilet." if poopy?
    @response << "#{@name} bored." if boring?
    @response << "#{@name} wants to sleep." if sleepy?
    @response.each{ |r| puts Array(r).join }
    update_states
  end
end
