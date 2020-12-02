require 'yaml'

class User
  
  attr_accessor :login, :password

  def initialize(login, password)
    @login = login
    @password = password
  end
 
  def exists?(users_array)
    users_array.any? { |h| h[:login] == @login }
  end

  def correct?(users_array)
    users_array.any? { |h| h[:login] == @login && h[:password] == @password }    
  end

  def save
    user = {
      login: @login,
      password: @password,
    }
    users_array = load_users

    if !exists?(users_array)
      users_array << user
      File.open("#{self.class.root}/../data/users.yml", 'w') { |file| file.puts(users_array.to_yaml) }
    end  
  end

  def load_users
    YAML.load(File.read("#{self.class.root}/../data/users.yml")) || []
  rescue
    []
  end

  def has_pet?
    File.exists?("#{self.class.root}/../data/#{self.login}.yml")
  end

  def load_pet
    YAML.load(File.read("#{self.class.root}/../data/#{self.login}.yml"))
  end

  def user_pet
    has_pet? ? load_pet : nil
  end

  def self.root
    File.expand_path '..', __FILE__
  end
end