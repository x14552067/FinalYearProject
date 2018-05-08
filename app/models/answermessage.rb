class Answermessage < ApplicationRecord
  belongs_to :classsession
  belongs_to :lecturer, optional: true
  belongs_to :questionmessage, optional: true
end
