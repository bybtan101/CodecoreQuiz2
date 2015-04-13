class Question < ActiveRecord::Base


  # This assumes you have a model called "answer"
  # it also assumes that the model has a field called
  # question_id which is an integer
  # dependent is an option that takes an argument:
  # :destroy: will destroy all the answers with this
  #           records id (in question_id)
  # :nullify: will make the question_id field
  #           nil for associated answers
  has_many :answers, dependent: :destroy

  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :favourites, dependent: :destroy
  has_many :favourited_users, through: :favourites, source: :user

  has_many :votes, dependent: :destroy
  has_many :voted_users, through: :votes, source: :user


  belongs_to :user

  validates :title, presence:   {message: "must be provided."}, 
                    uniqueness: {case_sensitive: false},
                    length:     {minimum: 10}

  validates :body, presence: true

  validates :view_count, numericality: {greater_than_or_equal_to: 0}

  validate :stop_words

  # the set_defaults method will be called after a new object
  # is initialized, for instance, after calling:
  # q = Question.new
  after_initialize :set_defaults

  scope :recent, lambda { order("updated_at DESC") }
  # this is the same as doing
  # def self.recent
  #   order("updated_at DESC")
  # end

  scope :recent_ten, lambda { recent.limit(10) }

  # taking an argument for scope
  scope :most_recent, lambda { |n| recent.limit(n)  }
  # this is the same as doing
  # def most_recent(n)
  #   recent.limit(n)
  # end

  # scope that gives back the questions created in the last three days
  scope :last_three_days, lambda { where("created_at >= ?", 3.days.ago) }

  # scope that gives back the questions created in the last ten days
  # using a range instead of using >=
  scope :last_ten_days, lambda { where(created_at: 
                                  (Time.now - 10.days)..(Time.now)) }

  # Write a scope or a method that gives the questions created
  # in the last X days. callit: days_ago
  def self.days_ago(n)
    where("created_at >= ?", n.days.ago)
  end


  # this will call the capitalize_title method
  # right before saving the record
  before_save :capitalize_title

  # If you have an email you can validate the format of that emal
  # using regular expressions as in:
  # validates :email, format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  # this validates the the title/body combintation is unqiue
  # This means that body doesn't have to be unique by itself
  # same for title. But the combination has to be unique
  #  validates :body, uniqueness: {scope: :title}

  def self.search(search_term)
    Question.where("title ILIKE ? OR body ILIKE  ?", 
                        "%#{search_term}%", "%#{search_term}%")
  end

  def increment_view_count
    # You normally need to use self. if you're setting an attribute
    # if you reading an attribute or calling a method then the self.
    # is not needed.
    # self.view_count += 1
    # save
    increment!(:view_count)
  end

  def like_for(user)
    likes.find_by_user_id(user.id) if user
  end

  def favourite_for(user)
    favourites.find_by_user_id(user.id) if user
  end

  def vote_for(user)
    votes.find_by_user_id(user.id) if user
  end

  def votes_count
    votes.up.count - votes.down.count
  end

  private

  def set_defaults
    self.view_count ||= 0
  end

  def capitalize_title
    self.title.capitalize!
  end

  def stop_words
    if title.present? && title.include?("monkey")
      # this adds error to the errors object for this activerecord
      # object. Errors are added to a specific attribute. In this case
      # the attribute is :title. If you don't want to attach the error
      # to a specific attribute. Then use :base
      errors.add(:base, "Please don't put monkey in title")
    end
  end

end


# this is fine
# def search(user_input) 
#   Question.where("title ILIKE ?", "%#{user_input}%")
# end

# Don't do this - Possible SQL Injection Exploit
# def search(user_input) 
#   Question.where("title ILIKE '%#{user_input}%'")
# end