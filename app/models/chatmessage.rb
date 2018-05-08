class Chatmessage < ApplicationRecord
  belongs_to :classsession
  belongs_to :student, optional: true
  belongs_to :lecturer, optional: true

  validates :content, presence: true
end
