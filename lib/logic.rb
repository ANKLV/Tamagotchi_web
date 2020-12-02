require 'rack'
require 'erb'
require_relative 'pet'
require_relative 'panda'
require_relative 'tiger'
require_relative '../users/session'

class Controller
  attr_reader :pet 

  def call(env)
    if env["PATH_INFO"].include?('auth')
      @user = InitGame.new.init_user(env)
    end

    unless @user
      response = InitGame.new.render_auth 
      return  [200, {}, [response]]
    end

    if @user.user_pet
      pet_controller = PetController.new(@user.user_pet)
      pet_controller.execute_command(env["PATH_INFO"])
      return [200, {}, [pet_controller.render_pet]]
    else
      if env["PATH_INFO"].include?('init_pet')
        pet = InitGame.new.init_pet(env, @user)   
        pet_controller = PetController.new(@user.user_pet)
        return [200, {}, [pet_controller.render_pet]]   
      else
        return [200, {}, [InitGame.new.render_init_pet]]
      end
    end  
  end  
end

class PetController
    attr_accessor :pet

    def initialize(pet)
        @pet = pet
    end

    def render_pet
        path = File.expand_path("../../app/views/layout.html.erb", __FILE__)
        ERB.new(File.read(path)).result(binding)
      end
    
    def execute_command(request_path)
        if @pet.is_dead? 
            @pet.response = ['Your pet have died']
        end   
        @pet.response = [] unless request_path == '/'
        command = request_path.delete('/')
        case command
        when 'feed'
            @pet.feed
        when 'water'
            @pet.water
        when 'toilet'
            @pet.toilet
        when 'sleep'
            @pet.sleep
        when 'wake'
            @pet.wake 
        when 'play'
            @pet.play
        when 'status'
            p @pet
        when 'observe'
            @pet.random
        end    
    end
end

class InitGame
  def init_pet(env, user)
    form = env['rack.input'].read 
    pet_params = Rack::Utils.parse_nested_query(form)
    if pet_params['type'] == 'panda'
      pet = Panda.new(pet_params['name'], user.login)
    else pet_params['type'] == 'tiger'
      pet = Tiger.new(pet_params['name'], user.login)
    end        
    pet
  end
  
  def init_user(env)
    form = env['rack.input'].read 
    user_params = Rack::Utils.parse_nested_query(form)
    @user = Session.new(user_params['login'], user_params['password'] ).log_in  
  end

  def render_auth
    path = File.expand_path("../../app/views/auth.html.erb", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def render_init_pet
    path = File.expand_path("../../app/views/init_pet.html.erb", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end      
end