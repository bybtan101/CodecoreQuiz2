class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  # this means that the combination: user_id / question_id
  # must be unique. user_id or question_id don't have to be
  # unique by themselves.
  validates :user_id, uniqueness: {scope: :question_id}

end
