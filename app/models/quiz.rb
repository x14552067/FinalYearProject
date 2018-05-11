class Quiz < ApplicationRecord
  belongs_to :classgroup
  has_and_belongs_to_many :classsession, optional: true
  has_many :quizquestions

  validates :quiz_name, presence: true

end
