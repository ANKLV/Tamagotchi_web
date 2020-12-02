require 'rack/reloader'
require_relative './lib/logic'

use Rack::Reloader, 0
run Controller.new