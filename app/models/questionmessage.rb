class Questionmessage < ApplicationRecord
  belongs_to :classsession
  belongs_to :student, optional: true
  has_one :answermessage
end
