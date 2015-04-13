class ContactController < ApplicationController

  # controller use application.html.erb inside of views/layouts
  # as the default layout, unless you specify something like:
  # layout "special"
  # then this will use views/layouts/special.html.erb
  # for all the actions inside this controller

  def index
    @questions = Question.all
    @votes = Vote.all
    @likes = Like.all
    # This will render views/contact/index.html.erb
    # within layout: views/layouts/application.html.erb
    # unless you specify something like:
    # render :index, layout: "special"

    # if you put something like:
    # render :abc
    # This will render: views/contact/abc.html.erb
    # instead of: views/contact/index.html.erb

    # if you access the page as:
    # http://localhost:3000/contact.xml
    # then it will render:
    # views/contact/index.xml.erb

  end

  def create
    @name    = params[:full_name]
    @email   = params[:email]
    @message = params[:message]
  end


end
