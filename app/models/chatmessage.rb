class Chatmessage < ApplicationRecord
  belongs_to :classsession
  belongs_to :student
  belongs_to :lecturer
end
