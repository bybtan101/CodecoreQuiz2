class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    vote = current_user.votes.new vote_params
    question = Question.find params[:question_id]
    vote.question = question
    if vote.save
      redirect_to question, notice: "Voted!"
    else
      redirect_to question, alert: "Can't Vote"
    end
  end

  def update
    vote = current_user.votes.find params[:id]
    if vote.update vote_params
      redirect_to vote.question, notice: "Vote Changed"
    else
      redirect_to vote.question, notice: "Can't Change Vote"
    end
  end

  def destroy
    vote = current_user.votes.find params[:id]
    vote.destroy
    redirect_to vote.question, notice: "Vote removed"
  end

  private

  def vote_params
    params.require(:vote).permit(:is_up)
  end

end
