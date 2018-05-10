class UnderstandingPoll < ApplicationRecord
  belongs_to :classsession
  has_many :understanding_responses
end
