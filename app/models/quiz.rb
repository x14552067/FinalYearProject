class Quiz < ApplicationRecord
  belongs_to :classgroup
  belongs_to :classsession, optional: true
  has_many :quizquestions

  validates :quiz_name, presence: true

end
