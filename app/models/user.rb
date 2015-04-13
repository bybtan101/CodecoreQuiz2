class User < ActiveRecord::Base
  has_many :questions, dependent: :nullify
  has_many :answers,   dependent: :nullify

  has_many :likes, dependent: :destroy
  # we can't do has_many :questions because this has been used in
  # a line above. We must give it another label and in order
  # for that to work we must provide the :source option
  has_many :liked_questions, through: :likes, source: :question

  has_many :favourites, dependent: :destroy
  has_many :favourited_questions, through: :favourites, source: :question

  has_many :votes, dependent: :destroy
  has_many :voted_questions, through: :votes, source: :question

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def name_display
    if first_name || last_name
      "#{first_name} #{last_name}".strip.squeeze(" ")
    else
      email
    end
  end
end
