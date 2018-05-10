class UnderstandingResponse < ApplicationRecord
  belongs_to :understanding_poll
  belongs_to :student
end
