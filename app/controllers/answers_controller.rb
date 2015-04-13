class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question        = Question.find params[:question_id]
    @answer          = Answer.new(answer_params)
    @answer.user     = current_user
    # You can combine the two lines above in a signle line:
    # @answer = current_user.answers.new(answer_params)
    @answer.question = @question
    if @answer.save
      # redirect_to @question
      redirect_to question_path(@question), 
                    notice: "Answer created!"
    else
      # this will render the view file show.html.erb
      # inside questions folder
      render "questions/show"
    end
  end

  def destroy
    @question = Question.find params[:question_id]
    @answer = Answer.find params[:id]
    @answer.destroy
    redirect_to question_path(@question), 
                  notice: "Answer deleted"
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
