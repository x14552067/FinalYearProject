class Classgroup < ApplicationRecord
  belongs_to :lecturer
  has_and_belongs_to_many :students
  has_many :classsessions
  has_many :quizzes

  validates :class_name, presence: true, length: {minimum: 3}
  validates :class_description, presence: true, length: {minimum: 5, maximum: 10}
  validates :course_name, presence: true, length: {minimum: 3}

end
