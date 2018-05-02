class Student < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :class_groups
  has_many :student_responses
end
