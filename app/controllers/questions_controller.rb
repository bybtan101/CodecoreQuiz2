class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  QUESTIONS_PER_PAGE = 20

  # this means that before the actions specific in the :only array
  # the method "find_quesiton" will be called
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  # this will be invoied with 
  # GET        request
  # /questions URL
  def index
    @questions = Question.page(params[:page]).per(QUESTIONS_PER_PAGE)
    # if params[:search]
    #   @questions = Question.search(params[:search])
    # else
    #   @questions = Question.all
    # end
  end

  def new
    # instantiating a new question (model) object
    # this will be useful to easily generate the form
    # the will be used to create the question
    @question = Question.new
  end

  # This will be called when the URL is:
  # METHOD: Post
  # URL   : /questions
  def create
    # params[:question] looks like:
    # {"title"=>"another question", "body"=>"asd fasf asdf asdf asdf "}
    
    # intantiating a new question object with the parameters
    # we got from the user
    # using current_user.questions.new instead of Question.new
    # makes the instantiated question associated with the current_user
    @question = current_user.questions.new(question_params)
    
    # Saving the question record
    if @question.save
      # Redirect to the show page for the created question
      flash[:notice] = "Question Created Successfully!"
      # redirect_to question_path(id: @question.id)
      redirect_to question_path(@question)
    else
      # Show the form again with errors displayed at top
      # You can also do:
      # render "questions/new"
      # but it's redudent as the questions/ is implied by convention
      # with Rails
      render :new
    end
  end

  # This will be called when the URL is:
  # METHOD: GET
  # URL   : /questions/:id
  # for instance: /questions/5
  def show
    # this will print part of the Rails logs
    # there are different levels of Rails logs:
    # info / debug / error
    Rails.logger.info ">>>>>>>>>>>>>>>> #{@question.title}"

    @like      = @question.like_for(current_user)      if user_signed_in?
    @favourite = @question.favourite_for(current_user) if user_signed_in?
    @vote      = @question.vote_for(current_user)      if user_signed_in?
    @question.increment_view_count
    # Instantiating an empty answer object to be used
    # with the form that creates an answer on the 
    # the question show page
    @answer = Answer.new
    # You can put byebug anywhere in your code and the execution
    # will stop and you will have the option to insepct and play
    # with you code in the Rails console
    # byebug

    # this will open up Pry in Rails console
    # similar to byebug with all the features
    # from Pry
    # binding.pry
    
  end

  # This will be called when the URL is:
  # METHOD: GET
  # URL   : /questions/:id/edit
  # for instance: /questions/5/edit
  def edit
  end

  # This will be called when the URL is:
  # METHOD: PATCH (or PUT)
  # URL   : /questions/:id
  # for instance: /questions/5
  def update
    # update method in ActiveRecord takes a hash like
    # {title: "abc", body: "asdfasdf"}
    if @question.update(question_params)
      # redirect_to question_path(@question)
      redirect_to @question, notice: "Question updated successfully!"
    else
      flash[:alert] = "Please correct errors below"
      render :edit
    end
  end

  # This will be called when the URL is:
  # METHOD: DELETE
  # URL   : /questions/:id
  # for instance: /questions/5
  def destroy
    @question.destroy
    redirect_to questions_path, notice: "Question deleted successfully!"
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    # This uses a feature called "Strong Parameters" introduced
    # to Rails by version 4. It makes you be explicit about
    # the parameters you want the user to be able to create/edit.
    # in the case below I'm requireing that there is a key
    # called question and inside I'm allowing only :title and :body
    # parameters to be created 
    params.require(:question).permit(:title, :body, {category_ids: []})
  end

end
