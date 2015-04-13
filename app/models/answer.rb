class Answer < ActiveRecord::Base
  # This assumes that this model has a field
  # called question_id that is an integer
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
end
