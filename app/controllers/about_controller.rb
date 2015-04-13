# All controllers have the suffix: Controller
# They should inhert from classes that eventually inherit from
# ActionController::Base
# Most likely controllers will inhers from ApplicationController
# to generate this controller (inside bash):
# bin/rails g controller about
class AboutController < ApplicationController
  
  # This is a method defined within the AboutController
  # This is called "Action"
  # So the route:   get "/about" => "about#index"
  # Will call this method
  def index

  end

end
