class Enrollment < ApplicationRecord
  validates :enrollment_key, presence: true
end
