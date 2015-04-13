class WelcomeController < ApplicationController


  layout "external"

  def index
  	@questions = Question.all
  end

  def show
    @name = params[:name]
  end

  def hello

  end

  def question
  	@question = params[:question]
  end

end
