class Lecturer < ApplicationRecord
  belongs_to :user
  has_many :class_groups
end