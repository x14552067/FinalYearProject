class Classgroup < ApplicationRecord
  belongs_to :lecturer
  has_and_belongs_to_many :students
  has_many :classsessions
end
