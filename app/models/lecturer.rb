class Lecturer < ApplicationRecord
  has_one :User
  has_many :class_groups
end
