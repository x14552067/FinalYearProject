class Quizquestion < ApplicationRecord
  belongs_to :quiz
  has_many :quizquestionresponse

  validates :question_text, presence: true
  validates :question_answer, presence: true

end
