class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    like          = current_user.likes.new
    question      = Question.find params[:question_id]
    like.question = question
    if like.save
      redirect_to question, notice: "Liked!"
    else
      redirect_to question, alert: "Can't Like!"
    end
  end

  def destroy
    like = current_user.likes.find params[:id]
    like.destroy
    redirect_to like.question, notice: "Unliked"
  end
end
