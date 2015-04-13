class FavouritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favourited_questions = current_user.favourited_questions
  end

  def create
    question           = Question.find params[:question_id]
    favourite          = current_user.favourites.new
    favourite.question = question
    if favourite.save
      redirect_to question, notice: "Favourited!"
    else
      # redirect_to something
      # if the something is a ActiveRecord object 
      # Rails will redirect to the assiciated controller show action
      # for instance if teh objecet is post it will redirect to post_path(post)
      # in this case it will redirect to question_path(question)
      redirect_to question, alert: "Not Favourited! It may be already in your favourites"
    end
  end

  def destroy
    favourite = current_user.favourites.find params[:id]
    favourite.destroy
    redirect_to favourite.question, notice: "UnFavourited"
  end

end
